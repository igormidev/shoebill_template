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
import '../../../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'messages/chat_message.dart' as _i3;
import 'package:shoebill_template_server/src/generated/protocol.dart' as _i4;
import 'template_current_state/template_current_state.dart' as _i5;
part 'chat_message_response.dart';
part 'template_state_response.dart';

sealed class SendMessageStreamResponseItem
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SendMessageStreamResponseItem();

  /// Returns a shallow copy of this [SendMessageStreamResponseItem]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SendMessageStreamResponseItem copyWith();
}
