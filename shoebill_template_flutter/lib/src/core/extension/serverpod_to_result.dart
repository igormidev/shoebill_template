import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:shoebill_template_client/shoebill_template_client.dart';
import 'package:shoebill_template_flutter/src/core/utils/talker.dart';
import 'package:shoebill_template_flutter/src/design_system/default_error_snackbar.dart';

extension FutureServerpodToResultExt<T extends Object> on Future<T> {
  AsyncResultDart<T, ShoebillException> get toResult async {
    try {
      return Success(await this);
    } on ShoebillException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(defaultException);
    }
  }
}

extension FutureServerpodToResultVoidExt on Future<void> {
  AsyncResultDart<void, ShoebillException> get toResult async {
    try {
      await this;
      return const Success(Unit);
    } on ShoebillException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(defaultException);
    }
  }
}

extension StreamServerpodToResultExt<T> on Stream<T> {
  Future<void> toResult(
    FutureOr<void> Function(T item) onItemEmitted,
    FutureOr<void> Function(ShoebillException error) onError,
  ) async {
    try {
      await for (final item in this) {
        await onItemEmitted(item);
      }
    } on ShoebillException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      await onError(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      await onError(defaultException);
    }
  }

  Future<void> toRawResult(
    FutureOr<void> Function(Stream<T> item) onStream,
    FutureOr<void> Function(ShoebillException error) onError,
  ) async {
    try {
      await onStream(this);
    } on ShoebillException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      await onError(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      await onError(defaultException);
    }
  }
}

extension StreamServerpodToResultVoidExt on Stream<void> {
  AsyncResultDart<void, ShoebillException> get toResult async {
    try {
      this;
      return const Success(Unit);
    } on ShoebillException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(defaultException);
    }
  }
}
