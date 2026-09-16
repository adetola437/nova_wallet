/// NDPA-friendly masking for identifiers shown on screen.
abstract class Masking {
  static String account(String accountNumber) {
    final tail = accountNumber.length <= 4 ? accountNumber : accountNumber.substring(accountNumber.length - 4);
    return '•••• $tail';
  }
}
