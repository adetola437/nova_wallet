import 'package:equatable/equatable.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';

enum WalletStatus { initial, loading, ready, error }

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.overview = WalletOverview.empty,
    this.activity = const [],
    this.isRefreshing = false,
    this.lastRefreshFailure,
    this.limit = AppConstants.pageSize,
  });

  final WalletStatus status;
  final WalletOverview overview;
  final List<ActivityItem> activity;
  final bool isRefreshing;

  /// Set when a refresh failed while cached figures are still on screen
  /// ("Last updated …").
  final Failure? lastRefreshFailure;
  final int limit;

  WalletState copyWith({
    WalletStatus? status,
    WalletOverview? overview,
    List<ActivityItem>? activity,
    bool? isRefreshing,
    Failure? lastRefreshFailure,
    bool clearFailure = false,
    int? limit,
  }) => WalletState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    activity: activity ?? this.activity,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    lastRefreshFailure: clearFailure ? null : (lastRefreshFailure ?? this.lastRefreshFailure),
    limit: limit ?? this.limit,
  );

  @override
  List<Object?> get props => [status, overview, activity, isRefreshing, lastRefreshFailure, limit];
}
