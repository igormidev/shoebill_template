// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get app_title => 'Shoebill Template';

  @override
  String get app_subtitle => 'テンプレートを簡単に作成してデプロイ';

  @override
  String get landing_headline => 'テンプレートを作成';

  @override
  String get landing_subtitle => 'JSONスキーマをアップロードして開始';

  @override
  String get landing_drag_json => 'JSONファイルをここにドラッグ';

  @override
  String get landing_paste_json => 'クリックしてJSONを貼り付け';

  @override
  String get landing_drop_files => 'またはファイルをここにドロップ';

  @override
  String get landing_browse_files => 'ファイルを参照';

  @override
  String get landing_invalid_json => '無効なJSON形式です。ファイルを確認してください。';

  @override
  String get landing_file_uploaded => 'ファイルが正常にアップロードされました';

  @override
  String get schema_review_title => '生成されたスキーマを確認';

  @override
  String get schema_review_instructions =>
      '生成されたスキーマを確認・調整してください。必要に応じて必須フィールドを切り替えてください。';

  @override
  String get schema_field_name => 'フィールド名';

  @override
  String get schema_field_type => 'タイプ';

  @override
  String get schema_field_required => '必須';

  @override
  String get schema_field_description => '説明';

  @override
  String get schema_confirm => '確認';

  @override
  String get schema_edit => 'JSONを編集';

  @override
  String get schema_no_fields => 'スキーマにフィールドが検出されませんでした';

  @override
  String get schema_suggested_prompt => '提案されたプロンプト';

  @override
  String get schema_suggested_prompt_hint => 'このプロンプトはテンプレートの生成に使用されます';

  @override
  String get schema_type_string => '文字列';

  @override
  String get schema_type_integer => '整数';

  @override
  String get schema_type_double => '小数';

  @override
  String get schema_type_boolean => '真偽値';

  @override
  String get schema_type_array => '配列';

  @override
  String get schema_type_object => 'オブジェクト';

  @override
  String get schema_type_enum => '列挙型';

  @override
  String get schema_nullable => 'null許容';

  @override
  String get chat_input_placeholder => 'メッセージを入力...';

  @override
  String get chat_send => '送信';

  @override
  String get chat_deploy => 'デプロイ';

  @override
  String get chat_deploy_template => 'テンプレートをデプロイ';

  @override
  String get chat_back => '戻る';

  @override
  String get chat_back_accessibility => '前の画面に戻る';

  @override
  String get chat_loading => 'リクエストを処理中...';

  @override
  String get chat_thinking => '考え中...';

  @override
  String get chat_error_sending => 'メッセージの送信に失敗しました。再試行してください。';

  @override
  String get chat_connection_error => '接続エラー。インターネット接続を確認してください。';

  @override
  String get chat_success_deployed => 'テンプレートが正常にデプロイされました!';

  @override
  String get chat_retry => '再試行';

  @override
  String get chat_clear_history => 'チャット履歴をクリア';

  @override
  String get chat_clear_confirm => 'チャット履歴をクリアしてもよろしいですか?';

  @override
  String get chat_empty_state => '会話を開始してテンプレートを作成';

  @override
  String chat_message_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のメッセージ',
      one: '1件のメッセージ',
      zero: 'メッセージなし',
    );
    return '$_temp0';
  }

  @override
  String get button_save => '保存';

  @override
  String get button_cancel => 'キャンセル';

  @override
  String get button_delete => '削除';

  @override
  String get button_confirm => '確認';

  @override
  String get button_ok => 'OK';

  @override
  String get button_close => '閉じる';

  @override
  String get button_next => '次へ';

  @override
  String get button_previous => '前へ';

  @override
  String get button_submit => '送信';

  @override
  String get button_reset => 'リセット';

  @override
  String get button_continue => '続行';

  @override
  String get button_done => '完了';

  @override
  String get button_edit => '編集';

  @override
  String get button_copy => 'コピー';

  @override
  String get button_share => '共有';

  @override
  String get loading => '読み込み中...';

  @override
  String get loading_please_wait => 'お待ちください...';

  @override
  String get loading_data => 'データを読み込み中...';

  @override
  String get loading_template => 'テンプレートを読み込み中...';

  @override
  String get refreshing => '更新中...';

  @override
  String get error_generic => 'エラーが発生しました。再試行してください。';

  @override
  String get error_network => 'ネットワークエラー。接続を確認してください。';

  @override
  String get error_timeout => 'リクエストがタイムアウトしました。再試行してください。';

  @override
  String get error_server => 'サーバーエラー。後でもう一度お試しください。';

  @override
  String get error_not_found => 'リクエストされたリソースが見つかりませんでした。';

  @override
  String get error_unauthorized => 'この操作を実行する権限がありません。';

  @override
  String get error_validation => '入力内容を確認して、再試行してください。';

  @override
  String get error_empty_field => 'このフィールドは空にできません';

  @override
  String get error_retry => 'タップして再試行';

  @override
  String get success_saved => '正常に保存されました!';

  @override
  String get success_deleted => '正常に削除されました!';

  @override
  String get success_copied => 'クリップボードにコピーしました!';

  @override
  String get success_updated => '正常に更新されました!';

  @override
  String get dialog_confirm_title => '操作の確認';

  @override
  String get dialog_confirm_message => '続行してもよろしいですか?';

  @override
  String get dialog_delete_title => '項目を削除';

  @override
  String get dialog_delete_message => 'この操作は元に戻せません。よろしいですか?';

  @override
  String get dialog_discard_title => '変更を破棄';

  @override
  String get dialog_discard_message => '保存されていない変更があります。破棄しますか?';

  @override
  String get accessibility_menu => 'メニューを開く';

  @override
  String get accessibility_close => '閉じる';

  @override
  String get accessibility_expand => '展開';

  @override
  String get accessibility_collapse => '折りたたむ';

  @override
  String get accessibility_loading => 'コンテンツを読み込み中';

  @override
  String get accessibility_error => 'エラーが発生しました';
}
