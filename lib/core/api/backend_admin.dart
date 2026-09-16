/// Demo-only operations a real backend would never expose to a client.
///
/// Kept out of [NovaApiService] so app code can't reach them by accident; only
/// the developer panel's repository depends on this.
abstract class BackendAdmin {
  /// Wipes this account's demo data and seeds it again.
  Future<void> resetDemo();

  /// Credits this account as if someone else had sent money in, so the
  /// "money received" notification can be shown live.
  Future<void> simulateIncomingPayment({required String token, required int amountKobo, required String from});
}
