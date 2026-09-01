class ScreenTemplates {
  static const login = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t.auth.login.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: t.auth.login.emailLabel),
                    validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(labelText: t.auth.login.passwordLabel),
                    validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.router.pushNamed('/forgot-password'),
                      child: Text(t.auth.login.forgotPassword),
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: call ref.read(authControllerProvider.notifier).login(...)
                            }
                          },
                    child: state.isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(t.auth.login.submit),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.router.pushNamed('/register'),
                    child: Text(t.auth.login.goToRegister),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
''';

  static const register = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.auth.register.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: t.auth.register.nameLabel),
                  validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: t.auth.register.emailLabel),
                  validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: t.auth.register.passwordLabel),
                  validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: call ref.read(authControllerProvider.notifier).register(...)
                          }
                        },
                  child: state.isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(t.auth.register.submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
''';

  static const forgotPassword = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.auth.forgotPassword.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.auth.forgotPassword.instructions),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: t.auth.forgotPassword.emailLabel),
                  validator: (v) => (v == null || v.isEmpty) ? t.auth.errors.required : null,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: call ref.read(authControllerProvider.notifier).sendResetEmail(...)
                          }
                        },
                  child: Text(t.auth.forgotPassword.submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
''';

  static const home = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.router.pushNamed('/profile'),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: state.isLoading,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          // TODO: replace itemCount / itemBuilder with your real list from state.
          itemCount: state.isLoading ? 6 : 0,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: const Text('Placeholder item title'),
              subtitle: const Text('Placeholder subtitle'),
              onTap: () => context.router.pushNamed('/details/\$index'),
            ),
          ),
        ),
      ),
    );
  }
}
''';

  static const details = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/details_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({@PathParam('id') required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(detailsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.details.title)),
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : Text('\${t.details.itemId}: \$id'),
      ),
    );
  }
}
''';

  static const profile = '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';
import '../../../../core/i18n/strings.g.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.profile.title)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(t.profile.editProfile),
                  onTap: () {
                    // TODO: navigate to edit profile
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(t.profile.logout),
                  onTap: () {
                    // TODO: call ref.read(authControllerProvider.notifier).logout()
                  },
                ),
              ],
            ),
    );
  }
}
''';
}
