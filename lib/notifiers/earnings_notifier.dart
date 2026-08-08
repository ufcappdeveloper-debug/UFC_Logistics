import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/models/earnings_model.dart';
import 'package:ufc_delivery_app/services/earnings_service.dart';

class EarningsState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final EarningsModel? earningsData;

  EarningsState({
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    this.earningsData,
  });

  EarningsState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    EarningsModel? earningsData,
  }) {
    return EarningsState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      earningsData: earningsData ?? this.earningsData,
    );
  }
}

// earnings_notifier.dart

class EarningsNotifier extends StateNotifier<EarningsState> {
  final EarningsService earningsService;

  EarningsNotifier(this.earningsService)
      : super(EarningsState(isLoading: true, hasError: false));

  Future<void> fetchEarnings() async {
    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final earningsData = await earningsService.fetchEarningsAnalytics();
      state = state.copyWith(isLoading: false, earningsData: earningsData);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, hasError: true, errorMessage: e.toString());
    }
  }
}
