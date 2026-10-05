import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api/api_exception.dart';
import '../validators.dart';
import '../widgets/common.dart';
import 'auth_routes.dart';
import 'auth_scaffold.dart';
import 'session_controller.dart';

/// Owner self-registration (FR-IAM-01); the e-mail is verified next.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    for (final controller in [_fullName, _email, _phone, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _issue(String field) => _error is ApiException
      ? (_error as ApiException).fieldIssue(field)
      : null;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .register(
            email: _email.text.trim(),
            password: _password.text,
            fullName: _fullName.text.trim(),
            phone: _phone.text.trim(),
          );
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
      title: l10n.registerTitle,
      error: _error,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fullName,
                  decoration: InputDecoration(
                    labelText: l10n.fieldFullName,
                    errorText: _issue('fullName'),
                  ),
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  validator: validators.required,
                ),
                formGap,
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: l10n.fieldEmail,
                    errorText: _issue('email'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: validators.email,
                ),
                formGap,
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                    labelText: l10n.fieldPhoneOptional,
                    errorText: _issue('phone'),
                  ),
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  textInputAction: TextInputAction.next,
                ),
                formGap,
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: l10n.fieldPassword,
                    helperText: l10n.validationPassword,
                    errorText: _issue('password'),
                  ),
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _submit(),
                  validator: validators.password,
                ),
                const SizedBox(height: 20),
                BusyButton(
                  label: l10n.registerSubmit,
                  busy: _busy,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
        formGap,
        TextButton(
          onPressed: () => context.go(AuthRoutes.login),
          child: Text(l10n.registerHaveAccount),
        ),
      ],
    );
  }
}
