import 'package:flutter/material.dart';

/// The VietGara brand color (Gara Blue), shared with the web apps. Design
/// System 3.2.1 (`vietgara-docs/docs/02-Design/v2/03_Design_System.md`).
const brandColor = Color(0xFF1F66B3);

/// Font families bundled with this package (Be Vietnam Pro for the UI,
/// JetBrains Mono for plates and codes).
const vgFontFamily = 'packages/vietgara_core/BeVietnamPro';
const vgMonoFamily = 'packages/vietgara_core/JetBrainsMono';

/// Radius tokens: sm 4 (badge, plate), md 8 (controls), lg 12 (cards,
/// popovers), xl 16 (dialogs, sheets).
class VgRadius {
  const VgRadius._();

  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;
}

/// The design tokens Material's [ColorScheme] has no slot for: sunken and
/// border surfaces, the success/warning/info status roles (solid and
/// subtle) and the license plate. Read with `context.vg`.
@immutable
class VgColors extends ThemeExtension<VgColors> {
  const VgColors({
    required this.background,
    required this.surfaceSunken,
    required this.border,
    required this.mutedForeground,
    required this.success,
    required this.successSubtle,
    required this.onSuccessSubtle,
    required this.warning,
    required this.warningSubtle,
    required this.onWarningSubtle,
    required this.info,
    required this.infoSubtle,
    required this.onInfoSubtle,
    required this.destructiveSubtle,
    required this.onDestructiveSubtle,
    required this.plate,
    required this.onPlate,
  });

  final Color background;
  final Color surfaceSunken;
  final Color border;
  final Color mutedForeground;
  final Color success;
  final Color successSubtle;
  final Color onSuccessSubtle;
  final Color warning;
  final Color warningSubtle;
  final Color onWarningSubtle;
  final Color info;
  final Color infoSubtle;
  final Color onInfoSubtle;
  final Color destructiveSubtle;
  final Color onDestructiveSubtle;
  final Color plate;
  final Color onPlate;

  static const light = VgColors(
    background: Color(0xFFF6F8FA),
    surfaceSunken: Color(0xFFEEF1F5),
    border: Color(0xFFE1E6ED),
    mutedForeground: Color(0xFF5F6A7B),
    success: Color(0xFF237A45),
    successSubtle: Color(0xFFE8F5EC),
    onSuccessSubtle: Color(0xFF1B6B3A),
    warning: Color(0xFFE8A317),
    warningSubtle: Color(0xFFFFF4E0),
    onWarningSubtle: Color(0xFF8A5300),
    info: Color(0xFF0E7490),
    infoSubtle: Color(0xFFE6F4F8),
    onInfoSubtle: Color(0xFF0B5E75),
    destructiveSubtle: Color(0xFFFDECEA),
    onDestructiveSubtle: Color(0xFFB0261C),
    plate: Color(0xFFFFFFFF),
    onPlate: Color(0xFF151A23),
  );

  static const dark = VgColors(
    background: Color(0xFF0F141B),
    surfaceSunken: Color(0xFF12171F),
    border: Color(0xFF27303D),
    mutedForeground: Color(0xFF8D99AB),
    success: Color(0xFF2E8F57),
    successSubtle: Color(0xFF12301F),
    onSuccessSubtle: Color(0xFF6FD09A),
    warning: Color(0xFFE8A317),
    warningSubtle: Color(0xFF33230A),
    onWarningSubtle: Color(0xFFF2B756),
    info: Color(0xFF2C8EAD),
    infoSubtle: Color(0xFF14303A),
    onInfoSubtle: Color(0xFF7DD0E8),
    destructiveSubtle: Color(0xFF3A1512),
    onDestructiveSubtle: Color(0xFFFF8A80),
    plate: Color(0xFFE6EAF0),
    onPlate: Color(0xFF0F141B),
  );

  @override
  VgColors copyWith() => this;

  @override
  VgColors lerp(ThemeExtension<VgColors>? other, double t) =>
      t < 0.5 || other is! VgColors ? this : other;
}

extension VgTheme on BuildContext {
  VgColors get vg {
    final theme = Theme.of(this);
    return theme.extension<VgColors>() ??
        (theme.brightness == Brightness.dark ? VgColors.dark : VgColors.light);
  }
}

ColorScheme _scheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1F66B3),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFDCE9F8),
      onPrimaryContainer: Color(0xFF194F8A),
      secondary: Color(0xFF4F5A6B),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFEEF1F5),
      onSecondaryContainer: Color(0xFF151A23),
      tertiary: Color(0xFF0E7490),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE6F4F8),
      onTertiaryContainer: Color(0xFF0B5E75),
      error: Color(0xFFC62E24),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFDECEA),
      onErrorContainer: Color(0xFFB0261C),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF151A23),
      onSurfaceVariant: Color(0xFF5F6A7B),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFFFFFF),
      surfaceContainer: Color(0xFFF6F8FA),
      surfaceContainerHigh: Color(0xFFEEF1F5),
      surfaceContainerHighest: Color(0xFFEEF1F5),
      outline: Color(0xFF7C8798),
      outlineVariant: Color(0xFFE1E6ED),
      inverseSurface: Color(0xFF151A23),
      onInverseSurface: Color(0xFFF6F8FA),
      inversePrimary: Color(0xFF6FA8E8),
      shadow: Color(0xFF151A23),
      scrim: Color(0xFF0F141B),
      surfaceTint: Colors.transparent,
    );
  }
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF2F73BF),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF14263D),
    onPrimaryContainer: Color(0xFF9CC4F0),
    secondary: Color(0xFFA3AEBF),
    onSecondary: Color(0xFF0F141B),
    secondaryContainer: Color(0xFF1F2732),
    onSecondaryContainer: Color(0xFFE6EAF0),
    tertiary: Color(0xFF2C8EAD),
    onTertiary: Color(0xFF0F141B),
    tertiaryContainer: Color(0xFF14303A),
    onTertiaryContainer: Color(0xFF7DD0E8),
    error: Color(0xFFC62E24),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF3A1512),
    onErrorContainer: Color(0xFFFF8A80),
    surface: Color(0xFF171D26),
    onSurface: Color(0xFFE6EAF0),
    onSurfaceVariant: Color(0xFF8D99AB),
    surfaceContainerLowest: Color(0xFF0F141B),
    surfaceContainerLow: Color(0xFF171D26),
    surfaceContainer: Color(0xFF12171F),
    surfaceContainerHigh: Color(0xFF1C232E),
    surfaceContainerHighest: Color(0xFF1F2732),
    outline: Color(0xFF6C788D),
    outlineVariant: Color(0xFF27303D),
    inverseSurface: Color(0xFFE6EAF0),
    onInverseSurface: Color(0xFF0F141B),
    inversePrimary: Color(0xFF1F66B3),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Colors.transparent,
  );
}

TextTheme _textTheme(ColorScheme scheme) {
  TextStyle style(
    double size,
    double height,
    FontWeight weight, {
    double spacing = 0,
  }) => TextStyle(
    fontFamily: vgFontFamily,
    fontSize: size,
    height: height / size,
    fontWeight: weight,
    letterSpacing: spacing * size,
    color: scheme.onSurface,
  );
  return TextTheme(
    displayLarge: style(32, 40, FontWeight.w600, spacing: -0.02),
    displayMedium: style(32, 40, FontWeight.w600, spacing: -0.02),
    displaySmall: style(32, 40, FontWeight.w600, spacing: -0.02),
    headlineLarge: style(24, 32, FontWeight.w600, spacing: -0.015),
    headlineMedium: style(24, 32, FontWeight.w600, spacing: -0.015),
    headlineSmall: style(24, 32, FontWeight.w600, spacing: -0.015),
    titleLarge: style(18, 28, FontWeight.w600, spacing: -0.01),
    titleMedium: style(16, 24, FontWeight.w600, spacing: -0.005),
    titleSmall: style(14, 20, FontWeight.w500),
    bodyLarge: style(16, 24, FontWeight.w400),
    bodyMedium: style(14, 20, FontWeight.w400),
    bodySmall: style(12, 16, FontWeight.w400),
    labelLarge: style(14, 20, FontWeight.w500),
    labelMedium: style(12, 16, FontWeight.w500, spacing: 0.01),
    labelSmall: style(12, 16, FontWeight.w500, spacing: 0.01),
  );
}

/// The VietGara theme (Design System v2): calm neutral surfaces, one blue
/// accent, hairline borders instead of shadows, radius 8 controls and 12
/// cards, Be Vietnam Pro. Light and dark follow the same tokens as the web
/// apps.
ThemeData buildTheme(Brightness brightness) {
  final scheme = _scheme(brightness);
  final vg = brightness == Brightness.light ? VgColors.light : VgColors.dark;
  final text = _textTheme(scheme);
  final control = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(VgRadius.md),
  );
  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(VgRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
  final buttonText = text.labelLarge;
  const buttonPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    extensions: [vg],
    fontFamily: vgFontFamily,
    textTheme: text,
    primaryTextTheme: text,
    scaffoldBackgroundColor: vg.background,
    canvasColor: scheme.surface,
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: DividerThemeData(color: vg.border, thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleMedium,
      shape: Border(bottom: BorderSide(color: vg.border)),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.lg),
        side: BorderSide(color: vg.border),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      iconColor: scheme.onSurfaceVariant,
      titleTextStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      subtitleTextStyle: text.bodySmall?.copyWith(color: vg.mutedForeground),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: control,
        padding: buttonPadding,
        minimumSize: const Size(64, 44),
        textStyle: buttonText,
        elevation: 0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: control,
        padding: buttonPadding,
        minimumSize: const Size(64, 44),
        textStyle: buttonText,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: control,
        padding: buttonPadding,
        minimumSize: const Size(64, 44),
        textStyle: buttonText,
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.onSurface,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: control,
        padding: buttonPadding,
        minimumSize: const Size(48, 44),
        textStyle: buttonText,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 3,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.lg),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: inputBorder(scheme.outline),
      enabledBorder: inputBorder(scheme.outline),
      focusedBorder: inputBorder(scheme.primary, 2),
      errorBorder: inputBorder(scheme.error),
      focusedErrorBorder: inputBorder(scheme.error, 2),
      disabledBorder: inputBorder(vg.border),
      labelStyle: text.bodyMedium?.copyWith(color: vg.mutedForeground),
      hintStyle: text.bodyMedium?.copyWith(color: vg.mutedForeground),
      helperStyle: text.bodySmall?.copyWith(color: vg.mutedForeground),
      errorStyle: text.bodySmall?.copyWith(color: vg.onDestructiveSubtle),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surface),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStatePropertyAll(BorderSide(color: scheme.outline)),
      shape: WidgetStatePropertyAll(control),
      constraints: const BoxConstraints(minHeight: 44),
      textStyle: WidgetStatePropertyAll(text.bodyMedium),
      hintStyle: WidgetStatePropertyAll(
        text.bodyMedium?.copyWith(color: vg.mutedForeground),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surface,
      selectedColor: scheme.primaryContainer,
      side: BorderSide(color: vg.border),
      labelStyle: text.labelMedium,
      secondaryLabelStyle: text.labelMedium?.copyWith(
        color: scheme.onPrimaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.md),
      ),
      showCheckmark: false,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.xl),
        side: BorderSide(color: vg.border),
      ),
      titleTextStyle: text.titleMedium,
      contentTextStyle: text.bodyMedium,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      showDragHandle: true,
      dragHandleColor: scheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(VgRadius.xl)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: scheme.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.md),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => text.labelMedium?.copyWith(
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : vg.mutedForeground,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : vg.mutedForeground,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.lg),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VgRadius.lg),
        side: BorderSide(color: vg.border),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(VgRadius.sm),
      ),
      textStyle: text.labelMedium?.copyWith(color: scheme.onInverseSurface),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.surfaceContainerHighest,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: control,
        side: BorderSide(color: scheme.outline),
        textStyle: text.labelLarge,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelStyle: text.labelLarge,
      unselectedLabelStyle: text.labelLarge,
      labelColor: scheme.onSurface,
      unselectedLabelColor: vg.mutedForeground,
      indicatorColor: scheme.primary,
      dividerColor: vg.border,
    ),
    visualDensity: VisualDensity.standard,
  );
}
