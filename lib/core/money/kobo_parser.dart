import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../config/flavor/app_constants.dart';

enum KoboParseError { empty, invalid, tooManyDecimals, tooLarge }

/// Turns what a user typed into integer kobo without ever touching a double.
///
/// `double.parse('0.29') * 100` is 28.999999999999996, which truncates to 28
/// kobo. Splitting on '.' and parsing both halves as ints avoids that class of
/// bug entirely.
abstract class KoboParser {
  static final RegExp _shape = RegExp(r'^\d+(\.\d*)?$');
  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  /// 13 whole digits is already far above [AppConstants.maxAmountKobo]; checking
  /// length first means int.parse can never overflow.
  static const int _maxWholeDigits = 13;

  static Either<KoboParseError, int> parse(String input, {int maxKobo = AppConstants.maxAmountKobo}) {
    final cleaned = input.replaceAll('₦', '').replaceAll(',', '').replaceAll(' ', '').trim();
    if (cleaned.isEmpty) return left(KoboParseError.empty);
    if (!_shape.hasMatch(cleaned)) return left(KoboParseError.invalid);

    final parts = cleaned.split('.');
    final wholeDigits = parts[0].replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final fracDigits = parts.length > 1 ? parts[1] : '';

    if (fracDigits.length > 2) return left(KoboParseError.tooManyDecimals);
    if (wholeDigits.length > _maxWholeDigits) return left(KoboParseError.tooLarge);

    final kobo = int.parse(wholeDigits) * 100 + int.parse(fracDigits.padRight(2, '0'));
    if (kobo > maxKobo) return left(KoboParseError.tooLarge);
    return right(kobo);
  }

  /// Text to prefill an input with (quick-amount chips): `1,000` or `1,500.50`.
  static String toInputText(int kobo) {
    final whole = _grouped.format(kobo ~/ 100);
    final minor = kobo % 100;
    return minor == 0 ? whole : '$whole.${minor.toString().padLeft(2, '0')}';
  }
}
