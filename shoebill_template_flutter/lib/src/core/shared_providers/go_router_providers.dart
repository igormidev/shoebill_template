import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoebill_template_flutter/src/core/utils/talker.dart';
import 'package:shoebill_template_flutter/src/features/chat/chat_screen.dart';
import 'package:shoebill_template_flutter/src/features/landing_page/landing_page_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Route paths for the application.
abstract class AppRoutes {
  /// Landing page route - the initial screen where users upload JSON
  static const String landing = '/';

  /// Chat screen route with session ID parameter
  /// Use [chatPath] to generate the full path with a session ID
  static const String chat = '/chat/:sessionId';

  /// Generates the chat path with the given session ID
  static String chatPath(String sessionId) => '/chat/$sessionId';
}

/// Notifier for managing GoRouter configuration.
class RouterNotifier extends Notifier<GoRouter> {
  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      observers: <NavigatorObserver>[
        if (kDebugMode) TalkerRouteObserver(talker),
      ],
      initialLocation: AppRoutes.landing,
      routes: [
        // Landing page - initial route where users upload JSON
        GoRoute(
          path: AppRoutes.landing,
          name: 'landing',
          builder: (context, state) => const LandingPageScreen(),
        ),
        // Chat screen - with session ID parameter for deep linking
        GoRoute(
          path: AppRoutes.chat,
          name: 'chat',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId'];
            if (sessionId == null || sessionId.isEmpty) {
              // Invalid session ID, redirect to landing
              return const LandingPageScreen();
            }
            return ChatScreen(
              sessionId: sessionId,
              onBack: () => context.go(AppRoutes.landing),
            );
          },
        ),
      ],
      // Handle unknown routes by redirecting to landing page
      errorBuilder: (context, state) => const LandingPageScreen(),
    );
  }
}

final routerProvider = NotifierProvider<RouterNotifier, GoRouter>(
  RouterNotifier.new,
);
