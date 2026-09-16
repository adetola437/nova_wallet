part of '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget implements ProfileViewContract {
  const ProfileView({super.key, required this.controller});

  final ProfileControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = context.select<AuthCubit, AuthState>((c) => c.state).profile;
    final languageCode = Localizations.localeOf(context).languageCode;
    final biometrics = context.watch<BiometricSettingsCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
        children: [
          if (profile != null)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(color: AppColors.navy900, borderRadius: BorderRadius.circular(16.r)),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundColor: AppColors.gold500,
                      child: Text(
                        profile.firstName.characters.first.toUpperCase(),
                        style: AppTextStyles.h1.sp.copyWith(color: AppColors.navy900),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: MergeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.fullName, style: AppTextStyles.h2.sp.copyWith(color: AppColors.onNavy)),
                          Text(profile.email, style: AppTextStyles.small.sp.copyWith(color: AppColors.onNavyMuted)),
                          Text(
                            l10n.profileAccountNumber(Masking.account(profile.accountNumber)),
                            style: AppTextStyles.small.sp.copyWith(color: AppColors.onNavyMuted),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.gold500,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              l10n.profileTier(profile.tier),
                              style: AppTextStyles.caption.sp.copyWith(color: AppColors.navy900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          _Group(
            children: [
              _Row(
                icon: Icons.translate_rounded,
                title: l10n.profileLanguage,
                subtitle: languageCode == 'yo' ? l10n.languageYoruba : l10n.languageEnglish,
                onTap: controller.onLanguage,
              ),
              MergeSemantics(
                child: SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.navy900),
                  title: Text(l10n.profileBiometrics, style: AppTextStyles.body.sp),
                  subtitle: Text(l10n.profileBiometricsSub, style: AppTextStyles.small.sp),
                  value: biometrics.enabled,
                  onChanged: biometrics.busy ? null : controller.onToggleBiometrics,
                ),
              ),
              _Row(
                icon: Icons.shield_outlined,
                title: l10n.profileSecurity,
                subtitle: l10n.profileSecuritySub,
                onTap: controller.onComingSoon,
              ),
              _Row(
                icon: Icons.help_outline_rounded,
                title: l10n.profileHelp,
                subtitle: l10n.profileHelpSub,
                onTap: controller.onComingSoon,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _Group(
            children: [
              _Row(
                icon: Icons.developer_mode_rounded,
                title: l10n.profileDeveloper,
                subtitle: l10n.profileDeveloperSub,
                onTap: controller.onDeveloper,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          NovaButton(
            label: l10n.signOut,
            icon: Icons.logout_rounded,
            variant: NovaButtonVariant.danger,
            onPressed: controller.onSignOut,
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(l10n.versionFooter, style: AppTextStyles.caption.sp.copyWith(color: AppColors.textTertiary)),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  // A Material, not a coloured Container: list tiles paint their ink on it.
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
      side: const BorderSide(color: AppColors.border),
    ),
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
          children[i],
        ],
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 56,
    leading: Icon(icon, color: AppColors.navy900),
    title: Text(title, style: AppTextStyles.body.sp),
    subtitle: Text(subtitle, style: AppTextStyles.small.sp),
    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
    onTap: onTap,
  );
}
