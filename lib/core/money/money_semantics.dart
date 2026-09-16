import 'package:intl/intl.dart';

/// Screen-reader label for an amount.
///
/// TalkBack/VoiceOver read "₦12,500.50" as "N twelve thousand five hundred
/// point five zero". Naming the units reads naturally in both languages while
/// leaving the digits for the TTS engine to voice in its own language.
abstract class MoneySemantics {
  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  static String label(int kobo, {required String languageCode}) {
    final naira = _grouped.format(kobo.abs() ~/ 100);
    final minor = kobo.abs() % 100;

    if (languageCode == 'yo') {
      final base = minor == 0 ? 'náírà $naira' : 'náírà $naira àti kọ́bọ̀ $minor';
      return kobo < 0 ? 'àyọkúrò $base' : base;
    }

    final base = minor == 0 ? '$naira naira' : '$naira naira $minor kobo';
    return kobo < 0 ? 'minus $base' : base;
  }
}
