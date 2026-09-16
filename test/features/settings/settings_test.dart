import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/settings/cubit/locale_cubit.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsRepositoryImpl> buildRepo() async {
  SharedPreferences.setMockInitialValues({});
  return SettingsRepositoryImpl(
    localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()),
  );
}

void main() {
  test('settings repository persists locale, onboarding and biometric flags', () async {
    final repo = await buildRepo();
    expect(await repo.onboardingSeen(), isFalse);
    expect(await repo.localeCode(), isNull);
    await repo.markOnboardingSeen();
    await repo.saveLocaleCode('yo');
    await repo.setBiometricEnabled(true);
    expect(await repo.onboardingSeen(), isTrue);
    expect(await repo.localeCode(), 'yo');
    expect(await repo.biometricEnabled(), isTrue);
  });

  test('LocaleCubit loads the saved locale and switches', () async {
    final repo = await buildRepo();
    await repo.saveLocaleCode('yo');
    final cubit = LocaleCubit(repository: repo);
    await cubit.load();
    expect(cubit.state, const Locale('yo'));
    await cubit.setLocale('en');
    expect(cubit.state, const Locale('en'));
    expect(await repo.localeCode(), 'en');
    await cubit.close();
  });
}
