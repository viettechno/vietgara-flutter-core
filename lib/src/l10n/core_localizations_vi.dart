// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class CoreLocalizationsVi extends CoreLocalizations {
  CoreLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get accountSaved => 'Đã lưu.';

  @override
  String get accountTitle => 'Tài khoản của tôi';

  @override
  String get accountUnverified => 'Email chưa xác minh';

  @override
  String get actionCancel => 'Huỷ';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get actionContinue => 'Tiếp tục';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionSave => 'Lưu';

  @override
  String get appTitle => 'VietGara';

  @override
  String get errorUserSuspended => 'Người dùng đang bị tạm khoá.';

  @override
  String get errorAlreadyExists => 'Dữ liệu đã tồn tại.';

  @override
  String get errorBadRequest => 'Yêu cầu không hợp lệ.';

  @override
  String get errorEmailAlreadyVerified => 'Email đã được xác minh.';

  @override
  String get errorEmailNotVerified => 'Vui lòng xác minh email trước.';

  @override
  String get errorEmailTaken => 'Email đã được đăng ký.';

  @override
  String get errorFailedPrecondition => 'Không thể thực hiện thao tác lúc này.';

  @override
  String get errorGarageAccessDenied => 'Bạn không có quyền truy cập gara này.';

  @override
  String get errorGarageInactive => 'Gara đang ngừng hoạt động.';

  @override
  String get errorGeneric => 'Đã có lỗi xảy ra. Vui lòng thử lại.';

  @override
  String get errorIdempotencyKeyReused =>
      'Thao tác này đã được gửi với thông tin khác. Hãy kiểm tra lại trước khi thử lại.';

  @override
  String get errorInternal => 'Hệ thống đang gặp sự cố. Vui lòng thử lại sau.';

  @override
  String get errorInvalidCredentials => 'Email hoặc mật khẩu không đúng.';

  @override
  String get errorInvitationExpired => 'Lời mời đã hết hạn.';

  @override
  String get errorInvitationNotPending =>
      'Lời mời đã được trả lời hoặc thu hồi.';

  @override
  String get errorNetwork => 'Không kết nối được VietGara. Hãy kiểm tra mạng.';

  @override
  String get errorNotFound => 'Không tìm thấy dữ liệu.';

  @override
  String get errorOtpExpired => 'Mã đã hết hạn. Hãy yêu cầu mã mới.';

  @override
  String get errorOtpInvalid => 'Mã không đúng.';

  @override
  String get errorOtpResendTooSoon => 'Vui lòng chờ trước khi gửi lại mã.';

  @override
  String get errorOtpTooManyAttempts =>
      'Nhập sai quá nhiều lần. Hãy yêu cầu mã mới.';

  @override
  String get errorOwnerOnly => 'Chỉ chủ gara được thực hiện thao tác này.';

  @override
  String get errorPermissionDenied =>
      'Bạn không có quyền thực hiện thao tác này.';

  @override
  String get errorPhoneTaken =>
      'Số điện thoại đã được dùng cho người dùng khác.';

  @override
  String get errorPlanCodeTaken => 'Mã gói đã tồn tại.';

  @override
  String get errorPlanLimitReached =>
      'Đã đạt giới hạn của gói dịch vụ. Hãy nâng cấp gói.';

  @override
  String get errorPlanNotAvailable => 'Không thể chọn gói này.';

  @override
  String get errorRateLimited =>
      'Bạn thao tác quá nhanh, vui lòng thử lại sau.';

  @override
  String get errorRefreshTokenInvalid => 'Phiên đăng nhập đã hết hạn.';

  @override
  String get errorResetTokenInvalid =>
      'Phiên đặt lại mật khẩu đã hết hạn. Hãy làm lại từ đầu.';

  @override
  String get errorSubscriptionReadOnly =>
      'Gói dịch vụ đã quá hạn: chỉ được xem dữ liệu.';

  @override
  String get errorSubscriptionSuspended =>
      'Gói dịch vụ đã bị tạm khoá. Vui lòng gia hạn.';

  @override
  String get errorUnauthenticated =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errorValidation => 'Vui lòng kiểm tra lại thông tin.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldFullName => 'Họ và tên';

  @override
  String get fieldNewPassword => 'Mật khẩu mới';

  @override
  String get fieldOtp => 'Mã 6 chữ số';

  @override
  String get fieldPassword => 'Mật khẩu';

  @override
  String get fieldPhone => 'Số điện thoại';

  @override
  String get fieldPhoneOptional => 'Số điện thoại (không bắt buộc)';

  @override
  String forgotCodeBody(String email) {
    return 'Nhập mã đã gửi tới $email. Nếu không thấy email, hãy kiểm tra thư mục thư rác (Spam/Junk).';
  }

  @override
  String get forgotDone => 'Đã đổi mật khẩu. Hãy đăng nhập bằng mật khẩu mới.';

  @override
  String get forgotEmailBody =>
      'Nhập email của bạn; chúng tôi sẽ gửi mã 6 chữ số.';

  @override
  String get forgotPasswordBody => 'Chọn mật khẩu mới.';

  @override
  String get forgotSendCode => 'Gửi mã';

  @override
  String get forgotTitle => 'Đặt lại mật khẩu';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get loginForgot => 'Quên mật khẩu?';

  @override
  String get loginGoogleHint =>
      'Đã đăng ký bằng Google? Hãy đặt mật khẩu qua “Quên mật khẩu?” để đăng nhập trên ứng dụng.';

  @override
  String get loginNoAccount => 'Mới dùng VietGara? Đăng ký';

  @override
  String get loginSubmit => 'Đăng nhập';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get notSet => '—';

  @override
  String get registerHaveAccount => 'Đã đăng ký? Đăng nhập';

  @override
  String get registerSubmit => 'Đăng ký';

  @override
  String get registerTitle => 'Đăng ký';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get signOutConfirm => 'Đăng xuất trên thiết bị này?';

  @override
  String get splashError => 'Không kết nối được VietGara. Hãy kiểm tra mạng.';

  @override
  String get validationEmail => 'Nhập email hợp lệ.';

  @override
  String get validationOtp => 'Nhập mã 6 chữ số.';

  @override
  String get validationPassword => 'Tối thiểu 8 ký tự.';

  @override
  String get validationRequired => 'Bắt buộc.';

  @override
  String verifyBody(String email) {
    return 'Chúng tôi đã gửi mã 6 chữ số tới $email. Nhập mã bên dưới để kích hoạt hồ sơ của bạn. Nếu không thấy email, hãy kiểm tra thư mục thư rác (Spam/Junk).';
  }

  @override
  String get verifyResend => 'Gửi mã mới';

  @override
  String verifyResendIn(int seconds) {
    return 'Gửi mã mới sau $seconds giây';
  }

  @override
  String get verifySent => 'Mã mới đang được gửi.';

  @override
  String get verifySubmit => 'Xác minh';

  @override
  String get verifyTitle => 'Xác minh email';

  @override
  String get verifyWrongAccount => 'Không phải bạn? Đăng xuất';

  @override
  String get invitationsTitle => 'Lời mời';

  @override
  String get invitationsEmpty => 'Không có lời mời nào đang chờ.';

  @override
  String invitationFrom(String name) {
    return 'Người mời: $name';
  }

  @override
  String invitationExpires(String date) {
    return 'Hết hạn $date';
  }

  @override
  String get invitationAccept => 'Chấp nhận';

  @override
  String get invitationDecline => 'Từ chối';

  @override
  String invitationAccepted(String garage) {
    return 'Bạn đã tham gia $garage.';
  }

  @override
  String get mfaSectionTitle => 'Xác minh hai bước';

  @override
  String get mfaSectionBody =>
      'Hỏi mã từ ứng dụng xác thực ở mỗi lần đăng nhập bằng email và mật khẩu. Đăng nhập bằng Google được bảo vệ bởi tài khoản Google của bạn.';

  @override
  String get mfaOn => 'Bật';

  @override
  String get mfaOff => 'Tắt';

  @override
  String mfaSince(String date) {
    return 'Bật từ $date';
  }

  @override
  String mfaCodesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count mã khôi phục',
    );
    return '$_temp0';
  }

  @override
  String get mfaTurnOn => 'Bật';

  @override
  String get mfaTurnOff => 'Tắt';

  @override
  String get mfaNewCodes => 'Mã khôi phục mới';

  @override
  String get mfaSetupTitle => 'Bật xác minh hai bước';

  @override
  String get mfaSetupBody =>
      'Quét mã QR bằng ứng dụng xác thực, rồi nhập mã mà ứng dụng hiển thị.';

  @override
  String get mfaKey => 'Khoá';

  @override
  String get mfaKeyHint =>
      'Nhập khoá này vào ứng dụng nếu bạn không quét được mã.';

  @override
  String get mfaCode => 'Mã xác thực';

  @override
  String get mfaCodeFormat => 'Nhập mã 6 chữ số.';

  @override
  String get mfaCodeOrRecovery => 'Mã xác thực hoặc mã khôi phục';

  @override
  String get mfaConfirm => 'Xác nhận';

  @override
  String get mfaCodesTitle => 'Mã khôi phục của bạn';

  @override
  String get mfaCodesBody =>
      'Hãy cất ở nơi an toàn. Nếu mất điện thoại, mỗi mã đăng nhập được một lần. Các mã chỉ hiển thị lúc này.';

  @override
  String get mfaCopyAll => 'Sao chép tất cả';

  @override
  String get mfaCodesCopied => 'Đã sao chép các mã khôi phục.';

  @override
  String get mfaSaved => 'Tôi đã lưu các mã khôi phục';

  @override
  String get mfaDone => 'Xong';

  @override
  String get mfaRegenerateTitle => 'Mã khôi phục mới';

  @override
  String get mfaRegenerateBody =>
      'Nhập mã hiện tại từ ứng dụng. Các mã khôi phục cũ sẽ không dùng được nữa.';

  @override
  String get mfaDisableTitle => 'Tắt xác minh hai bước';

  @override
  String get mfaDisableBody =>
      'Nhập mã hiện tại từ ứng dụng, hoặc một mã khôi phục.';

  @override
  String get mfaDisabled => 'Đã tắt xác minh hai bước.';

  @override
  String get mfaChallengeTitle => 'Xác minh hai bước';

  @override
  String get mfaChallengeBody =>
      'Nhập mã 6 chữ số từ ứng dụng xác thực của bạn.';

  @override
  String get mfaChallengeRecoveryBody =>
      'Nhập một mã khôi phục. Mỗi mã chỉ dùng được một lần.';

  @override
  String get mfaRecoveryCode => 'Mã khôi phục';

  @override
  String get mfaVerify => 'Xác minh';

  @override
  String get mfaUseApp => 'Dùng ứng dụng xác thực';

  @override
  String get mfaUseRecovery => 'Dùng mã khôi phục';

  @override
  String get mfaBack => 'Quay lại đăng nhập';

  @override
  String get errorMfaCodeInvalid => 'Mã không đúng.';

  @override
  String get errorMfaLocked =>
      'Nhập sai quá nhiều lần. Hãy thử lại sau 15 phút.';

  @override
  String get errorMfaChallengeInvalid =>
      'Phiên đăng nhập đã hết hạn. Hãy quay lại và đăng nhập lại.';

  @override
  String get errorMfaAlreadyEnabled => 'Xác minh hai bước đã được bật.';

  @override
  String get errorMfaNotEnabled => 'Xác minh hai bước chưa được bật.';

  @override
  String get errorMfaEnrollmentNotStarted =>
      'Hãy bắt đầu bật xác minh hai bước trước.';

  @override
  String get errorMfaNotAvailable =>
      'Xác minh hai bước cần đăng nhập bằng email và mật khẩu; đăng nhập Google được bảo vệ bởi tài khoản Google của bạn.';

  @override
  String get errorMfaNotConfigured =>
      'Máy chủ này chưa hỗ trợ xác minh hai bước.';

  @override
  String get googleSectionTitle => 'Tài khoản Google';

  @override
  String get googleSectionBody =>
      'Liên kết tài khoản Google để đăng nhập một chạm. Mật khẩu vẫn là cách đăng nhập thứ hai.';

  @override
  String get googleLinked => 'Đã liên kết';

  @override
  String get googleNotLinked => 'Chưa liên kết';

  @override
  String get googleLink => 'Liên kết tài khoản Google';

  @override
  String get googleUnlink => 'Huỷ liên kết tài khoản Google';

  @override
  String get googleNoPassword =>
      'Bạn chỉ đăng nhập bằng Google. Hãy đặt mật khẩu trước để thay đổi.';

  @override
  String get googleNotConfigured =>
      'Ứng dụng này chưa được cài đặt đăng nhập Google.';

  @override
  String get googleFailed => 'Đăng nhập Google không thành công. Hãy thử lại.';

  @override
  String get googleLinkTitle => 'Liên kết tài khoản Google';

  @override
  String get googleLinkBody => 'Nhập mật khẩu, rồi chọn tài khoản Google.';

  @override
  String get googleLinkedDone => 'Đã liên kết tài khoản Google.';

  @override
  String get googleUnlinkTitle => 'Huỷ liên kết tài khoản Google';

  @override
  String get googleUnlinkBody =>
      'Nhập mật khẩu. Bạn vẫn đăng nhập ở đây và bị đăng xuất ở mọi nơi khác.';

  @override
  String get googleUnlinkedDone => 'Đã huỷ liên kết tài khoản Google.';

  @override
  String get errorPasswordIncorrect => 'Mật khẩu không đúng.';

  @override
  String get errorNoPassword => 'Hãy đặt mật khẩu trước.';

  @override
  String get errorGoogleAlreadyLinked =>
      'Tài khoản Google này đã liên kết với người dùng khác.';

  @override
  String get errorGoogleLinkExists =>
      'Đã có tài khoản Google liên kết. Hãy huỷ liên kết trước.';

  @override
  String get errorGoogleNotLinked => 'Chưa liên kết tài khoản Google.';

  @override
  String get errorGoogleSigninBlocked =>
      'Đăng nhập Google đang tắt cho tài khoản này. Hãy liên kết tài khoản Google trong phần bảo mật.';
}
