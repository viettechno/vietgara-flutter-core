import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../error_text.dart';
import '../theme.dart';
import 'common.dart';

/// Opens [sheet] as a scrollable modal bottom sheet; resolves to what it pops.
Future<T?> showFormSheet<T>(BuildContext context, Widget sheet) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => sheet,
    );

/// The frame of a create/edit form in a bottom sheet: title, the last
/// error, the fields and a submit button that pops the saved result.
class FormSheet<T> extends StatefulWidget {
  const FormSheet({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    this.submitLabel,
  });

  final String title;

  /// Built with the last failure so fields can show their own issue.
  final List<Widget> Function(ApiException? error) fields;

  /// Saves and returns the result to pop with.
  final Future<T> Function() onSubmit;
  final String? submitLabel;

  @override
  State<FormSheet<T>> createState() => _FormSheetState<T>();
}

class _FormSheetState<T> extends State<FormSheet<T>> {
  final _form = GlobalKey<FormState>();
  bool _busy = false;
  Object? _error;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await widget.onSubmit();
      if (mounted) Navigator.pop(context, result);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(VgRadius.md),
                  ),
                  child: Text(
                    errorText(l10n, _error),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              for (final field in widget.fields(
                _error is ApiException ? _error as ApiException : null,
              )) ...[field, const SizedBox(height: 12)],
              const SizedBox(height: 8),
              BusyButton(
                label: widget.submitLabel ?? l10n.actionSave,
                busy: _busy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
