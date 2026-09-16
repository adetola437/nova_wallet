part of '../controllers/send_amount_controller.dart';

class SendAmountView extends StatelessWidget implements SendAmountViewContract {
  const SendAmountView({super.key, required this.controller});

  final SendAmountControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final available = context.select<WalletCubit, int>((c) => c.state.overview.availableKobo);

    return BlocBuilder<SendMoneyCubit, SendMoneyState>(
      builder: (context, state) {
        final recipient = state.recipient;
        return NovaFormScaffold(
          appBarTitle: l10n.amountTitle,
          actions: [NovaButton(label: l10n.continueLabel, onPressed: state.canContinue ? controller.onContinue : null)],
          content: [
            if (recipient != null)
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    RecipientAvatar(name: recipient.verifiedName),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: MergeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipient.verifiedName, style: AppTextStyles.body.sp),
                            Text('${recipient.bankName} · ${recipient.maskedAccount}', style: AppTextStyles.small.sp),
                          ],
                        ),
                      ),
                    ),
                    TextButton(onPressed: controller.onChangeRecipient, child: Text(l10n.change)),
                  ],
                ),
              ),
            SizedBox(height: 24.h),
            Semantics(header: true, child: Text(l10n.amountQuestion, style: AppTextStyles.h2.sp)),
            SizedBox(height: 12.h),
            AmountInput(
              controller: controller.amountController,
              onChanged: controller.onAmountChanged,
              semanticLabel: l10n.amountQuestion,
              errorText: state.amountError?.localized(l10n),
              helper: Semantics(
                label: l10n.availableAmount(MoneySemantics.label(available, languageCode: languageCode)),
                excludeSemantics: true,
                child: Text(
                  l10n.availableAmount(Money(available).format()),
                  style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                ),
              ),
            ),
            if (state.amountKobo != null) ...[
              SizedBox(height: 16.h),
              Semantics(
                liveRegion: true,
                label: '${l10n.feeLabel}: ${MoneySemantics.label(state.feeKobo, languageCode: languageCode)}',
                excludeSemantics: true,
                child: Text(
                  '${l10n.feeLabel}: ${Money(state.feeKobo).format()}',
                  style: AppTextStyles.small.sp.copyWith(fontFeatures: AppTextStyles.tabular),
                ),
              ),
            ],
            SizedBox(height: 24.h),
            NovaTextField(
              label: l10n.narrationLabel,
              hint: l10n.narrationHint,
              controller: controller.narrationController,
              maxLength: 50,
              onChanged: controller.onNarrationChanged,
            ),
          ],
        );
      },
    );
  }
}
