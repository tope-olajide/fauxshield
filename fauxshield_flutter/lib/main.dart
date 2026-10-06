import 'package:flutter/material.dart';

import 'app/app_theme.dart';
import 'client.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/home_shell.dart';
import 'app/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const FauxShieldApp());
}

/// The FauxShield operator app.
class FauxShieldApp extends StatelessWidget {
  const FauxShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FauxShield',
      theme: buildFauxShieldTheme(Brightness.light),
      darkTheme: buildFauxShieldTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SignInScreen(child: WorkspaceGate()),
    );
  }
}

/// Resolves the operator's workspace after sign-in.
///
/// A user without a workspace sees onboarding; everyone else lands in the
/// command center shell.
class WorkspaceGate extends StatefulWidget {
  const WorkspaceGate({super.key});

  @override
  State<WorkspaceGate> createState() => _WorkspaceGateState();
}

class _WorkspaceGateState extends State<WorkspaceGate> {
  final AppController _controller = AppController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.loading && _controller.bootstrap == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_controller.hasWorkspace) {
          return HomeShell(controller: _controller);
        }
        return OnboardingScreen(controller: _controller);
      },
    );
  }
}
