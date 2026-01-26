import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:synchronized/synchronized.dart';

Future<void> handleBabelException(
  BuildContext context,
  ShoebillException? exception, {
  FutureOr<void> Function()? onDismisseed,
}) async {
  await errorDialogLock.synchronized(() async {
    await adaptive_dialog.showOkAlertDialog(
      context: context,
      title: (exception ?? defaultException).title,
      message: (exception ?? defaultException).description,
      barrierDismissible: false,
    );
    await onDismisseed?.call();
  });
}

final errorDialogLock = Lock();

final ShoebillException defaultException = ShoebillException(
  title: 'Error',
  description: 'An unknown error occurred.',
);

final ShoebillException connectionClosedException = ShoebillException(
  title: 'Connection Lost',
  description:
      'The connection to the server was lost. Please refresh the page and try again.',
);

Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String description,
}) async {
  await adaptive_dialog.showOkAlertDialog(
    context: context,
    title: title,
    message: description,
    barrierDismissible: false,
  );
}
