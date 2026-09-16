part of '../controllers/nova_user_controller.dart';

class NovaUserView extends StatelessWidget implements NovaUserViewContract {
  const NovaUserView({super.key, required this.controller});

  final NovaUserControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<NameEnquiryCubit, NameEnquiryState>(
      builder: (context, state) {
        final verified = state.verified;
        final hasEmail = controller.emailController.text.trim().isNotEmpty;
        return NovaFormScaffold(
          appBarTitle: l10n.novaUserTitle,
          body: l10n.novaUserBody,
          actions: [
            if (verified == null)
              NovaButton(
                label: l10n.novaUserFind,
                icon: Icons.search_rounded,
                isLoading: state.isVerifying,
                onPressed: hasEmail ? controller.onFind : null,
              )
            else
              NovaButton(label: l10n.continueLabel, onPressed: controller.onContinue),
          ],
          content: [
            NovaTextField(
              label: l10n.email,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.search,
              autofillHints: const [AutofillHints.email],
              errorText: state.failure?.localized(l10n),
              onChanged: controller.onEmailChanged,
              onSubmitted: (_) => hasEmail ? controller.onFind() : null,
            ),
            if (verified != null) ...[
              SizedBox(height: 16.h),
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
                          Expanded(
                            child: Text(
                              l10n.novaUserFound,
                              style: AppTextStyles.caption.sp.copyWith(color: AppColors.sentInk),
                            ),
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
              SizedBox(height: 12.h),
              NoticeCard(icon: Icons.bolt_rounded, child: Text(l10n.novaUserFree)),
              SizedBox(height: 8.h),
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
          ],
        );
      },
    );
  }
}
