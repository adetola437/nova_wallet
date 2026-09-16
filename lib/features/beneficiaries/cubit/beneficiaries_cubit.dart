import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/beneficiary.dart';
import '../repository/beneficiary_repository.dart';

/// Saved recipients, with a client-side search filter.
class BeneficiariesCubit extends Cubit<List<Beneficiary>> {
  BeneficiariesCubit({required this.repository}) : super(const []);

  final IBeneficiaryRepository repository;

  StreamSubscription<List<Beneficiary>>? _sub;
  String _query = '';

  List<Beneficiary> get visible {
    if (_query.isEmpty) return state;
    final needle = _query.toLowerCase();
    return state
        .where((b) => b.verifiedName.toLowerCase().contains(needle) || b.accountNumber.contains(needle))
        .toList();
  }

  Future<void> start() async {
    if (_sub != null) return;
    _sub = repository.watchAll().listen((rows) {
      if (!isClosed) emit(rows);
    });
    await repository.refresh();
  }

  Future<void> refresh() => repository.refresh();

  void search(String query) {
    _query = query.trim();
    if (!isClosed) emit(List<Beneficiary>.from(state)); // re-emit so `visible` recomputes
  }

  Future<void> reset() async {
    await _sub?.cancel();
    _sub = null;
    _query = '';
    if (!isClosed) emit(const []);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
