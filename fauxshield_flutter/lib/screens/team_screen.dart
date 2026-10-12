import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Team management: members, roles, and invite codes.
class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<WorkspaceMember> _members = <WorkspaceMember>[];
  List<Invitation> _invitations = <Invitation>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _members.isEmpty && _invitations.isEmpty;
      _error = null;
    });
    try {
      final workspaceId = widget.controller.workspaceId;
      final results = await Future.wait(<Future<Object>>[
        client.workspace.members(workspaceId: workspaceId),
        client.workspace.invitations(workspaceId: workspaceId),
      ]);
      if (!mounted) return;
      setState(() {
        _members = results[0] as List<WorkspaceMember>;
        _invitations = results[1] as List<Invitation>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = describeRequestError(error);
        _loading = false;
      });
    }
  }

  Future<void> _run(Future<void> Function() action, String success) async {
    try {
      await action();
      if (mounted) showMessage(context, success);
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          describeRequestError(error),
          error: true,
        );
      }
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = widget.controller.can('teamWrite');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              onPressed: _inviteDialog,
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Invite'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    final pending = _invitations
        .where((invitation) => invitation.status == InvitationStatus.pending)
        .toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: <Widget>[
          SectionCard(
            title: 'Members',
            subtitle: '${_members.length} people can reach this workspace',
            child: _members.isEmpty
                ? const Text('No members yet.')
                : Column(
                    children: <Widget>[
                      for (final member in _members) _memberTile(member),
                    ],
                  ),
          ),
          SectionCard(
            title: 'Pending invitations',
            subtitle: pending.isEmpty
                ? 'No open invitations'
                : '${pending.length} waiting to be redeemed',
            child: _invitations.isEmpty
                ? const Text('Invite a teammate to get started.')
                : Column(
                    children: <Widget>[
                      for (final invitation in _invitations)
                        _invitationTile(invitation),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _memberTile(WorkspaceMember member) {
    final isOwner = member.role == MembershipRole.owner;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Text(
          (member.displayName ?? member.email).characters.first.toUpperCase(),
        ),
      ),
      title: Text(member.displayName ?? member.email),
      subtitle: Text(
        <String>[member.email, roleLabel(member.role)].join(' · '),
      ),
      trailing: widget.controller.can('teamWrite')
          ? PopupMenuButton<String>(
              tooltip: 'Change role',
              onSelected: (value) {
                if (value == 'remove') {
                  _removeMember(member);
                } else {
                  _changeRole(member, MembershipRole.values.byName(value));
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                for (final role in MembershipRole.values)
                  PopupMenuItem<String>(
                    value: role.name,
                    enabled:
                        role != member.role &&
                        (role != MembershipRole.owner || !isOwner),
                    child: Text('Set ${roleLabel(role)}'),
                  ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'remove',
                  enabled: !isOwner,
                  child: const Text('Remove from workspace'),
                ),
              ],
            )
          : null,
    );
  }

  Widget _invitationTile(Invitation invitation) {
    final status = invitation.status;
    final color = switch (status) {
      InvitationStatus.pending => const Color(0xFFB45309),
      InvitationStatus.accepted => const Color(0xFF0F7B4D),
      InvitationStatus.expired => Theme.of(context).colorScheme.outline,
      InvitationStatus.revoked => Theme.of(context).colorScheme.error,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.mail_outline_rounded),
      title: Text(invitation.email),
      subtitle: Text(
        '${roleLabel(invitation.role)} · ${status.name} · '
        'code ${invitation.codePrefix}…',
      ),
      trailing: Pill(
        label: status.name.toUpperCase(),
        color: color,
        dense: true,
      ),
    );
  }

  Future<void> _changeRole(WorkspaceMember member, MembershipRole role) async {
    await _run(
      () => client.workspace.changeRole(
        workspaceId: widget.controller.workspaceId,
        memberId: member.id!,
        role: role,
      ),
      'Role updated.',
    );
  }

  Future<void> _removeMember(WorkspaceMember member) async {
    final confirmed = await confirmAction(
      context,
      title: 'Remove member',
      message:
          '${member.displayName ?? member.email} loses access to this workspace.',
      confirmLabel: 'Remove',
    );
    if (!confirmed) return;
    await _run(
      () => client.workspace.removeMember(
        workspaceId: widget.controller.workspaceId,
        memberId: member.id!,
      ),
      'Member removed.',
    );
  }

  Future<void> _inviteDialog() async {
    final email = TextEditingController();
    var role = MembershipRole.member;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Invite a teammate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LabeledField(
                label: 'Email',
                controller: email,
                hint: 'teammate@company.com',
                keyboardType: TextInputType.emailAddress,
              ),
              DropdownButtonFormField<MembershipRole>(
                initialValue: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: <DropdownMenuItem<MembershipRole>>[
                  for (final value in MembershipRole.values)
                    DropdownMenuItem<MembershipRole>(
                      value: value,
                      child: Text(roleLabel(value)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create invite'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && email.text.contains('@')) {
      try {
        final created = await client.workspace.invite(
          workspaceId: widget.controller.workspaceId,
          email: email.text.trim(),
          role: role,
        );
        if (!mounted) return;
        await _showCodeDialog(created);
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            describeRequestError(error),
            error: true,
          );
        }
      }
    }
    email.dispose();
    _load();
  }

  Future<void> _showCodeDialog(InvitationCreated created) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite code created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Share this code with ${created.invitation.email}:'),
            const SizedBox(height: 12),
            SelectableText(
              created.code,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              created.warning,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: created.code));
              if (context.mounted) {
                Navigator.pop(context);
                showMessage(context, 'Invite code copied.');
              }
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy code'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
