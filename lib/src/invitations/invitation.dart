import '../api/json.dart';

enum InvitationStatus {
  pending('INVITATION_STATUS_PENDING'),
  accepted('INVITATION_STATUS_ACCEPTED'),
  declined('INVITATION_STATUS_DECLINED'),
  revoked('INVITATION_STATUS_REVOKED'),
  expired('INVITATION_STATUS_EXPIRED');

  const InvitationStatus(this.wire);

  final String wire;

  static InvitationStatus fromWire(String value) => values.firstWhere(
    (status) => status.wire == value,
    orElse: () => pending,
  );
}

/// An invitation of the signed-in account to join a garage (FR-TEN-03).
class Invitation {
  const Invitation({
    required this.id,
    required this.garageName,
    required this.status,
    this.invitedByName = '',
    this.expiresAt,
  });

  factory Invitation.fromJson(Json json) => Invitation(
    id: json.str('id'),
    garageName: json.str('garageName'),
    status: InvitationStatus.fromWire(json.str('status')),
    invitedByName: json.str('invitedByName'),
    expiresAt: json.time('expiresAt'),
  );

  final String id;
  final String garageName;
  final InvitationStatus status;
  final String invitedByName;
  final DateTime? expiresAt;
}
