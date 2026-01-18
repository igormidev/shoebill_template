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
import 'api/chat_session_related/messages/chat_actor.dart' as _i5;
import 'api/chat_session_related/messages/chat_message.dart' as _i6;
import 'api/chat_session_related/messages/chat_ui_style.dart' as _i7;
import 'api/pdf_related/entities/pdf_content.dart' as _i8;
import 'api/pdf_related/entities/pdf_declaration.dart' as _i9;
import 'api/pdf_related/entities/pdf_implementation_payload.dart' as _i10;
import 'api/pdf_related/entities/schema_definition.dart' as _i11;
import 'api/pdf_related/entities/schemas_implementations/schema_property.dart'
    as _i12;
import 'entities/others/shoebill_exception.dart' as _i13;
import 'entities/others/supported_languages.dart' as _i14;
import 'entities/template/shoebill_template.dart' as _i15;
import 'greetings/greeting.dart' as _i16;
export 'api/chat_session_related/messages/chat_actor.dart';
export 'api/chat_session_related/messages/chat_message.dart';
export 'api/chat_session_related/messages/chat_ui_style.dart';
export 'api/pdf_related/entities/pdf_content.dart';
export 'api/pdf_related/entities/pdf_declaration.dart';
export 'api/pdf_related/entities/pdf_implementation_payload.dart';
export 'api/pdf_related/entities/schema_definition.dart';
export 'api/pdf_related/entities/schemas_implementations/schema_property.dart';
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
      name: 'pdf_declarations',
      dartName: 'PdfDeclaration',
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
          name: 'schemaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'referenceLanguage',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SupportedLanguages',
        ),
        _i2.ColumnDefinition(
          name: 'referencePdfContentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'pythonGeneratorScript',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'pdf_declarations_fk_0',
          columns: ['schemaId'],
          referenceTable: 'schema_definitions',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'pdf_declarations_fk_1',
          columns: ['referencePdfContentId'],
          referenceTable: 'pdf_content',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pdf_declarations_pkey',
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
      name: 'pdf_implementation_payload',
      dartName: 'PdfImplementationPayload',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'pdf_implementation_payload_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stringifiedJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'language',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SupportedLanguages',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'pdfDeclarationId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'pdf_implementation_payload_fk_0',
          columns: ['pdfDeclarationId'],
          referenceTable: 'pdf_declarations',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pdf_implementation_payload_pkey',
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
      name: 'template_pdf',
      dartName: 'TemplatePdf',
      schema: 'public',
      module: 'shoebill_template',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
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
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'pythonGeneratorScript',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'template_pdf_pkey',
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

    if (t == _i5.ChatActor) {
      return _i5.ChatActor.fromJson(data) as T;
    }
    if (t == _i6.ChatMessage) {
      return _i6.ChatMessage.fromJson(data) as T;
    }
    if (t == _i7.ChatUIStyle) {
      return _i7.ChatUIStyle.fromJson(data) as T;
    }
    if (t == _i8.PdfContent) {
      return _i8.PdfContent.fromJson(data) as T;
    }
    if (t == _i9.PdfDeclaration) {
      return _i9.PdfDeclaration.fromJson(data) as T;
    }
    if (t == _i10.PdfImplementationPayload) {
      return _i10.PdfImplementationPayload.fromJson(data) as T;
    }
    if (t == _i11.SchemaDefinition) {
      return _i11.SchemaDefinition.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyArray) {
      return _i12.SchemaPropertyArray.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyBoolean) {
      return _i12.SchemaPropertyBoolean.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyDouble) {
      return _i12.SchemaPropertyDouble.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyEnum) {
      return _i12.SchemaPropertyEnum.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyInteger) {
      return _i12.SchemaPropertyInteger.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyObjectWithUndefinedProperties) {
      return _i12.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
          as T;
    }
    if (t == _i12.SchemaPropertyString) {
      return _i12.SchemaPropertyString.fromJson(data) as T;
    }
    if (t == _i12.SchemaPropertyStructuredObjectWithDefinedProperties) {
      return _i12.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
            data,
          )
          as T;
    }
    if (t == _i13.ShoebillException) {
      return _i13.ShoebillException.fromJson(data) as T;
    }
    if (t == _i14.SupportedLanguages) {
      return _i14.SupportedLanguages.fromJson(data) as T;
    }
    if (t == _i15.TemplatePdf) {
      return _i15.TemplatePdf.fromJson(data) as T;
    }
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ChatActor?>()) {
      return (data != null ? _i5.ChatActor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ChatMessage?>()) {
      return (data != null ? _i6.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatUIStyle?>()) {
      return (data != null ? _i7.ChatUIStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PdfContent?>()) {
      return (data != null ? _i8.PdfContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PdfDeclaration?>()) {
      return (data != null ? _i9.PdfDeclaration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PdfImplementationPayload?>()) {
      return (data != null
              ? _i10.PdfImplementationPayload.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.SchemaDefinition?>()) {
      return (data != null ? _i11.SchemaDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyArray?>()) {
      return (data != null ? _i12.SchemaPropertyArray.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyBoolean?>()) {
      return (data != null ? _i12.SchemaPropertyBoolean.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyDouble?>()) {
      return (data != null ? _i12.SchemaPropertyDouble.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyEnum?>()) {
      return (data != null ? _i12.SchemaPropertyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyInteger?>()) {
      return (data != null ? _i12.SchemaPropertyInteger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyObjectWithUndefinedProperties?>()) {
      return (data != null
              ? _i12.SchemaPropertyObjectWithUndefinedProperties.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.SchemaPropertyString?>()) {
      return (data != null ? _i12.SchemaPropertyString.fromJson(data) : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              _i12.SchemaPropertyStructuredObjectWithDefinedProperties?
            >()) {
      return (data != null
              ? _i12.SchemaPropertyStructuredObjectWithDefinedProperties.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.ShoebillException?>()) {
      return (data != null ? _i13.ShoebillException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.SupportedLanguages?>()) {
      return (data != null ? _i14.SupportedLanguages.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.TemplatePdf?>()) {
      return (data != null ? _i15.TemplatePdf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_i10.PdfImplementationPayload>) {
      return (data as List)
              .map((e) => deserialize<_i10.PdfImplementationPayload>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i10.PdfImplementationPayload>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i10.PdfImplementationPayload>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _i12.SchemaProperty>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i12.SchemaProperty>(v),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
      _i5.ChatActor => 'ChatActor',
      _i6.ChatMessage => 'ChatMessage',
      _i7.ChatUIStyle => 'ChatUIStyle',
      _i8.PdfContent => 'PdfContent',
      _i9.PdfDeclaration => 'PdfDeclaration',
      _i10.PdfImplementationPayload => 'PdfImplementationPayload',
      _i11.SchemaDefinition => 'SchemaDefinition',
      _i12.SchemaPropertyArray => 'SchemaPropertyArray',
      _i12.SchemaPropertyBoolean => 'SchemaPropertyBoolean',
      _i12.SchemaPropertyDouble => 'SchemaPropertyDouble',
      _i12.SchemaPropertyEnum => 'SchemaPropertyEnum',
      _i12.SchemaPropertyInteger => 'SchemaPropertyInteger',
      _i12.SchemaPropertyObjectWithUndefinedProperties =>
        'SchemaPropertyObjectWithUndefinedProperties',
      _i12.SchemaPropertyString => 'SchemaPropertyString',
      _i12.SchemaPropertyStructuredObjectWithDefinedProperties =>
        'SchemaPropertyStructuredObjectWithDefinedProperties',
      _i13.ShoebillException => 'ShoebillException',
      _i14.SupportedLanguages => 'SupportedLanguages',
      _i15.TemplatePdf => 'TemplatePdf',
      _i16.Greeting => 'Greeting',
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
      case _i5.ChatActor():
        return 'ChatActor';
      case _i6.ChatMessage():
        return 'ChatMessage';
      case _i7.ChatUIStyle():
        return 'ChatUIStyle';
      case _i8.PdfContent():
        return 'PdfContent';
      case _i9.PdfDeclaration():
        return 'PdfDeclaration';
      case _i10.PdfImplementationPayload():
        return 'PdfImplementationPayload';
      case _i11.SchemaDefinition():
        return 'SchemaDefinition';
      case _i12.SchemaPropertyArray():
        return 'SchemaPropertyArray';
      case _i12.SchemaPropertyBoolean():
        return 'SchemaPropertyBoolean';
      case _i12.SchemaPropertyDouble():
        return 'SchemaPropertyDouble';
      case _i12.SchemaPropertyEnum():
        return 'SchemaPropertyEnum';
      case _i12.SchemaPropertyInteger():
        return 'SchemaPropertyInteger';
      case _i12.SchemaPropertyObjectWithUndefinedProperties():
        return 'SchemaPropertyObjectWithUndefinedProperties';
      case _i12.SchemaPropertyString():
        return 'SchemaPropertyString';
      case _i12.SchemaPropertyStructuredObjectWithDefinedProperties():
        return 'SchemaPropertyStructuredObjectWithDefinedProperties';
      case _i13.ShoebillException():
        return 'ShoebillException';
      case _i14.SupportedLanguages():
        return 'SupportedLanguages';
      case _i15.TemplatePdf():
        return 'TemplatePdf';
      case _i16.Greeting():
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
    if (dataClassName == 'ChatActor') {
      return deserialize<_i5.ChatActor>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i6.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatUIStyle') {
      return deserialize<_i7.ChatUIStyle>(data['data']);
    }
    if (dataClassName == 'PdfContent') {
      return deserialize<_i8.PdfContent>(data['data']);
    }
    if (dataClassName == 'PdfDeclaration') {
      return deserialize<_i9.PdfDeclaration>(data['data']);
    }
    if (dataClassName == 'PdfImplementationPayload') {
      return deserialize<_i10.PdfImplementationPayload>(data['data']);
    }
    if (dataClassName == 'SchemaDefinition') {
      return deserialize<_i11.SchemaDefinition>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyArray') {
      return deserialize<_i12.SchemaPropertyArray>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyBoolean') {
      return deserialize<_i12.SchemaPropertyBoolean>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyDouble') {
      return deserialize<_i12.SchemaPropertyDouble>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyEnum') {
      return deserialize<_i12.SchemaPropertyEnum>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyInteger') {
      return deserialize<_i12.SchemaPropertyInteger>(data['data']);
    }
    if (dataClassName == 'SchemaPropertyObjectWithUndefinedProperties') {
      return deserialize<_i12.SchemaPropertyObjectWithUndefinedProperties>(
        data['data'],
      );
    }
    if (dataClassName == 'SchemaPropertyString') {
      return deserialize<_i12.SchemaPropertyString>(data['data']);
    }
    if (dataClassName ==
        'SchemaPropertyStructuredObjectWithDefinedProperties') {
      return deserialize<
        _i12.SchemaPropertyStructuredObjectWithDefinedProperties
      >(data['data']);
    }
    if (dataClassName == 'ShoebillException') {
      return deserialize<_i13.ShoebillException>(data['data']);
    }
    if (dataClassName == 'SupportedLanguages') {
      return deserialize<_i14.SupportedLanguages>(data['data']);
    }
    if (dataClassName == 'TemplatePdf') {
      return deserialize<_i15.TemplatePdf>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
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
      case _i8.PdfContent:
        return _i8.PdfContent.t;
      case _i9.PdfDeclaration:
        return _i9.PdfDeclaration.t;
      case _i10.PdfImplementationPayload:
        return _i10.PdfImplementationPayload.t;
      case _i11.SchemaDefinition:
        return _i11.SchemaDefinition.t;
      case _i15.TemplatePdf:
        return _i15.TemplatePdf.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'shoebill_template';
}
