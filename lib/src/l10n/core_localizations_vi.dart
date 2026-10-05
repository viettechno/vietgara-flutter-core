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
  String get accountTitle => 'Tài khoản';

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
  String get errorAccountSuspended => 'Tài khoản đang bị tạm khoá.';

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
      'Số điện thoại đã được dùng cho tài khoản khác.';

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
    return 'Nhập mã đã gửi tới $email.';
  }

  @override
  String get forgotDone => 'Đã đổi mật khẩu. Hãy đăng nhập bằng mật khẩu mới.';

  @override
  String get forgotEmailBody =>
      'Nhập email của tài khoản; chúng tôi sẽ gửi mã 6 chữ số.';

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
  String get loginNoAccount => 'Chưa có tài khoản? Đăng ký';

  @override
  String get loginSubmit => 'Đăng nhập';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get notSet => '—';

  @override
  String get registerHaveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get registerSubmit => 'Đăng ký';

  @override
  String get registerTitle => 'Tạo tài khoản';

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
    return 'Chúng tôi đã gửi mã 6 chữ số tới $email. Nhập mã bên dưới để kích hoạt tài khoản.';
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
}
