import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/src/core/extension/serverpod_to_result.dart';
import 'package:shoebill_template_flutter/src/core/shared_providers/serverpod_providers.dart';
import 'package:shoebill_template_flutter/src/features/auth/account_state.dart';

/// Notifier for managing account state.
/// Handles fetching, creating, and updating account information.
class AccountStateNotifier extends Notifier<AccountState> {
  /// Optional scaffold ID to attach to the account upon creation or login.
  /// This is set when a user creates a template before logging in,
  /// allowing us to link it to their account after authentication.
  UuidValue? scaffoldIdToBeAttached;

  @override
  AccountState build() => AccountState.initial();

  /// Logs out the user and resets account state.
  void logOut() {
    scaffoldIdToBeAttached = null;
    state = AccountState.initial();
  }

  /// Fetches account info for the currently authenticated user.
  /// If no account exists, one will be created on the server.
  ///
  /// [force] - If true, will refetch even if data is already loaded.
  ///
  /// If [scaffoldIdToBeAttached] is set, it will be sent to the server
  /// to link the scaffold to the user's account.
  Future<void> getAccountInfo({bool force = false}) async {
    final isAlreadyWithData = state.maybeWhen(
      withData: (_) => true,
      orElse: () => false,
    );

    if (isAlreadyWithData && !force) {
      return;
    }

    state = AccountState.loading();

    final scaffoldId = scaffoldIdToBeAttached;
    final result = await ref
        .read(clientProvider)
        .account
        .getAccountInfo(initialScaffoldId: scaffoldId)
        .toResult;

    result.fold(
      (accountInfo) {
        scaffoldIdToBeAttached = null;
        state = AccountState.withData(accountInfo: accountInfo);
      },
      (failure) {
        state = AccountState.withError(exception: failure);
      },
    );
  }

  /// Attaches a scaffold to the current user's account.
  ///
  /// [scaffoldId] - The UUID of the scaffold to attach.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> attachScaffold(UuidValue scaffoldId) async {
    final result = await ref
        .read(clientProvider)
        .account
        .attachScaffold(scaffoldId: scaffoldId)
        .toResult;

    return result.fold(
      (_) {
        // Refresh account info to get updated scaffolds list
        getAccountInfo(force: true);
        return true;
      },
      (_) => false,
    );
  }

  /// Sets the scaffold ID to be attached when the user logs in.
  /// This is used when a user creates a template before authenticating.
  void setScaffoldToAttach(UuidValue scaffoldId) {
    scaffoldIdToBeAttached = scaffoldId;
  }

  /// Manually sets the account info (useful after login flow).
  void setAccountInfo(AccountInfo accountInfo) {
    scaffoldIdToBeAttached = null;
    state = AccountState.withData(accountInfo: accountInfo);
  }

  /// Clears any pending scaffold attachment.
  void clearPendingScaffold() {
    scaffoldIdToBeAttached = null;
  }
}

/// Provider for the account state notifier.
final accountProvider =
    NotifierProvider<AccountStateNotifier, AccountState>(AccountStateNotifier.new);

/// Provider that exposes whether the user has an authenticated account.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final accountState = ref.watch(accountProvider);
  return accountState.maybeWhen(
    withData: (_) => true,
    orElse: () => false,
  );
});

/// Provider that exposes the current account info, or null if not loaded.
final currentAccountProvider = Provider<AccountInfo?>((ref) {
  final accountState = ref.watch(accountProvider);
  return accountState.maybeWhen(
    withData: (accountInfo) => accountInfo,
    orElse: () => null,
  );
});

/// Provider that exposes the account loading state.
final isAccountLoadingProvider = Provider<bool>((ref) {
  final accountState = ref.watch(accountProvider);
  return accountState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});
