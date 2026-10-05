import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/json.dart';
import '../providers.dart';
import 'invitation.dart';

String _path(String invitationId) =>
    '/me/invitations/${Uri.encodeComponent(invitationId)}';

/// The signed-in account's invitations to join garages (FR-TEN-03).
class InvitationsRepository {
  const InvitationsRepository(this._api);

  final ApiClient _api;

  Future<List<Invitation>> listPending() async => (await _api.get(
    '/me/invitations',
    query: {'status': InvitationStatus.pending.wire},
  )).list('data', Invitation.fromJson);

  Future<Invitation> accept(String invitationId) async =>
      Invitation.fromJson(await _api.post('${_path(invitationId)}/accept'));

  Future<Invitation> decline(String invitationId) async =>
      Invitation.fromJson(await _api.post('${_path(invitationId)}/decline'));
}

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => InvitationsRepository(ref.watch(apiClientProvider)),
);
