/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:shoebill_template_client/src/protocol/api/chat_session_related/entities/template_current_state/template_current_state.dart'
    as _i3;
import 'package:shoebill_template_client/src/protocol/api/chat_session_related/entities/send_message_stream_response_item.dart'
    as _i4;
import 'package:shoebill_template_client/src/protocol/api/chat_session_related/entities/new_schema_change_payload.dart'
    as _i5;
import 'package:shoebill_template_client/src/protocol/api/chat_session_related/entities/create_template_essentials_result.dart'
    as _i6;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i7;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i8;
import 'package:shoebill_template_client/src/protocol/greetings/greeting.dart'
    as _i9;
import 'protocol.dart' as _i10;

/// {@category Endpoint}
class EndpointChatSession extends _i1.EndpointRef {
  EndpointChatSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chatSession';

  /// Starts a new chat session for creating a brand new template.
  ///
  /// The [newTemplateState] provides the initial schema, payload example,
  /// reference language, and PDF content metadata (name/description).
  /// No HTML/CSS exists yet - the AI will generate it during the chat.
  _i2.Future<String> startChatFromNewTemplate({
    required _i3.NewTemplateState newTemplateState,
  }) => caller.callServerEndpoint<String>(
    'chatSession',
    'startChatFromNewTemplate',
    {'newTemplateState': newTemplateState},
  );

  /// Starts a new chat session for editing an existing template version.
  ///
  /// Loads the full entity hierarchy (version -> scaffold, schema, input HTML/CSS)
  /// and the baseline implementation for the reference language.
  /// Creates a [DeployReadyTemplateState] with the current HTML/CSS content.
  ///
  /// [templateVersionId] is the integer ID of the [ShoebillTemplateVersion] to edit.
  _i2.Future<String> startChatFromExistingTemplate({
    required int templateVersionId,
  }) => caller.callServerEndpoint<String>(
    'chatSession',
    'startChatFromExistingTemplate',
    {'templateVersionId': templateVersionId},
  );

  /// Sends a message in the chat session, optionally applying a schema change.
  ///
  /// Returns a stream of [SendMessageStreamResponseItem] which can be either:
  /// - [ChatMessageResponse]: wraps a [ChatMessage] (thinking, text, errors, etc.)
  /// - [TemplateStateResponse]: provides the updated [TemplateCurrentState] after processing
  ///
  /// If [schemaChange] is provided:
  /// - Validates the new example payload against the new schema
  /// - Marks the session as having a schema change (affects deploy behavior)
  /// - Updates the session template info with new schema and payload
  _i2.Future<_i2.Stream<_i4.SendMessageStreamResponseItem>> sendMessage({
    required String sessionUUID,
    required String message,
    _i5.NewSchemaChangePayload? schemaChange,
  }) =>
      caller.callServerEndpoint<_i2.Stream<_i4.SendMessageStreamResponseItem>>(
        'chatSession',
        'sendMessage',
        {
          'sessionUUID': sessionUUID,
          'message': message,
          'schemaChange': schemaChange,
        },
      );

  /// Deploys the session, persisting the template to the database.
  ///
  /// The behavior depends on whether this is a new template or existing one,
  /// and whether the schema was changed during the session:
  ///
  /// - **New template**: Creates a new [ShoebillTemplateScaffold] with a first version.
  /// - **Existing template, no schema change**: Updates the HTML/CSS in place
  ///   on the current [ShoebillTemplateVersion]. Old baselines continue to work.
  /// - **Existing template, schema changed**: Creates a new [ShoebillTemplateVersion]
  ///   under the same scaffold. The old version remains intact for backward compatibility.
  ///
  /// Returns the UUID of the scaffold (for new templates) or the scaffold UUID
  /// (for existing templates). The caller can use this to navigate back to the
  /// template dashboard.
  _i2.Future<_i1.UuidValue> deploySession({required String sessionUUID}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'chatSession',
        'deploySession',
        {'sessionUUID': sessionUUID},
      );
}

/// {@category Endpoint}
class EndpointCreateTemplateEssentials extends _i1.EndpointRef {
  EndpointCreateTemplateEssentials(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'createTemplateEssentials';

  /// Creates template essentials from a JSON payload.
  /// The AI will analyze the payload and generate:
  /// - A title and description for the template
  /// - A schema definition that matches the JSON structure
  /// - A suggested prompt for Jinja2 HTML/CSS template generation
  /// - The detected reference language
  ///
  /// Returns a stream that yields either:
  /// - [TemplateEssentialThinkingResult] during AI reasoning
  /// - [TemplateEssentialFinalResult] when the final result is ready
  _i2.Stream<_i6.CreateTemplateEssentialsResult> call({
    required String stringifiedPayload,
  }) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i6.CreateTemplateEssentialsResult>,
        _i6.CreateTemplateEssentialsResult
      >(
        'createTemplateEssentials',
        'call',
        {'stringifiedPayload': stringifiedPayload},
        {},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i7.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i8.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i8.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i8.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i8.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i8.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i8.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i8.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i9.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i9.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i7.Caller(client);
    serverpod_auth_core = _i8.Caller(client);
  }

  late final _i7.Caller serverpod_auth_idp;

  late final _i8.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i10.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    chatSession = EndpointChatSession(this);
    createTemplateEssentials = EndpointCreateTemplateEssentials(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointChatSession chatSession;

  late final EndpointCreateTemplateEssentials createTemplateEssentials;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'chatSession': chatSession,
    'createTemplateEssentials': createTemplateEssentials,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'greeting': greeting,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
