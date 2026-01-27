import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_ja.dart';
import 's_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('pt'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Shoebill Template'**
  String get app_title;

  /// No description provided for @app_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Build and deploy your templates with ease'**
  String get app_subtitle;

  /// No description provided for @landing_headline.
  ///
  /// In en, this message translates to:
  /// **'Create Your Template'**
  String get landing_headline;

  /// No description provided for @landing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your JSON schema to get started'**
  String get landing_subtitle;

  /// No description provided for @landing_drag_json.
  ///
  /// In en, this message translates to:
  /// **'Drag your JSON file here'**
  String get landing_drag_json;

  /// No description provided for @landing_paste_json.
  ///
  /// In en, this message translates to:
  /// **'Click here to paste JSON'**
  String get landing_paste_json;

  /// No description provided for @landing_drop_files.
  ///
  /// In en, this message translates to:
  /// **'or drop files here'**
  String get landing_drop_files;

  /// No description provided for @landing_browse_files.
  ///
  /// In en, this message translates to:
  /// **'Browse files'**
  String get landing_browse_files;

  /// No description provided for @landing_invalid_json.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON format. Please check your file.'**
  String get landing_invalid_json;

  /// No description provided for @landing_file_uploaded.
  ///
  /// In en, this message translates to:
  /// **'File uploaded successfully'**
  String get landing_file_uploaded;

  /// No description provided for @schema_review_title.
  ///
  /// In en, this message translates to:
  /// **'Review Generated Schema'**
  String get schema_review_title;

  /// No description provided for @schema_review_instructions.
  ///
  /// In en, this message translates to:
  /// **'Review and adjust the generated schema. Toggle required fields as needed.'**
  String get schema_review_instructions;

  /// No description provided for @schema_field_name.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get schema_field_name;

  /// No description provided for @schema_field_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get schema_field_type;

  /// No description provided for @schema_field_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get schema_field_required;

  /// No description provided for @schema_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get schema_field_description;

  /// No description provided for @schema_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get schema_confirm;

  /// No description provided for @schema_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit JSON'**
  String get schema_edit;

  /// No description provided for @schema_no_fields.
  ///
  /// In en, this message translates to:
  /// **'No fields detected in schema'**
  String get schema_no_fields;

  /// No description provided for @schema_suggested_prompt.
  ///
  /// In en, this message translates to:
  /// **'Suggested Prompt'**
  String get schema_suggested_prompt;

  /// No description provided for @schema_suggested_prompt_hint.
  ///
  /// In en, this message translates to:
  /// **'This prompt will be used to generate the template'**
  String get schema_suggested_prompt_hint;

  /// No description provided for @schema_type_string.
  ///
  /// In en, this message translates to:
  /// **'String'**
  String get schema_type_string;

  /// No description provided for @schema_type_integer.
  ///
  /// In en, this message translates to:
  /// **'Integer'**
  String get schema_type_integer;

  /// No description provided for @schema_type_double.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get schema_type_double;

  /// No description provided for @schema_type_boolean.
  ///
  /// In en, this message translates to:
  /// **'Boolean'**
  String get schema_type_boolean;

  /// No description provided for @schema_type_array.
  ///
  /// In en, this message translates to:
  /// **'Array'**
  String get schema_type_array;

  /// No description provided for @schema_type_object.
  ///
  /// In en, this message translates to:
  /// **'Object'**
  String get schema_type_object;

  /// No description provided for @schema_type_enum.
  ///
  /// In en, this message translates to:
  /// **'Enum'**
  String get schema_type_enum;

  /// No description provided for @schema_nullable.
  ///
  /// In en, this message translates to:
  /// **'Nullable'**
  String get schema_nullable;

  /// No description provided for @chat_input_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chat_input_placeholder;

  /// No description provided for @chat_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chat_send;

  /// No description provided for @chat_deploy.
  ///
  /// In en, this message translates to:
  /// **'Deploy'**
  String get chat_deploy;

  /// No description provided for @chat_deploy_template.
  ///
  /// In en, this message translates to:
  /// **'Deploy Template'**
  String get chat_deploy_template;

  /// No description provided for @chat_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get chat_back;

  /// No description provided for @chat_back_accessibility.
  ///
  /// In en, this message translates to:
  /// **'Go back to previous screen'**
  String get chat_back_accessibility;

  /// No description provided for @chat_loading.
  ///
  /// In en, this message translates to:
  /// **'Processing your request...'**
  String get chat_loading;

  /// No description provided for @chat_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get chat_thinking;

  /// No description provided for @chat_error_sending.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get chat_error_sending;

  /// No description provided for @chat_connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet.'**
  String get chat_connection_error;

  /// No description provided for @chat_success_deployed.
  ///
  /// In en, this message translates to:
  /// **'Template deployed successfully!'**
  String get chat_success_deployed;

  /// No description provided for @chat_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chat_retry;

  /// No description provided for @chat_clear_history.
  ///
  /// In en, this message translates to:
  /// **'Clear chat history'**
  String get chat_clear_history;

  /// No description provided for @chat_clear_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the chat history?'**
  String get chat_clear_confirm;

  /// No description provided for @chat_empty_state.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation to build your template'**
  String get chat_empty_state;

  /// No description provided for @chat_message_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No messages} =1{1 message} other{{count} messages}}'**
  String chat_message_count(int count);

  /// No description provided for @button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get button_save;

  /// No description provided for @button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// No description provided for @button_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get button_delete;

  /// No description provided for @button_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get button_confirm;

  /// No description provided for @button_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get button_ok;

  /// No description provided for @button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get button_close;

  /// No description provided for @button_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get button_next;

  /// No description provided for @button_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get button_previous;

  /// No description provided for @button_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get button_submit;

  /// No description provided for @button_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get button_reset;

  /// No description provided for @button_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get button_continue;

  /// No description provided for @button_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get button_done;

  /// No description provided for @button_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get button_edit;

  /// No description provided for @button_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get button_copy;

  /// No description provided for @button_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get button_share;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loading_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loading_please_wait;

  /// No description provided for @loading_data.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loading_data;

  /// No description provided for @loading_template.
  ///
  /// In en, this message translates to:
  /// **'Loading template...'**
  String get loading_template;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_generic;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get error_network;

  /// No description provided for @error_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get error_timeout;

  /// No description provided for @error_server.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_server;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get error_not_found;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action.'**
  String get error_unauthorized;

  /// No description provided for @error_validation.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get error_validation;

  /// No description provided for @error_empty_field.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get error_empty_field;

  /// No description provided for @error_retry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get error_retry;

  /// No description provided for @success_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully!'**
  String get success_saved;

  /// No description provided for @success_deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully!'**
  String get success_deleted;

  /// No description provided for @success_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get success_copied;

  /// No description provided for @success_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully!'**
  String get success_updated;

  /// No description provided for @dialog_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get dialog_confirm_title;

  /// No description provided for @dialog_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to proceed?'**
  String get dialog_confirm_message;

  /// No description provided for @dialog_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get dialog_delete_title;

  /// No description provided for @dialog_delete_message.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure?'**
  String get dialog_delete_message;

  /// No description provided for @dialog_discard_title.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get dialog_discard_title;

  /// No description provided for @dialog_discard_message.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get dialog_discard_message;

  /// No description provided for @accessibility_menu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get accessibility_menu;

  /// No description provided for @accessibility_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get accessibility_close;

  /// No description provided for @accessibility_expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get accessibility_expand;

  /// No description provided for @accessibility_collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get accessibility_collapse;

  /// No description provided for @accessibility_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading content'**
  String get accessibility_loading;

  /// No description provided for @accessibility_error.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get accessibility_error;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ja':
      return SJa();
    case 'pt':
      return SPt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
