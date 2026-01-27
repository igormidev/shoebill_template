// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get app_title => 'Shoebill Template';

  @override
  String get app_subtitle => 'Crie e implante seus templates com facilidade';

  @override
  String get landing_headline => 'Crie Seu Template';

  @override
  String get landing_subtitle => 'Envie seu esquema JSON para comecar';

  @override
  String get landing_drag_json => 'Arraste seu arquivo JSON aqui';

  @override
  String get landing_paste_json => 'Clique aqui para colar JSON';

  @override
  String get landing_drop_files => 'ou solte arquivos aqui';

  @override
  String get landing_browse_files => 'Procurar arquivos';

  @override
  String get landing_invalid_json =>
      'Formato JSON invalido. Por favor, verifique seu arquivo.';

  @override
  String get landing_file_uploaded => 'Arquivo enviado com sucesso';

  @override
  String get schema_review_title => 'Revisar Esquema Gerado';

  @override
  String get schema_review_instructions =>
      'Revise e ajuste o esquema gerado. Alterne os campos obrigatorios conforme necessario.';

  @override
  String get schema_field_name => 'Nome do Campo';

  @override
  String get schema_field_type => 'Tipo';

  @override
  String get schema_field_required => 'Obrigatorio';

  @override
  String get schema_field_description => 'Descricao';

  @override
  String get schema_confirm => 'Confirmar';

  @override
  String get schema_edit => 'Editar JSON';

  @override
  String get schema_no_fields => 'Nenhum campo detectado no esquema';

  @override
  String get schema_suggested_prompt => 'Prompt Sugerido';

  @override
  String get schema_suggested_prompt_hint =>
      'Este prompt sera usado para gerar o template';

  @override
  String get schema_type_string => 'Texto';

  @override
  String get schema_type_integer => 'Inteiro';

  @override
  String get schema_type_double => 'Decimal';

  @override
  String get schema_type_boolean => 'Booleano';

  @override
  String get schema_type_array => 'Lista';

  @override
  String get schema_type_object => 'Objeto';

  @override
  String get schema_type_enum => 'Enumeracao';

  @override
  String get schema_nullable => 'Anulavel';

  @override
  String get chat_input_placeholder => 'Digite sua mensagem...';

  @override
  String get chat_send => 'Enviar';

  @override
  String get chat_deploy => 'Implantar';

  @override
  String get chat_deploy_template => 'Implantar Template';

  @override
  String get chat_back => 'Voltar';

  @override
  String get chat_back_accessibility => 'Voltar para a tela anterior';

  @override
  String get chat_loading => 'Processando sua solicitacao...';

  @override
  String get chat_thinking => 'Pensando...';

  @override
  String get chat_error_sending =>
      'Falha ao enviar mensagem. Por favor, tente novamente.';

  @override
  String get chat_connection_error =>
      'Erro de conexao. Por favor, verifique sua internet.';

  @override
  String get chat_success_deployed => 'Template implantado com sucesso!';

  @override
  String get chat_retry => 'Tentar novamente';

  @override
  String get chat_clear_history => 'Limpar historico do chat';

  @override
  String get chat_clear_confirm =>
      'Tem certeza que deseja limpar o historico do chat?';

  @override
  String get chat_empty_state =>
      'Inicie uma conversa para construir seu template';

  @override
  String chat_message_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensagens',
      one: '1 mensagem',
      zero: 'Nenhuma mensagem',
    );
    return '$_temp0';
  }

  @override
  String get button_save => 'Salvar';

  @override
  String get button_cancel => 'Cancelar';

  @override
  String get button_delete => 'Excluir';

  @override
  String get button_confirm => 'Confirmar';

  @override
  String get button_ok => 'OK';

  @override
  String get button_close => 'Fechar';

  @override
  String get button_next => 'Proximo';

  @override
  String get button_previous => 'Anterior';

  @override
  String get button_submit => 'Enviar';

  @override
  String get button_reset => 'Redefinir';

  @override
  String get button_continue => 'Continuar';

  @override
  String get button_done => 'Concluido';

  @override
  String get button_edit => 'Editar';

  @override
  String get button_copy => 'Copiar';

  @override
  String get button_share => 'Compartilhar';

  @override
  String get loading => 'Carregando...';

  @override
  String get loading_please_wait => 'Por favor, aguarde...';

  @override
  String get loading_data => 'Carregando dados...';

  @override
  String get loading_template => 'Carregando template...';

  @override
  String get refreshing => 'Atualizando...';

  @override
  String get error_generic => 'Algo deu errado. Por favor, tente novamente.';

  @override
  String get error_network => 'Erro de rede. Por favor, verifique sua conexao.';

  @override
  String get error_timeout =>
      'A solicitacao expirou. Por favor, tente novamente.';

  @override
  String get error_server =>
      'Erro no servidor. Por favor, tente novamente mais tarde.';

  @override
  String get error_not_found => 'O recurso solicitado nao foi encontrado.';

  @override
  String get error_unauthorized =>
      'Voce nao esta autorizado a realizar esta acao.';

  @override
  String get error_validation =>
      'Por favor, verifique sua entrada e tente novamente.';

  @override
  String get error_empty_field => 'Este campo nao pode estar vazio';

  @override
  String get error_retry => 'Toque para tentar novamente';

  @override
  String get success_saved => 'Salvo com sucesso!';

  @override
  String get success_deleted => 'Excluido com sucesso!';

  @override
  String get success_copied => 'Copiado para a area de transferencia!';

  @override
  String get success_updated => 'Atualizado com sucesso!';

  @override
  String get dialog_confirm_title => 'Confirmar Acao';

  @override
  String get dialog_confirm_message => 'Tem certeza que deseja continuar?';

  @override
  String get dialog_delete_title => 'Excluir Item';

  @override
  String get dialog_delete_message =>
      'Esta acao nao pode ser desfeita. Tem certeza?';

  @override
  String get dialog_discard_title => 'Descartar Alteracoes';

  @override
  String get dialog_discard_message =>
      'Voce tem alteracoes nao salvas. Deseja descarta-las?';

  @override
  String get accessibility_menu => 'Abrir menu';

  @override
  String get accessibility_close => 'Fechar';

  @override
  String get accessibility_expand => 'Expandir';

  @override
  String get accessibility_collapse => 'Recolher';

  @override
  String get accessibility_loading => 'Carregando conteudo';

  @override
  String get accessibility_error => 'Ocorreu um erro';
}
