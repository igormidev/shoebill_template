import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_page_providers.freezed.dart';

/// State for the landing page screen.
@freezed
abstract class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default(false) bool isLoading,
    String? thinkingText,
    String? errorMessage,
  }) = _LandingPageState;
}

/// Notifier for managing landing page state.
class LandingPageStateNotifier extends Notifier<LandingPageState> {
  @override
  LandingPageState build() => const LandingPageState();

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setThinkingText(String? text) {
    state = state.copyWith(thinkingText: text);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message, isLoading: false);
  }

  void reset() {
    state = const LandingPageState();
  }
}

final landingPageStateProvider =
    NotifierProvider<LandingPageStateNotifier, LandingPageState>(
  LandingPageStateNotifier.new,
);
