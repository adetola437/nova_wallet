import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/activity_item.dart';
import '../../../../core/models/outbox_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/text_style_x.dart';
import '../../../../core/utils/contract.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../send_money/presentation/widgets/summary_row.dart';
import '../../cubit/transaction_details_cubit.dart';

part '../contracts/transaction_details_contract.dart';
part '../views/transaction_details_view.dart';

/// What the details route receives: a tapped row, an outbox id, or both.
class TransactionDetailsArgs {
  const TransactionDetailsArgs({this.activity, this.outboxId});

  final ActivityItem? activity;
  final int? outboxId;
}

/// Board `2n`.
class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key, required this.args});

  final TransactionDetailsArgs args;

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen>
    implements TransactionDetailsControllerContract {
  late final TransactionDetailsViewContract view;

  @override
  void initState() {
    super.initState();
    view = TransactionDetailsView(controller: this);
    context.read<TransactionDetailsCubit>().open(activity: widget.args.activity, outboxId: widget.args.outboxId);
  }

  @override
  String formatDate(DateTime at) => DateFormat('d MMM yyyy, h:mm a', 'en').format(at);

  @override
  Widget build(BuildContext context) => view.build(context);
}
