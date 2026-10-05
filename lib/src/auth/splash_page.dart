import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/common.dart';
import 'session_controller.dart';

/// Shown while the stored session is checked, or when that check could not
/// reach the API.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    return Scaffold(
      body: session.hasError && !session.isLoading
          ? MessageView(
              icon: Icons.cloud_off_outlined,
              message: context.coreL10n.splashError,
              actionLabel: context.coreL10n.actionRetry,
              onAction: () => ref.invalidate(sessionControllerProvider),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
