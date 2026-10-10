import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import 'invitation.dart';
import 'invitations_repository.dart';

/// The signed-in user's pending invitations (FR-TEN-03).
final pendingInvitationsProvider = FutureProvider<List<Invitation>>((
  ref,
) async {
  final userId = await ref.watch(
    sessionControllerProvider.selectAsync((user) => user?.id),
  );
  if (userId == null) return const [];
  return ref.watch(invitationsRepositoryProvider).listPending();
});
