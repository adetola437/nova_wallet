part of '../controllers/new_recipient_controller.dart';

class NewRecipientView extends StatelessWidget implements NewRecipientViewContract {
  const NewRecipientView({super.key, required this.controller});

  final NewRecipientControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<NameEnquiryCubit, NameEnquiryState>(
      builder: (context, state) {
        final verified = state.verified;
        return NovaFormScaffold(
          appBarTitle: l10n.newRecipientTitle,
          actions: [NovaButton(label: l10n.continueLabel, onPressed: verified == null ? null : controller.onContinue)],
          content: [
            ExcludeSemantics(child: Text(l10n.bankLabel, style: AppTextStyles.caption.sp)),
            SizedBox(height: 6.h),
            Semantics(
              button: true,
              label: l10n.bankLabel,
              value: state.bank?.name ?? l10n.chooseBank,
              excludeSemantics: true,
              child: InkWell(
                onTap: controller.onPickBank,
                borderRadius: BorderRadius.circular(12.r),
                child: InputDecorator(
                  decoration: const InputDecoration(suffixIcon: Icon(Icons.expand_more_rounded)),
                  child: Text(
                    state.bank?.name ?? l10n.chooseBank,
                    style: AppTextStyles.body.sp.copyWith(
                      color: state.bank == null ? AppColors.textTertiary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            NovaTextField(
              label: l10n.accountNumberLabel,
              controller: controller.accountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              helper: l10n.accountNumberHelp,
              errorText: state.failure?.localized(l10n),
              onChanged: controller.onAccountChanged,
            ),
            SizedBox(height: 16.h),
            if (state.isVerifying)
              Semantics(
                liveRegion: true,
                child: Row(
                  children: [
                    SizedBox(width: 16.r, height: 16.r, child: const CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8.w),
                    Text(l10n.verifyingAccount, style: AppTextStyles.small.sp),
                  ],
                ),
              )
            else if (verified != null)
              Semantics(
                liveRegion: true,
                container: true,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(color: AppColors.sentBg, borderRadius: BorderRadius.circular(12.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_rounded, size: 16.r, color: AppColors.sentInk),
                          SizedBox(width: 6.w),
                          Text(
                            l10n.accountVerified,
                            style: AppTextStyles.caption.sp.copyWith(color: AppColors.sentInk),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(verified.verifiedName, style: AppTextStyles.h2.sp),
                      Text('${verified.bankName} · ${verified.maskedAccount}', style: AppTextStyles.small.sp),
                      SizedBox(height: 8.h),
                      Text(l10n.accountCheckName, style: AppTextStyles.small.sp.copyWith(color: AppColors.sentInk)),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16.h),
            MergeSemantics(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: state.saveBeneficiary,
                onChanged: controller.onToggleSave,
                title: Text(l10n.saveBeneficiary, style: AppTextStyles.body.sp),
                subtitle: Text(l10n.saveBeneficiarySub, style: AppTextStyles.small.sp),
              ),
            ),
          ],
        );
      },
    );
  }
}
