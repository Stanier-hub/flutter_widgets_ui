import 'dart:ui';

class CoresPadraoUi {
  final Color _primary;
  final Color _azulEscuro;
  final Color _yInMnBlue;
  final Color _whiteSmoke;
  final Color _error600;
  final Color _neutral100;
  final Color _neutral200;
  final Color _neutral300;
  final Color _neutral400;
  final Color _neutral500;
  final Color _neutral600;
  final Color _neutral700;
  final Color _neutral800;
  final Color _success;
  final Color _purple;
  final Color _ascent;
  final Color _littlePurple;
  final Color _purpleDark;
  final Color _anotherGreen;
  final Color _textTitle;
  final Color _textBase;
  final Color _textInPurpleWhite;
  final Color _textInPurpleBase;
  final Color _anotherPurple;
  final Color _yellow;
  final Color _green;

  CoresPadraoUi({
    Color primary = const Color(0xFF5BC0BE),
    Color azulEscuro = const Color(0xFF0A244D),
    Color yInMnBlue = const Color(0xFF3A506B),
    Color whiteSmoke = const Color(0xFFEDF2F7),
    Color error600 = const Color(0xFFE53E3E),
    Color neutral100 = const Color(0xFFF7FAFC),
    Color neutral200 = const Color(0xFFEDF2F7),
    Color neutral300 = const Color(0xFFE2E8F0),
    Color neutral400 = const Color(0xFFCBD5E0),
    Color neutral500 = const Color(0xFFA0AEC0),
    Color neutral600 = const Color(0xFF718096),
    Color neutral700 = const Color(0xFF4A5568),
    Color neutral800 = const Color(0xFF2D3748),
    Color success = const Color(0xFF68D391),
    Color purple = const Color(0xFF440099),
    Color ascent = const Color(0xFF083445),
    Color littlePurple = const Color(0xFF5416A3),
    Color purpleDark = const Color(0xFF422974),
    Color anotherGreen = const Color(0xFF228D64),
    Color textTitle = const Color(0xFF32264D),
    Color textBase = const Color(0xFF6A6180),
    Color textInPurpleWhite = const Color(0xFFFFFFFF),
    Color textInPurpleBase = const Color(0xFFD4C2FF),
    Color anotherPurple = const Color(0xFF6D459F),
    Color yellow = const Color(0xFFFFC100),
    Color green = const Color(0xFF26D07C),
  })  : _primary = primary,
        _azulEscuro = azulEscuro,
        _yInMnBlue = yInMnBlue,
        _whiteSmoke = whiteSmoke,
        _error600 = error600,
        _neutral100 = neutral100,
        _neutral200 = neutral200,
        _neutral300 = neutral300,
        _neutral400 = neutral400,
        _neutral500 = neutral500,
        _neutral600 = neutral600,
        _neutral700 = neutral700,
        _neutral800 = neutral800,
        _success = success,
        _purple = purple,
        _ascent = ascent,
        _littlePurple = littlePurple,
        _purpleDark = purpleDark,
        _anotherGreen = anotherGreen,
        _textTitle = textTitle,
        _textBase = textBase,
        _textInPurpleWhite = textInPurpleWhite,
        _textInPurpleBase = textInPurpleBase,
        _anotherPurple = anotherPurple,
        _yellow = yellow,
        _green = green;

  CoresPadraoUi copyWith({
    Color? primary,
    Color? azulEscuro,
    Color? yInMnBlue,
    Color? whiteSmoke,
    Color? error600,
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? success,
    Color? purple,
    Color? ascent,
    Color? littlePurple,
    Color? purpleDark,
    Color? anotherGreen,
    Color? textTitle,
    Color? textBase,
    Color? textInPurpleWhite,
    Color? textInPurpleBase,
    Color? anotherPurple,
    Color? yellow,
    Color? green,
  }) {
    return CoresPadraoUi(
      primary: primary ?? _primary,
      azulEscuro: azulEscuro ?? _azulEscuro,
      yInMnBlue: yInMnBlue ?? _yInMnBlue,
      whiteSmoke: whiteSmoke ?? _whiteSmoke,
      error600: error600 ?? _error600,
      neutral100: neutral100 ?? _neutral100,
      neutral200: neutral200 ?? _neutral200,
      neutral300: neutral300 ?? _neutral300,
      neutral400: neutral400 ?? _neutral400,
      neutral500: neutral500 ?? _neutral500,
      neutral600: neutral600 ?? _neutral600,
      neutral700: neutral700 ?? _neutral700,
      neutral800: neutral800 ?? _neutral800,
      success: success ?? _success,
      purple: purple ?? _purple,
      ascent: ascent ?? _ascent,
      littlePurple: littlePurple ?? _littlePurple,
      purpleDark: purpleDark ?? _purpleDark,
      anotherGreen: anotherGreen ?? _anotherGreen,
      textTitle: textTitle ?? _textTitle,
      textBase: textBase ?? _textBase,
      textInPurpleWhite: textInPurpleWhite ?? _textInPurpleWhite,
      textInPurpleBase: textInPurpleBase ?? _textInPurpleBase,
      anotherPurple: anotherPurple ?? _anotherPurple,
      yellow: yellow ?? _yellow,
      green: green ?? _green,
    );
  }

  static CoresPadraoUi _instance = CoresPadraoUi();

  static void overrideColors(CoresPadraoUi newColors) {
    _instance = _instance.copyWith(
      primary: newColors._primary,
      azulEscuro: newColors._azulEscuro,
      yInMnBlue: newColors._yInMnBlue,
      whiteSmoke: newColors._whiteSmoke,
      error600: newColors._error600,
      neutral100: newColors._neutral100,
      neutral200: newColors._neutral200,
      neutral300: newColors._neutral300,
      neutral400: newColors._neutral400,
      neutral500: newColors._neutral500,
      neutral600: newColors._neutral600,
      neutral700: newColors._neutral700,
      neutral800: newColors._neutral800,
      success: newColors._success,
      purple: newColors._purple,
      ascent: newColors._ascent,
      littlePurple: newColors._littlePurple,
      purpleDark: newColors._purpleDark,
      anotherGreen: newColors._anotherGreen,
      textTitle: newColors._textTitle,
      textBase: newColors._textBase,
      textInPurpleWhite: newColors._textInPurpleWhite,
      textInPurpleBase: newColors._textInPurpleBase,
      anotherPurple: newColors._anotherPurple,
      yellow: newColors._yellow,
      green: newColors._green,
    );
  }

  // Getters estáticos para acesso direto
  static Color get primary => _instance._primary;
  static Color get azulEscuro => _instance._azulEscuro;
  static Color get yInMnBlue => _instance._yInMnBlue;
  static Color get whiteSmoke => _instance._whiteSmoke;
  static Color get error600 => _instance._error600;
  static Color get neutral100 => _instance._neutral100;
  static Color get neutral200 => _instance._neutral200;
  static Color get neutral300 => _instance._neutral300;
  static Color get neutral400 => _instance._neutral400;
  static Color get neutral500 => _instance._neutral500;
  static Color get neutral600 => _instance._neutral600;
  static Color get neutral700 => _instance._neutral700;
  static Color get neutral800 => _instance._neutral800;
  static Color get success => _instance._success;
  static Color get purple => _instance._purple;
  static Color get ascent => _instance._ascent;
  static Color get littlePurple => _instance._littlePurple;
  static Color get purpleDark => _instance._purpleDark;
  static Color get anotherGreen => _instance._anotherGreen;
  static Color get textTitle => _instance._textTitle;
  static Color get textBase => _instance._textBase;
  static Color get textInPurpleWhite => _instance._textInPurpleWhite;
  static Color get textInPurpleBase => _instance._textInPurpleBase;
  static Color get anotherPurple => _instance._anotherPurple;
  static Color get yellow => _instance._yellow;
  static Color get green => _instance._green;
}
