/// Nigerian mobile numbers, normalised to the 11-digit local form `0XXXXXXXXXX`.
abstract class PhoneNumber {
  static final RegExp _local = RegExp(r'^0[789][01]\d{8}$');

  static String? normalize(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234') && digits.length == 13) {
      digits = '0${digits.substring(3)}';
    } else if (digits.length == 10) {
      digits = '0$digits';
    }
    return _local.hasMatch(digits) ? digits : null;
  }
}
