import 'package:cloud_firestore/cloud_firestore.dart';

/// Every collection path in one place, mirroring `firestore.rules`.
class FirestorePaths {
  const FirestorePaths(this.firestore);

  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> user(String uid) => firestore.doc('users/$uid');
  DocumentReference<Map<String, dynamic>> processed(String uid, String key) =>
      user(uid).collection('processed').doc(key);
  CollectionReference<Map<String, dynamic>> transactions(String uid) => user(uid).collection('transactions');
  CollectionReference<Map<String, dynamic>> goals(String uid) => user(uid).collection('goals');
  CollectionReference<Map<String, dynamic>> beneficiaries(String uid) => user(uid).collection('beneficiaries');
  DocumentReference<Map<String, dynamic>> health() => firestore.doc('meta/health');

  /// Exact-email lookup for NovaWallet transfers: `{uid, accountNumber, fullName}`.
  /// Rules allow a signed-in `get`, never a `list`.
  DocumentReference<Map<String, dynamic>> directoryEmail(String email) =>
      firestore.doc('directoryEmails/${email.trim().toLowerCase()}');

  /// Account number → `{uid}`, used inside a transfer to find the recipient.
  DocumentReference<Map<String, dynamic>> directoryAccount(String accountNumber) =>
      firestore.doc('directoryAccounts/$accountNumber');
}
