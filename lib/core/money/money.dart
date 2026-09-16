import 'package:intl/intl.dart';

/// An amount of Naira held as integer kobo (ported from Kiba's Money, NGN only).
///
/// `int` in, `int` out: even [format] splits whole and fractional parts with
/// integer division so nothing is rounded on the way to the screen.
class Money implements Comparable<Money> {
  const Money(this.kobo);
  const Money.zero() : kobo = 0;

  final int kobo;

  /// What a hidden balance shows behind the eye toggle.
  static const String masked = '••••••';

  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  bool get isZero => kobo == 0;
  bool get isNegative => kobo < 0;

  String format({bool withSymbol = true}) {
    final sign = kobo < 0 ? '-' : '';
    final abs = kobo.abs();
    final whole = _grouped.format(abs ~/ 100);
    final minor = (abs % 100).toString().padLeft(2, '0');
    return '$sign${withSymbol ? '₦' : ''}$whole.$minor';
  }

  Money operator +(Money other) => Money(kobo + other.kobo);
  Money operator -(Money other) => Money(kobo - other.kobo);
  bool operator >(Money other) => kobo > other.kobo;
  bool operator <(Money other) => kobo < other.kobo;

  @override
  int compareTo(Money other) => kobo.compareTo(other.kobo);

  @override
  bool operator ==(Object other) => other is Money && other.kobo == kobo;

  @override
  int get hashCode => kobo.hashCode;

  @override
  String toString() => 'Money($kobo kobo)';
}
