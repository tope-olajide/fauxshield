import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/foundation.dart';

import '../client.dart';

/// Holds the resolved workspace for the signed-in operator.
///
/// The server derives authorization from the membership record on every call;
/// this controller only drives which screen the app shows.
class AppController extends ChangeNotifier {
  WorkspaceBootstrap? _bootstrap;
  bool _loading = false;
  String? _error;

  WorkspaceBootstrap? get bootstrap => _bootstrap;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasWorkspace => _bootstrap != null;
  UuidValue? get workspaceId => _bootstrap?.workspace.id;
  bool get isDemo => _bootstrap?.isDemo ?? false;

  /// True when the role holds [permission].
  bool can(String permission) =>
      _bootstrap?.permissions.contains(permission) ?? false;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _bootstrap = await client.workspace.bootstrap();
    } catch (error) {
      _error = _describe(error);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createWorkspace(String name) async {
    return _run(() async {
      _bootstrap = await client.workspace.create(name);
    });
  }

  Future<bool> joinDemo() async {
    return _run(() async {
      _bootstrap = await client.demo.seed();
    });
  }

  Future<bool> acceptInvitation(String code) async {
    return _run(() async {
      _bootstrap = await client.workspace.acceptInvitation(code);
    });
  }

  void clear() {
    _bootstrap = null;
    _error = null;
    notifyListeners();
  }

  /// Refreshes workspace settings after an update.
  Future<bool> refresh() async {
    return _run(() async {
      _bootstrap = await client.workspace.bootstrap(
        workspaceId: _bootstrap?.workspace.id,
      );
    });
  }

  Future<bool> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (error) {
      _error = _describe(error);
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  static String _describe(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
