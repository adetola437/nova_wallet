part of '../controllers/create_goal_controller.dart';

class CreateGoalView extends StatelessWidget implements CreateGoalViewContract {
  const CreateGoalView({super.key, required this.controller});

  final CreateGoalControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CreateGoalCubit, CreateGoalState>(
      builder: (context, state) {
        final weekly = state.suggestedWeeklyKobo;
        final date = state.targetDate;
        return NovaFormScaffold(
          appBarTitle: l10n.createGoalTitle,
          actions: [
            NovaButton(label: l10n.createGoalCta, isLoading: state.isSubmitting, onPressed: controller.onSubmit),
          ],
          content: [
            NovaTextField(
              label: l10n.goalNameLabel,
              hint: l10n.goalNameHint,
              controller: controller.nameController,
              maxLength: 40,
              textInputAction: TextInputAction.next,
              onChanged: controller.onNameChanged,
            ),
            SizedBox(height: 16.h),
            NovaTextField(
              label: l10n.targetAmountLabel,
              controller: controller.targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              onChanged: controller.onTargetChanged,
              prefix: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 4.w),
                child: Align(widthFactor: 1, child: Text('₦', style: AppTextStyles.body.sp)),
              ),
            ),
            SizedBox(height: 16.h),
            ExcludeSemantics(child: Text(l10n.targetDateLabel, style: AppTextStyles.caption.sp)),
            SizedBox(height: 6.h),
            Semantics(
              button: true,
              label: l10n.targetDateLabel,
              value: date == null ? l10n.createGoalDateHint : controller.formatDate(date),
              excludeSemantics: true,
              child: InkWell(
                onTap: controller.onPickDate,
                borderRadius: BorderRadius.circular(12.r),
                child: InputDecorator(
                  decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today_rounded)),
                  child: Text(
                    date == null ? l10n.createGoalDateHint : controller.formatDate(date),
                    style: AppTextStyles.body.sp.copyWith(
                      color: date == null ? AppColors.textTertiary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final (months, label) in [(3, l10n.months3), (6, l10n.months6), (12, l10n.year1)])
                  ChoiceChip(
                    label: Text(label, style: AppTextStyles.small.sp.copyWith(color: AppColors.textPrimary)),
                    selected: controller.selectedMonths == months,
                    onSelected: (_) => controller.onQuickDate(months),
                    selectedColor: AppColors.pendingBg,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                  ),
              ],
            ),
            if (weekly != null && weekly > 0 && date != null) ...[
              SizedBox(height: 20.h),
              NoticeCard(
                icon: Icons.lightbulb_outline_rounded,
                background: AppColors.pendingBg,
                ink: AppColors.pendingInk,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.weeklyHint(Money(weekly).format(), controller.formatDate(date)),
                      style: AppTextStyles.body.sp.copyWith(color: AppColors.pendingInk),
                    ),
                    SizedBox(height: 4.h),
                    Text(l10n.weeklyHintSub),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20.h),
            // Told up front, before the goal exists (not first seen when breaking it).
            NoticeCard(
              icon: Icons.info_outline_rounded,
              child: Text(l10n.createGoalBreakNotice(Progress.formatPercent(AppConstants.goalBreakFeeBps))),
            ),
            if (state.failure != null) ...[SizedBox(height: 12.h), InlineError(state.failure!.localized(l10n))],
          ],
        );
      },
    );
  }
}
