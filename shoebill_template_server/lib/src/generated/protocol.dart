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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'api/chat_session_related/entities/send_message_stream_response_item.dart'
    as _i5;
import 'api/chat_session_related/entities/create_template_essentials_result.dart'
    as _i6;
import 'api/chat_session_related/entities/messages/chat_actor.dart' as _i7;
import 'api/chat_session_related/entities/messages/chat_message.dart' as _i8;
import 'api/chat_session_related/entities/messages/chat_ui_style.dart' as _i9;
import 'api/chat_session_related/entities/new_schema_change_payload.dart'
    as _i10;
import 'api/chat_session_related/entities/template_current_state/template_current_state.dart'
    as _i11;
import 'api/chat_session_related/entities/template_essential.dart' as _i12;
import 'api/pdf_related/entities/pdf_content.dart' as _i13;
import 'api/pdf_related/entities/schema_definition.dart' as _i14;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i15;
import 'api/pdf_related/entities/template_entities/shoebill_template_baseline.dart'
    as _i16;
import 'api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart'
    as _i17;
import 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i18;
import 'api/pdf_related/entities/template_entities/shoebill_template_version.dart'
    as _i19;
import 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart'
    as _i20;
import 'entities/account/account.dart' as _i21;
import 'entities/others/ai_thinking_chunk.dart' as _i22;
import 'entities/others/shoebill_exception.dart' as _i23;
import 'entities/others/supported_languages.dart' as _i24;
import 'greetings/greeting.dart' as _i25;
import 'package:shoebill_template_server/src/generated/api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart'
    as _i26;
export 'api/chat_session_related/entities/create_template_essentials_result.dart';
export 'api/chat_session_related/entities/messages/chat_actor.dart';
export 'api/chat_session_related/entities/messages/chat_message.dart';
export 'api/chat_session_related/entities/messages/chat_ui_style.dart';
export 'api/chat_session_related/entities/new_schema_change_payload.dart';
export 'api/chat_session_related/entities/send_message_stream_response_item.dart';
export 'api/chat_session_related/entities/template_current_state/template_current_state.dart';
export 'api/chat_session_related/entities/template_essential.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_baseline.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_scaffold.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version.dart';
export 'api/pdf_related/entities/template_entities/shoebill_template_version_input.dart';
export 'entities/account/account.dart';
export 'entities/others/ai_thinking_chunk.dart';
export 'entities/others/shoebill_exception.dart';
export 'entities/others/supported_languages.dart';
export 'entities/template/shoebill_template.dart';
export 'greetings/greeting.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'account_info',
      dartName: 'AccountInfo',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_info_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_info_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auth_user_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'email_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'pdf_content',
      dartName: 'PdfContent',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'pdf_content_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pdf_content_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'schema_definitions',
      dartName: 'SchemaDefinition',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'schema_definitions_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'properties',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,protocol:SchemaProperty>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'schema_definitions_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shoebill_template_baseline_implementations',
      dartName: 'ShoebillTemplateBaselineImplementation',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'shoebill_template_baseline_implementations_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stringifiedPayload',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'language',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SupportedLanguage',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'baselineId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_baseline_implementations_fk_0',
          columns: ['baselineId'],
          referenceTable: 'shoebill_template_baselines',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shoebill_template_baseline_implementations_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shoebill_template_baselines',
      dartName: 'ShoebillTemplateBaseline',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'referenceLanguage',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SupportedLanguage',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'versionId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_baselines_fk_0',
          columns: ['versionId'],
          referenceTable: 'shoebill_template_versions',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shoebill_template_baselines_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shoebill_template_scaffolds',
      dartName: 'ShoebillTemplateScaffold',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'referencePdfContentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'accountId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_scaffolds_fk_0',
          columns: ['referencePdfContentId'],
          referenceTable: 'pdf_content',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_scaffolds_fk_1',
          columns: ['accountId'],
          referenceTable: 'account_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shoebill_template_scaffolds_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shoebill_template_version_inputs',
      dartName: 'ShoebillTemplateVersionInput',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'shoebill_template_version_inputs_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'htmlContent',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cssContent',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shoebill_template_version_inputs_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shoebill_template_versions',
      dartName: 'ShoebillTemplateVersion',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'shoebill_template_versions_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'schemaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'inputId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'scaffoldId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_versions_fk_0',
          columns: ['schemaId'],
          referenceTable: 'schema_definitions',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_versions_fk_1',
          columns: ['inputId'],
          referenceTable: 'shoebill_template_version_inputs',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'shoebill_template_versions_fk_2',
          columns: ['scaffoldId'],
          referenceTable: 'shoebill_template_scaffolds',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shoebill_template_versions_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'template_input_unique_index',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'inputId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.ChatMessageResponse) {
      return _i5.ChatMessageResponse.fromJson(data) as T;
    }
    if (t == _i6.TemplateEssentialFinalResult) {
      return _i6.TemplateEssentialFinalResult.fromJson(data) as T;
    }
    if (t == _i6.TemplateEssentialThinkingResult) {
      return _i6.TemplateEssentialThinkingResult.fromJson(data) as T;
    }
    if (t == _i7.ChatActor) {
      return _i7.ChatActor.fromJson(data) as T;
    }
    if (t == _i8.ChatMessage) {
      return _i8.ChatMessage.fromJson(data) as T;
    }
    if (t == _i9.ChatUIStyle) {
      return _i9.ChatUIStyle.fromJson(data) as T;
    }
    if (t == _i10.NewSchemaChangePayload) {
      return _i10.NewSchemaChangePayload.fromJson(data) as T;
    }
    if (t == _i5.TemplateStateResponse) {
      return _i5.TemplateStateResponse.fromJson(data) as T;
    }
    if (t == _i11.DeployReadyTemplateState) {
      return _i11.DeployReadyTemplateState.fromJson(data) as T;
    }
    if (t == _i11.NewTemplateState) {
      return _i11.NewTemplateState.fromJson(data) as T;
    }
    if (t == _i12.TemplateEssential) {
      return _i12.TemplateEssential.fromJson(data) as T;
    }
    if (t == _i13.PdfContent) {
      return _i13.PdfContent.fromJson(data) as T;
    }
    if (t == _i14.SchemaDefinition) {
      return _i14.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyArray) {
      return _i15.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyBoolean) {
      return _i15.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyDouble) {
      return _i15.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyEnum) {
      return _i15.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyInteger) {
      return _i15.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyObjectWithUndefinedProperties) {
      return _i15.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i15.SchemaPropertyString) {
      return _i15.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i15.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i15.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i16.ShoebillTemplateBaseline) {
      return _i16.ShoebillTemplateBaseline.fromJson(data) as T;
    }
    if (t == _i17.ShoebillTemplateBaselineImplementation) {
      return _i17.ShoebillTemplateBaselineImplementation.fromJson(data) as T;
    }
    if (t == _i18.ShoebillTemplateScaffold) {
      return _i18.ShoebillTemplateScaffold.fromJson(data) as T;
    }
    if (t == _i19.ShoebillTemplateVersion) {
      return _i19.ShoebillTemplateVersion.fromJson(data) as T;
    }
    if (t == _i20.ShoebillTemplateVersionInput) {
      return _i20.ShoebillTemplateVersionInput.fromJson(data) as T;
    }
    if (t == _i21.AccountInfo) {
      return _i21.AccountInfo.fromJson(data) as T;
    }
    if (t == _i22.AiThinkingChunk) {
      return _i22.AiThinkingChunk.fromJson(data) as T;
    }
    if (t == _i23.ShoebillException) {
      return _i23.ShoebillException.fromJson(data) as T;
    }
    if (t == _i24.SupportedLanguage) {
      return _i24.SupportedLanguage.fromJson(data) as T;
    }
    if (t == _i25.Greeting) {
      return _i25.Greeting.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ChatMessageResponse?>()) {
      return (data != null ? _i5.ChatMessageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.TemplateEssentialFinalResult?>()) {
      return (data != null
              ? _i6.TemplateEssentialFinalResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.TemplateEssentialThinkingResult?>()) {
      return (data != null
              ? _i6.TemplateEssentialThinkingResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i7.ChatActor?>()) {
      return (data != null ? _i7.ChatActor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ChatMessage?>()) {
      return (data != null ? _i8.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ChatUIStyle?>()) {
      return (data != null ? _i9.ChatUIStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.NewSchemaChangePayload?>()) {
      return (data != null ? _i10.NewSchemaChangePayload.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.TemplateStateResponse?>()) {
      return (data != null ? _i5.TemplateStateResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.DeployReadyTemplateState?>()) {
      return (data != null
              ? _i11.DeployReadyTemplateState.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.NewTemplateState?>()) {
      return (data != null ? _i11.NewTemplateState.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.TemplateEssential?>()) {
      return (data != null ? _i12.TemplateEssential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.PdfContent?>()) {
      return (data != null ? _i13.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.SchemaDefinition?>()) {
      return (data != null ? _i14.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyArray?>()) {
      return (data != null ? _i15.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyBoolean?>()) {
      return (data != null ? _i15.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyDouble?>()) {
      return (data != null ? _i15.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyEnum?>()) {
      return (data != null ? _i15.SchemaPropertyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyInteger?>()) {
      return (data != null ? _i15.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i15.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.SchemaPropertyString?>()) {
      return (data != null ? _i15.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i15.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i15.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.ShoebillTemplateBaseline?>()) {
      return (data != null
              ? _i16.ShoebillTemplateBaseline.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.ShoebillTemplateBaselineImplementation?>()) {
      return (data != null
              ? _i17.ShoebillTemplateBaselineImplementation.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i18.ShoebillTemplateScaffold?>()) {
      return (data != null
              ? _i18.ShoebillTemplateScaffold.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.ShoebillTemplateVersion?>()) {
      return (data != null ? _i19.ShoebillTemplateVersion.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.ShoebillTemplateVersionInput?>()) {
      return (data != null
              ? _i20.ShoebillTemplateVersionInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i21.AccountInfo?>()) {
      return (data != null ? _i21.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.AiThinkingChunk?>()) {
      return (data != null ? _i22.AiThinkingChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.ShoebillException?>()) {
      return (data != null ? _i23.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.SupportedLanguage?>()) {
      return (data != null ? _i24.SupportedLanguage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.Greeting?>()) {
      return (data != null ? _i25.Greeting.fromJson(data) : null) as T;
    }
    if (t == Map<String, _i15.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i15.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i17.ShoebillTemplateBaselineImplementation>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<_i17.ShoebillTemplateBaselineImplementation>(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1.getType<List<_i17.ShoebillTemplateBaselineImplementation>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            _i17.ShoebillTemplateBaselineImplementation
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i19.ShoebillTemplateVersion>) {
      return (data as List)
              .map((e) => deserialize<_i19.ShoebillTemplateVersion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i19.ShoebillTemplateVersion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i19.ShoebillTemplateVersion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i16.ShoebillTemplateBaseline>) {
      return (data as List)
              .map((e) => deserialize<_i16.ShoebillTemplateBaseline>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i16.ShoebillTemplateBaseline>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i16.ShoebillTemplateBaseline>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i18.ShoebillTemplateScaffold>) {
      return (data as List)
              .map((e) => deserialize<_i18.ShoebillTemplateScaffold>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i18.ShoebillTemplateScaffold>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i18.ShoebillTemplateScaffold>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i26.ShoebillTemplateScaffold>) {
      return (data as List)
              .map((e) => deserialize<_i26.ShoebillTemplateScaffold>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ChatMessageResponse => 'ChatMessageResponse',
      _i6.TemplateEssentialFinalResult => 'TemplateEssentialFinalResult',
      _i6.TemplateEssentialThinkingResult => 'TemplateEssentialThinkingResult',
      _i7.ChatActor => 'ChatActor',
      _i8.ChatMessage => 'ChatMessage',
      _i9.ChatUIStyle => 'ChatUIStyle',
      _i10.NewSchemaChangePayload => 'NewSchemaChangePayload',
      _i5.TemplateStateResponse => 'TemplateStateResponse',
      _i11.DeployReadyTemplateState => 'DeployReadyTemplateState',
      _i11.NewTemplateState => 'NewTemplateState',
      _i12.TemplateEssential => 'TemplateEssential',
      _i13.PdfContent => 'PdfContent',
      _i14.SchemaDefinition => 'SchemaDefinition',
      _i15.SchemaPropertyArray => 'SchemaPropertyArray',
      _i15.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i15.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i15.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i15.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i15.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i15.SchemaPropertyString => 'SchemaPropertyString',
      _i15.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i16.ShoebillTemplateBaseline => 'ShoebillTemplateBaseline',
      _i17.ShoebillTemplateBaselineImplementation =>
        'ShoebillTemplateBaselineImplementation',
      _i18.ShoebillTemplateScaffold => 'ShoebillTemplateScaffold',
      _i19.ShoebillTemplateVersion => 'ShoebillTemplateVersion',
      _i20.ShoebillTemplateVersionInput => 'ShoebillTemplateVersionInput',
      _i21.AccountInfo => 'AccountInfo',
      _i22.AiThinkingChunk => 'AiThinkingChunk',
      _i23.ShoebillException => 'ShoebillException',
      _i24.SupportedLanguage => 'SupportedLanguage',
      _i25.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'shoebill_template.',
        '',
      );
    }

    switch (data) {
      case _i5.ChatMessageResponse():
        return 'ChatMessageResponse';
      case _i6.TemplateEssentialFinalResult():
        return 'TemplateEssentialFinalResult';
      case _i6.TemplateEssentialThinkingResult():
        return 'TemplateEssentialThinkingResult';
      case _i7.ChatActor():
        return 'ChatActor';
      case _i8.ChatMessage():
        return 'ChatMessage';
      case _i9.ChatUIStyle():
        return 'ChatUIStyle';
      case _i10.NewSchemaChangePayload():
        return 'NewSchemaChangePayload';
      case _i5.TemplateStateResponse():
        return 'TemplateStateResponse';
      case _i11.DeployReadyTemplateState():
        return 'DeployReadyTemplateState';
      case _i11.NewTemplateState():
        return 'NewTemplateState';
      case _i12.TemplateEssential():
        return 'TemplateEssential';
      case _i13.PdfContent():
        return 'PdfContent';
      case _i14.SchemaDefinition():
        return 'SchemaDefinition';
      case _i15.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i15.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i15.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i15.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i15.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i15.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i15.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i15.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i16.ShoebillTemplateBaseline():
        return 'ShoebillTemplateBaseline';
      case _i17.ShoebillTemplateBaselineImplementation():
        return 'ShoebillTemplateBaselineImplementation';
      case _i18.ShoebillTemplateScaffold():
        return 'ShoebillTemplateScaffold';
      case _i19.ShoebillTemplateVersion():
        return 'ShoebillTemplateVersion';
      case _i20.ShoebillTemplateVersionInput():
        return 'ShoebillTemplateVersionInput';
      case _i21.AccountInfo():
        return 'AccountInfo';
      case _i22.AiThinkingChunk():
        return 'AiThinkingChunk';
      case _i23.ShoebillException():
        return 'ShoebillException';
      case _i24.SupportedLanguage():
        return 'SupportedLanguage';
      case _i25.Greeting():
        return 'Greeting';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ChatMessageResponse') {
      return deserialize<_i5.ChatMessageResponse>(data['data']);
    }
    if (dataClassName == 'TemplateEssentialFinalResult') {
      return deserialize<_i6.TemplateEssentialFinalResult>(data['data']);
    }
    if (dataClassName == 'TemplateEssentialThinkingResult') {
      return deserialize<_i6.TemplateEssentialThinkingResult>(data['data']);
    }
    if (dataClassName == 'ChatActor') {
      return deserialize<_i7.ChatActor>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i8.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatUIStyle') {
      return deserialize<_i9.ChatUIStyle>(data['data']);
    }
    if (dataClassName == 'NewSchemaChangePayload') {
      return deserialize<_i10.NewSchemaChangePayload>(data['data']);
    }
    if (dataClassName == 'TemplateStateResponse') {
      return deserialize<_i5.TemplateStateResponse>(data['data']);
    }
    if (dataClassName == 'DeployReadyTemplateState') {
      return deserialize<_i11.DeployReadyTemplateState>(data['data']);
    }
    if (dataClassName == 'NewTemplateState') {
      return deserialize<_i11.NewTemplateState>(data['data']);
    }
    if (dataClassName == 'TemplateEssential') {
      return deserialize<_i12.TemplateEssential>(data['data']);
    }
    if (dataClassName == 'PdfContent') {
      return deserialize<_i13.PdfContent>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i14.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i15.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i15.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i15.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i15.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i15.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i15.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i15.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i15.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateBaseline') {
      return deserialize<_i16.ShoebillTemplateBaseline>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateBaselineImplementation') {
      return deserialize<_i17.ShoebillTemplateBaselineImplementation>(
        data['data'],
      );
    }
    if (dataClassName == 'ShoebillTemplateScaffold') {
      return deserialize<_i18.ShoebillTemplateScaffold>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersion') {
      return deserialize<_i19.ShoebillTemplateVersion>(data['data']);
    }
    if (dataClassName == 'ShoebillTemplateVersionInput') {
      return deserialize<_i20.ShoebillTemplateVersionInput>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i21.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AiThinkingChunk') {
      return deserialize<_i22.AiThinkingChunk>(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i23.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguage') {
      return deserialize<_i24.SupportedLanguage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i25.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i13.PdfContent:
        return _i13.PdfContent.t;
      case _i14.SchemaDefinition:
        return _i14.SchemaDefinition.t;
      case _i16.ShoebillTemplateBaseline:
        return _i16.ShoebillTemplateBaseline.t;
      case _i17.ShoebillTemplateBaselineImplementation:
        return _i17.ShoebillTemplateBaselineImplementation.t;
      case _i18.ShoebillTemplateScaffold:
        return _i18.ShoebillTemplateScaffold.t;
      case _i19.ShoebillTemplateVersion:
        return _i19.ShoebillTemplateVersion.t;
      case _i20.ShoebillTemplateVersionInput:
        return _i20.ShoebillTemplateVersionInput.t;
      case _i21.AccountInfo:
        return _i21.AccountInfo.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'shoebill_template';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
