import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/common.dart';
import 'invitation_providers.dart';
import 'invitation_tile.dart';

/// The signed-in account's pending invitations (FR-TEN-03).
class InvitationsPage extends ConsumerWidget {
  const InvitationsPage({super.key, this.onAccepted});

  /// See [InvitationTile.onAccepted].
  final VoidCallback? onAccepted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitations = ref.watch(pendingInvitationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.coreL10n.invitationsTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(pendingInvitationsProvider.future),
        child: AsyncBody(
          value: invitations,
          onRetry: () => ref.invalidate(pendingInvitationsProvider),
          data: (items) => items.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 80),
                    MessageView(
                      icon: Icons.mail_outline,
                      message: context.coreL10n.invitationsEmpty,
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    for (final invitation in items)
                      InvitationTile(
                        onAccepted: onAccepted,
                        key: ValueKey(invitation.id),
                        invitation: invitation,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
