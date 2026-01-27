import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';

part 'account_state.freezed.dart';

/// Represents the current state of the user's account information.
/// Used to track authentication and account data throughout the app.
@freezed
abstract class AccountState with _$AccountState {
  /// Initial state before any account operations have been attempted.
  factory AccountState.initial() = AccountStateInitial;

  /// Loading state while fetching or creating account information.
  factory AccountState.loading() = AccountStateLoading;

  /// Error state when account operations fail.
  factory AccountState.withError({
    required ShoebillException exception,
  }) = AccountStateWithError;

  /// Success state with account data loaded.
  factory AccountState.withData({
    required AccountInfo accountInfo,
  }) = AccountStateWithData;
}
