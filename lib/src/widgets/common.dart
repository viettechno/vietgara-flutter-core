import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_text.dart';
import '../format.dart';
import '../l10n/core_localizations.dart';
import '../theme.dart';
import 'vg.dart';

/// Shared helpers on [BuildContext]. Apps add their own `l10n` getter for
/// their own strings; the core's strings are [coreL10n].
extension CoreContext on BuildContext {
  CoreLocalizations get coreL10n => CoreLocalizations.of(this);

  String get languageCode => Localizations.localeOf(this).languageCode;

  void showMessage(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void showError(Object error) => showMessage(errorText(coreL10n, error));

  /// [amount] in [currency], formatted for the UI language.
  String money(int amount, {String currency = 'VND'}) =>
      formatMoney(amount, languageCode, currency: currency);
}

/// A centered message with an optional action: empty lists, errors, gates.
/// [icon] is kept for call sites; the illustration replaces it (Design
/// System 4.25: spot illustrations, not icon tiles).
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.error = false,
  });

  final IconData? icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VgIllustration(error: error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: context.vg.mutedForeground,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    error: true,
    message: errorText(context.coreL10n, error),
    actionLabel: context.coreL10n.actionRetry,
    onAction: onRetry,
  );
}

/// Renders an [AsyncValue]: skeleton rows while loading, an [ErrorView] with a
/// retry on error, else [data].
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnRefresh: true,
    skipLoadingOnReload: true,
    data: data,
    loading: () => const SkeletonList(),
    error: (error, _) => ErrorView(error: error, onRetry: onRetry),
  );
}

/// A label above its value, for detail screens.
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? context.coreL10n.notSet : value,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// A titled panel grouping rows of a detail screen: a hairline-bordered
/// card, one level deep (Design System 4.12).
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
          ],
          ...children,
        ],
      ),
    ),
  );
}

enum ChipTone { neutral, info, success, warning, danger }

/// A small status label: a tone-colored fill, an icon and the text, so the
/// state never rests on color alone (Design System 4.13).
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = ChipTone.neutral,
  });

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final vg = context.vg;
    final (background, foreground, icon) = switch (tone) {
      ChipTone.neutral => (
        scheme.surfaceContainerHighest,
        vg.mutedForeground,
        Icons.circle_outlined,
      ),
      ChipTone.info => (vg.infoSubtle, vg.onInfoSubtle, Icons.info_outline),
      ChipTone.success => (
        vg.successSubtle,
        vg.onSuccessSubtle,
        Icons.check_circle_outline,
      ),
      ChipTone.warning => (
        vg.warningSubtle,
        vg.onWarningSubtle,
        Icons.schedule,
      ),
      ChipTone.danger => (
        vg.destructiveSubtle,
        vg.onDestructiveSubtle,
        Icons.error_outline,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(VgRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

/// A button showing a spinner while [busy].
class BusyButton extends StatelessWidget {
  const BusyButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
  );
}

/// Asks a yes/no question; true when confirmed.
Future<bool> confirm(BuildContext context, String message) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.coreL10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.coreL10n.actionConfirm),
          ),
        ],
      ),
    ) ??
    false;
