import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_flutter/src/core/utils/talker.dart';
import 'package:shoebill_template_flutter/src/states/session/session_providers.dart';
import 'package:shoebill_template_flutter/src/states/session/session_state.dart';
import 'package:talker_flutter/talker_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Notifier for managing GoRouter configuration.
/// Rebuilds router when session state changes to handle authentication redirects.
class RouterNotifier extends Notifier<GoRouter> {
  @override
  GoRouter build() {
    final sessionState = ref.watch(sessionProvider);
    final haveUser = sessionState.maybeMap(
      orElse: () => false,
      logged: (_) => true,
    );
    final isLoading = sessionState.maybeMap(
      orElse: () => false,
      loading: (_) => true,
    );

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      observers: <NavigatorObserver>[
        if (kDebugMode) TalkerRouteObserver(talker),
      ],
      redirect: (context, state) {
        final path = state.uri.path;

        // Don't redirect while session is still loading
        if (isLoading) {
          return null;
        }

        if (path == '/splash') {
          return null;
        }
        if (path.isEmpty || path == '/') {
          return '/splash';
        }

        if (haveUser == false) {
          if (path == '/auth') {
            return null;
          }
        }

        return null;
      },
      // initialLocation: '/scrappable-form',
      initialLocation: '/splash',
      routes: [],
    );
  }
}

final routerProvider = NotifierProvider<RouterNotifier, GoRouter>(
  RouterNotifier.new,
);
