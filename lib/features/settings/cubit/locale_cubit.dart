import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/settings_repository.dart';

/// `null` means "follow the device locale".
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit({required this.repository}) : super(null);

  final ISettingsRepository repository;

  Future<void> load() async {
    final code = await repository.localeCode();
    if (code != null && !isClosed) emit(Locale(code));
  }

  Future<void> setLocale(String code) async {
    await repository.saveLocaleCode(code);
    if (!isClosed) emit(Locale(code));
  }
}
