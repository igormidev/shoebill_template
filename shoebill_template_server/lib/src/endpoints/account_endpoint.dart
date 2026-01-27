import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// Endpoint for managing user accounts.
/// Requires authentication for all methods.
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets the account info for the currently authenticated user.
  /// If no account exists, creates a new one.
  ///
  /// [initialScaffoldId] - Optional scaffold UUID to attach to the account
  /// upon creation or login.
  Future<AccountInfo> getAccountInfo(
    Session session, {
    UuidValue? initialScaffoldId,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw ShoebillException(
        title: 'Authentication Failed',
        description: 'You must be logged in to access account information.',
      );
    }

    final userId = authenticationInfo.authUserId;

    // Try to find existing account
    AccountInfo? accountInfo;
    try {
      accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userId),
        include: _accountInclude,
      );
    } catch (e) {
      session.log(
        'Database error while fetching account for userId $userId',
        exception: e,
        level: LogLevel.error,
      );
      throw ShoebillException(
        title: 'Database Error',
        description: 'Failed to fetch account information. Please try again.',
      );
    }

    // If account exists
    if (accountInfo != null) {
      // Attach scaffold if provided
      if (initialScaffoldId != null) {
        await _attachScaffold(
          session,
          accountInfo: accountInfo,
          scaffoldId: initialScaffoldId,
        );
      }
      return accountInfo;
    }

    // Create new account
    try {
      return await session.db.transaction((transaction) async {
        // Get the EmailAccount to retrieve email (email IDP stores email there)
        final emailAccount = await EmailAccount.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(userId),
          transaction: transaction,
        );

        if (emailAccount == null) {
          throw ShoebillException(
            title: 'Email Account Not Found',
            description:
                'Could not find email account data. Please try logging in again.',
          );
        }

        // Create the account
        final newAccount = AccountInfo(
          authUserId: userId,
          email: emailAccount.email,
          name: null, // Name not stored in email IDP
          createdAt: DateTime.now(),
        );

        final insertedAccount = await AccountInfo.db.insertRow(
          session,
          newAccount,
          transaction: transaction,
        );

        // Attach scaffold if provided
        if (initialScaffoldId != null) {
          await _attachScaffold(
            session,
            accountInfo: insertedAccount,
            scaffoldId: initialScaffoldId,
            transaction: transaction,
          );
        }

        // Fetch the complete account with relations
        final completeAccount = await AccountInfo.db.findById(
          session,
          insertedAccount.id!,
          include: _accountInclude,
          transaction: transaction,
        );

        if (completeAccount == null) {
          throw ShoebillException(
            title: 'Account Creation Failed',
            description: 'Failed to retrieve newly created account.',
          );
        }

        session.log('Created new account for userId $userId');
        return completeAccount;
      });
    } catch (e) {
      if (e is ShoebillException) rethrow;

      session.log(
        'Error creating account for userId $userId',
        exception: e,
        level: LogLevel.error,
      );
      throw ShoebillException(
        title: 'Account Creation Error',
        description: 'Failed to create your account. Please try again later.',
      );
    }
  }

  /// Attaches a scaffold to the user's account.
  ///
  /// [scaffoldId] - The UUID of the scaffold to attach.
  Future<void> attachScaffold(
    Session session, {
    required UuidValue scaffoldId,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw ShoebillException(
        title: 'Authentication Failed',
        description: 'You must be logged in to attach a scaffold.',
      );
    }

    final userId = authenticationInfo.authUserId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );

    if (accountInfo == null) {
      throw ShoebillException(
        title: 'Account Not Found',
        description:
            'No account found. Please create an account first.',
      );
    }

    await _attachScaffold(
      session,
      accountInfo: accountInfo,
      scaffoldId: scaffoldId,
    );
  }

  /// Internal method to attach a scaffold to an account.
  Future<void> _attachScaffold(
    Session session, {
    required AccountInfo accountInfo,
    required UuidValue scaffoldId,
    Transaction? transaction,
  }) async {
    // Find the scaffold
    final scaffold = await ShoebillTemplateScaffold.db.findFirstRow(
      session,
      where: (t) => t.id.equals(scaffoldId),
      transaction: transaction,
    );

    if (scaffold == null) {
      throw ShoebillException(
        title: 'Scaffold Not Found',
        description: 'The specified template scaffold does not exist.',
      );
    }

    // Check if already attached to this account
    if (scaffold.accountId == accountInfo.id) {
      return; // Already attached, no action needed
    }

    // Check if attached to another account
    if (scaffold.accountId != null && scaffold.accountId != accountInfo.id) {
      throw ShoebillException(
        title: 'Scaffold Already Owned',
        description:
            'This template scaffold already belongs to another account.',
      );
    }

    // Update the scaffold with the account ID
    final updatedScaffold = scaffold.copyWith(accountId: accountInfo.id);

    await ShoebillTemplateScaffold.db.updateRow(
      session,
      updatedScaffold,
      transaction: transaction,
    );

    session.log(
      'Attached scaffold ${scaffoldId.uuid} to account ${accountInfo.id}',
    );
  }

  /// Gets all scaffolds owned by the current user's account.
  Future<List<ShoebillTemplateScaffold>> getMyScaffolds(Session session) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw ShoebillException(
        title: 'Authentication Failed',
        description: 'You must be logged in to view your scaffolds.',
      );
    }

    final userId = authenticationInfo.authUserId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );

    if (accountInfo == null) {
      return [];
    }

    final scaffolds = await ShoebillTemplateScaffold.db.find(
      session,
      where: (t) => t.accountId.equals(accountInfo.id),
      include: ShoebillTemplateScaffold.include(
        referencePdfContent: PdfContent.include(),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    return scaffolds;
  }

  /// Include configuration for loading account with its relations.
  static final _accountInclude = AccountInfo.include(
    authUser: AuthUser.include(),
    scaffolds: ShoebillTemplateScaffold.includeList(
      include: ShoebillTemplateScaffold.include(
        referencePdfContent: PdfContent.include(),
      ),
      limit: 20,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    ),
  );
}
