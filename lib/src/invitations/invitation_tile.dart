import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format.dart';
import '../widgets/common.dart';
import 'invitation.dart';
import 'invitation_providers.dart';
import 'invitations_repository.dart';

/// A pending invitation with accept/decline (FR-TEN-03).
class InvitationTile extends ConsumerStatefulWidget {
  const InvitationTile({super.key, required this.invitation, this.onAccepted});

  final Invitation invitation;

  /// Runs once the invitation is accepted, e.g. to reload the app's list of
  /// garages.
  final VoidCallback? onAccepted;

  @override
  ConsumerState<InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends ConsumerState<InvitationTile> {
  bool _busy = false;

  Future<void> _answer({required bool accept}) async {
    setState(() => _busy = true);
    final repository = ref.read(invitationsRepositoryProvider);
    final invitation = widget.invitation;
    try {
      if (accept) {
        await repository.accept(invitation.id);
        if (mounted) {
          context.showMessage(
            context.coreL10n.invitationAccepted(invitation.garageName),
          );
        }
        widget.onAccepted?.call();
      } else {
        await repository.decline(invitation.id);
      }
      ref.invalidate(pendingInvitationsProvider);
    } catch (error) {
      if (mounted) context.showError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final invitation = widget.invitation;
    final details = [
      if (invitation.invitedByName.isNotEmpty)
        l10n.invitationFrom(invitation.invitedByName),
      if (invitation.expiresAt != null)
        l10n.invitationExpires(
          formatDate(invitation.expiresAt, context.languageCode),
        ),
    ].join(' · ');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invitation.garageName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (details.isNotEmpty)
              Text(details, style: Theme.of(context).textTheme.bodySmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _busy ? null : () => _answer(accept: false),
                  child: Text(l10n.invitationDecline),
                ),
                FilledButton.tonal(
                  onPressed: _busy ? null : () => _answer(accept: true),
                  child: Text(l10n.invitationAccept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
