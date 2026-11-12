import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../auth/auth_repository.dart';
import '../auth/session_controller.dart';
import '../auth/user.dart';
import '../validators.dart';
import '../widgets/common.dart';
import '../widgets/form_sheet.dart';

/// Changing the password of the signed-in user (FR-IAM-13) on the account
/// page. The current password confirms it; every other session is signed out
/// and the answer is a new one. A user with no password signs in with Google
/// only and has nothing to change.
class PasswordSection extends ConsumerWidget {
  const PasswordSection({super.key});

  Future<void> _change(BuildContext context, WidgetRef ref) async {
    final session = await showFormSheet<Session>(
      context,
      const _PasswordSheet(),
    );
    if (session == null) return;
    await ref.read(sessionControllerProvider.notifier).adoptSession(session);
    if (context.mounted) {
      context.showMessage(context.coreL10n.passwordChangedDone);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.coreL10n;
    final user = ref.watch(sessionControllerProvider).value;
    if (user == null || !user.hasPassword) return const SizedBox.shrink();
    return SectionCard(
      title: l10n.passwordSectionTitle,
      children: [
        Text(
          l10n.passwordSectionBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            key: const Key('password-change'),
            onPressed: () => _change(context, ref),
            child: Text(l10n.passwordChange),
          ),
        ),
      ],
    );
  }
}

class _PasswordSheet extends ConsumerStatefulWidget {
  const _PasswordSheet();

  @override
  ConsumerState<_PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends ConsumerState<_PasswordSheet> {
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final validators = Validators(l10n);
    return FormSheet<Session>(
      title: l10n.passwordChange,
      submitLabel: l10n.passwordChange,
      onSubmit: () => ref
          .read(authRepositoryProvider)
          .changePassword(_current.text, _password.text),
      fields: (_) => [
        TextFormField(
          key: const Key('password-current'),
          controller: _current,
          decoration: InputDecoration(labelText: l10n.fieldCurrentPassword),
          autofocus: true,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.password],
          validator: (value) =>
              (value ?? '').isEmpty ? l10n.validationRequired : null,
        ),
        TextFormField(
          key: const Key('password-new'),
          controller: _password,
          decoration: InputDecoration(
            labelText: l10n.fieldNewPassword,
            helperText: l10n.validationPassword,
          ),
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.newPassword],
          validator: validators.password,
        ),
        TextFormField(
          key: const Key('password-confirm'),
          controller: _confirm,
          decoration: InputDecoration(labelText: l10n.fieldConfirmPassword),
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.newPassword],
          validator: validators.sameAs(() => _password.text),
        ),
      ],
    );
  }
}
