// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Shoebill Template';

  @override
  String get app_subtitle => 'Build and deploy your templates with ease';

  @override
  String get landing_headline => 'Create Your Template';

  @override
  String get landing_subtitle => 'Upload your JSON schema to get started';

  @override
  String get landing_drag_json => 'Drag your JSON file here';

  @override
  String get landing_paste_json => 'Click here to paste JSON';

  @override
  String get landing_drop_files => 'or drop files here';

  @override
  String get landing_browse_files => 'Browse files';

  @override
  String get landing_invalid_json =>
      'Invalid JSON format. Please check your file.';

  @override
  String get landing_file_uploaded => 'File uploaded successfully';

  @override
  String get schema_review_title => 'Review Generated Schema';

  @override
  String get schema_review_instructions =>
      'Review and adjust the generated schema. Toggle required fields as needed.';

  @override
  String get schema_field_name => 'Field Name';

  @override
  String get schema_field_type => 'Type';

  @override
  String get schema_field_required => 'Required';

  @override
  String get schema_field_description => 'Description';

  @override
  String get schema_confirm => 'Confirm';

  @override
  String get schema_edit => 'Edit JSON';

  @override
  String get schema_no_fields => 'No fields detected in schema';

  @override
  String get schema_suggested_prompt => 'Suggested Prompt';

  @override
  String get schema_suggested_prompt_hint =>
      'This prompt will be used to generate the template';

  @override
  String get schema_type_string => 'String';

  @override
  String get schema_type_integer => 'Integer';

  @override
  String get schema_type_double => 'Double';

  @override
  String get schema_type_boolean => 'Boolean';

  @override
  String get schema_type_array => 'Array';

  @override
  String get schema_type_object => 'Object';

  @override
  String get schema_type_enum => 'Enum';

  @override
  String get schema_nullable => 'Nullable';

  @override
  String get chat_input_placeholder => 'Type your message...';

  @override
  String get chat_send => 'Send';

  @override
  String get chat_deploy => 'Deploy';

  @override
  String get chat_deploy_template => 'Deploy Template';

  @override
  String get chat_back => 'Back';

  @override
  String get chat_back_accessibility => 'Go back to previous screen';

  @override
  String get chat_loading => 'Processing your request...';

  @override
  String get chat_thinking => 'Thinking...';

  @override
  String get chat_error_sending => 'Failed to send message. Please try again.';

  @override
  String get chat_connection_error =>
      'Connection error. Please check your internet.';

  @override
  String get chat_success_deployed => 'Template deployed successfully!';

  @override
  String get chat_retry => 'Retry';

  @override
  String get chat_clear_history => 'Clear chat history';

  @override
  String get chat_clear_confirm =>
      'Are you sure you want to clear the chat history?';

  @override
  String get chat_empty_state => 'Start a conversation to build your template';

  @override
  String chat_message_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages',
      one: '1 message',
      zero: 'No messages',
    );
    return '$_temp0';
  }

  @override
  String get button_save => 'Save';

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_delete => 'Delete';

  @override
  String get button_confirm => 'Confirm';

  @override
  String get button_ok => 'OK';

  @override
  String get button_close => 'Close';

  @override
  String get button_next => 'Next';

  @override
  String get button_previous => 'Previous';

  @override
  String get button_submit => 'Submit';

  @override
  String get button_reset => 'Reset';

  @override
  String get button_continue => 'Continue';

  @override
  String get button_done => 'Done';

  @override
  String get button_edit => 'Edit';

  @override
  String get button_copy => 'Copy';

  @override
  String get button_share => 'Share';

  @override
  String get loading => 'Loading...';

  @override
  String get loading_please_wait => 'Please wait...';

  @override
  String get loading_data => 'Loading data...';

  @override
  String get loading_template => 'Loading template...';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get error_generic => 'Something went wrong. Please try again.';

  @override
  String get error_network => 'Network error. Please check your connection.';

  @override
  String get error_timeout => 'Request timed out. Please try again.';

  @override
  String get error_server => 'Server error. Please try again later.';

  @override
  String get error_not_found => 'The requested resource was not found.';

  @override
  String get error_unauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get error_validation => 'Please check your input and try again.';

  @override
  String get error_empty_field => 'This field cannot be empty';

  @override
  String get error_retry => 'Tap to retry';

  @override
  String get success_saved => 'Saved successfully!';

  @override
  String get success_deleted => 'Deleted successfully!';

  @override
  String get success_copied => 'Copied to clipboard!';

  @override
  String get success_updated => 'Updated successfully!';

  @override
  String get dialog_confirm_title => 'Confirm Action';

  @override
  String get dialog_confirm_message => 'Are you sure you want to proceed?';

  @override
  String get dialog_delete_title => 'Delete Item';

  @override
  String get dialog_delete_message =>
      'This action cannot be undone. Are you sure?';

  @override
  String get dialog_discard_title => 'Discard Changes';

  @override
  String get dialog_discard_message =>
      'You have unsaved changes. Discard them?';

  @override
  String get accessibility_menu => 'Open menu';

  @override
  String get accessibility_close => 'Close';

  @override
  String get accessibility_expand => 'Expand';

  @override
  String get accessibility_collapse => 'Collapse';

  @override
  String get accessibility_loading => 'Loading content';

  @override
  String get accessibility_error => 'Error occurred';
}
