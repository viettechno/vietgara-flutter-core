import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../validators.dart';
import '../widgets/common.dart';
import 'auth_routes.dart';
import 'auth_scaffold.dart';
import 'session_controller.dart';

/// E-mail and password sign-in (FR-IAM-02). Google sign-in stays on the web:
/// the backend accepts the Google result for a single front-end origin.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.allowSignUp = true});

  /// Offers the sign-up screen ([AuthRoutes.register]); off where accounts
  /// are not self-registered (the admin app).
  final bool allowSignUp;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .signIn(_email.text.trim(), _password.text);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final validators = Validators(l10n);
    return AuthScaffold(
      title: l10n.loginTitle,
      error: _error,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('login-email'),
                  controller: _email,
                  decoration: InputDecoration(labelText: l10n.fieldEmail),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: validators.email,
                ),
                formGap,
                TextFormField(
                  key: const Key('login-password'),
                  controller: _password,
                  decoration: InputDecoration(labelText: l10n.fieldPassword),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  validator: validators.required,
                ),
                const SizedBox(height: 20),
                BusyButton(
                  key: const Key('login-submit'),
                  label: l10n.loginSubmit,
                  busy: _busy,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
        formGap,
        TextButton(
          onPressed: () => context.push(AuthRoutes.forgotPassword),
          child: Text(l10n.loginForgot),
        ),
        if (widget.allowSignUp)
          TextButton(
            onPressed: () => context.go(AuthRoutes.register),
            child: Text(l10n.loginNoAccount),
          ),
        const SizedBox(height: 8),
        Text(
          l10n.loginGoogleHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
