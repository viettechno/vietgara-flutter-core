import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import 'invitation.dart';
import 'invitations_repository.dart';

/// The signed-in account's pending invitations (FR-TEN-03).
final pendingInvitationsProvider = FutureProvider<List<Invitation>>((
  ref,
) async {
  final accountId = await ref.watch(
    sessionControllerProvider.selectAsync((account) => account?.id),
  );
  if (accountId == null) return const [];
  return ref.watch(invitationsRepositoryProvider).listPending();
});
