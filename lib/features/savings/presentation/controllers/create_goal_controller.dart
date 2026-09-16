import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/flavor/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/failure_text.dart';
import '../../../../core/money/money.dart';
import '../../../../core/money/progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/nova_button.dart';
import '../../../../core/widgets/nova_form_scaffold.dart';
import '../../../../core/widgets/nova_text_field.dart';
import '../../cubit/create_goal_cubit.dart';
import '../../cubit/create_goal_state.dart';

part '../contracts/create_goal_contract.dart';
part '../views/create_goal_view.dart';

/// Board `4c`. Queued like any other action, so it works offline too.
class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key, this.suggestedName});

  final String? suggestedName;

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> implements CreateGoalControllerContract {
  late final CreateGoalViewContract view;
  late final CreateGoalCubit _cubit = context.read<CreateGoalCubit>();

  @override
  late final TextEditingController nameController = TextEditingController(text: widget.suggestedName);
  @override
  final TextEditingController targetController = TextEditingController();
  @override
  int? selectedMonths;

  @override
  void initState() {
    super.initState();
    view = CreateGoalView(controller: this);
    if (widget.suggestedName != null) _cubit.nameChanged(widget.suggestedName!);
  }

  @override
  void dispose() {
    nameController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  String formatDate(DateTime date) => DateFormat('d MMM yyyy', 'en').format(date);

  @override
  void onNameChanged(String value) => _cubit.nameChanged(value);

  @override
  void onTargetChanged(String value) => _cubit.targetChanged(value);

  @override
  Future<void> onPickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 10),
      initialDate: _cubit.state.targetDate ?? now.add(const Duration(days: 90)),
    );
    if (picked == null || !mounted) return;
    setState(() => selectedMonths = null);
    _cubit.dateChanged(picked);
  }

  @override
  void onQuickDate(int months) {
    final now = DateTime.now();
    setState(() => selectedMonths = months);
    _cubit.dateChanged(DateTime(now.year, now.month + months, now.day));
  }

  @override
  Future<void> onSubmit() async {
    FocusScope.of(context).unfocus();
    await _cubit.submit();
    if (mounted && _cubit.state.created != null) context.pop();
  }

  @override
  Widget build(BuildContext context) => view.build(context);
}
