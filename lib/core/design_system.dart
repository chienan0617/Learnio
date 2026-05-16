import 'package:learnio/base.dart';

class DesignSystem {
  // Spacing Tokens
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Radius Tokens
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static BorderRadius get borderS => BorderRadius.circular(radiusS);
  static BorderRadius get borderM => BorderRadius.circular(radiusM);
  static BorderRadius get borderL => BorderRadius.circular(radiusL);
  static BorderRadius get borderXL => BorderRadius.circular(radiusXL);

  // Animation Duration
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Shadows
  static List<BoxShadow> get shadowSoft => [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowNone => [];
}

// Typography Helpers
TextStyle get tsDisplay => TextStyle(
      fontSize: 28,
      fontWeight: fw8,
      color: tx1,
      letterSpacing: -0.5,
    );

TextStyle get tsTitleLarge => TextStyle(
      fontSize: 22,
      fontWeight: fw7,
      color: tx1,
      letterSpacing: -0.2,
    );

TextStyle get tsTitleMedium => TextStyle(
      fontSize: 18,
      fontWeight: fw6,
      color: tx1,
    );

TextStyle get tsBodyLarge => TextStyle(
      fontSize: 16,
      fontWeight: fw4,
      color: tx1,
      height: 1.6,
    );

TextStyle get tsBodyMedium => TextStyle(
      fontSize: 14,
      fontWeight: fw4,
      color: tx2,
      height: 1.5,
    );

TextStyle get tsBodySmall => TextStyle(
      fontSize: 12,
      fontWeight: fw4,
      color: tx6,
      height: 1.5,
    );

TextStyle get tsCaption => TextStyle(
      fontSize: 12,
      fontWeight: fw5,
      color: tx6,
    );

    // borderXL_V