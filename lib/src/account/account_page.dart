import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exception.dart';
import '../auth/account.dart';
import '../auth/session_controller.dart';
import '../validators.dart';
import '../widgets/common.dart';

/// The signed-in account's own profile (FR-IAM-05): name and phone; with
/// [showSettings], also the language and signing out (for apps that have
/// no other place for them).
class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key, this.showSettings = false});

  final bool showSettings;

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  bool _busy = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    final account = ref.read(sessionControllerProvider).value;
    _fullName = TextEditingController(text: account?.fullName ?? '');
    _phone = TextEditingController(text: account?.phone ?? '');
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .updateAccount(
            fullName: _fullName.text.trim(),
            phone: _phone.text.trim(),
          );
      if (mounted) context.showMessage(context.coreL10n.accountSaved);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error);
        context.showError(error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final account = ref.watch(
      sessionControllerProvider.select((session) => session.value),
    );
    final error = _error is ApiException ? _error as ApiException : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoRow(label: l10n.fieldEmail, value: account?.email ?? ''),
            if (account != null && !account.emailVerified)
              Align(
                alignment: Alignment.centerRight,
                child: StatusChip(
                  label: l10n.accountUnverified,
                  tone: ChipTone.warning,
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullName,
              decoration: InputDecoration(
                labelText: l10n.fieldFullName,
                errorText: error?.fieldIssue('fullName'),
              ),
              textCapitalization: TextCapitalization.words,
              validator: Validators(l10n).required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: InputDecoration(
                labelText: l10n.fieldPhone,
                errorText: error?.fieldIssue('phone'),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            BusyButton(label: l10n.actionSave, busy: _busy, onPressed: _save),
            if (widget.showSettings) ...[
              const SizedBox(height: 24),
              const Divider(),
              const LanguageTile(contentPadding: EdgeInsets.zero),
              const SignOutTile(contentPadding: EdgeInsets.zero),
            ],
          ],
        ),
      ),
    );
  }
}

/// Signs out after a confirmation.
class SignOutTile extends ConsumerWidget {
  const SignOutTile({super.key, this.contentPadding});

  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.coreL10n;
    return ListTile(
      contentPadding: contentPadding,
      leading: const Icon(Icons.logout),
      title: Text(l10n.signOut),
      onTap: () async {
        if (await confirm(context, l10n.signOutConfirm)) {
          await ref.read(sessionControllerProvider.notifier).signOut();
        }
      },
    );
  }
}

/// Vietnamese/English: applied at once and saved on the account.
class LanguageTile extends ConsumerWidget {
  const LanguageTile({super.key, this.contentPadding});

  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    contentPadding: contentPadding,
    leading: const Icon(Icons.language),
    title: Text(context.coreL10n.language),
    trailing: SegmentedButton<AppLanguage>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: AppLanguage.vi, label: Text('VI')),
        ButtonSegment(value: AppLanguage.en, label: Text('EN')),
      ],
      selected: {AppLanguage.fromCode(context.languageCode)},
      onSelectionChanged: (selection) async {
        try {
          await ref
              .read(sessionControllerProvider.notifier)
              .changeLanguage(selection.first);
        } catch (error) {
          if (context.mounted) context.showError(error);
        }
      },
    ),
  );
}
