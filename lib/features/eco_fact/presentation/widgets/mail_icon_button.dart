import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';

/// AppBar action button that navigates to the daily eco-fact.
/// Shows a red dot badge when today's fact is unread.
class MailIconButton extends ConsumerWidget {
  const MailIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(hasUnreadFactProvider);

    return IconButton(
      onPressed: () => context.push(appRoutes.dailyFact),
      icon: Badge(
        isLabelVisible: hasUnread,
        smallSize: 10,
        child: const Icon(Icons.mail_outline),
      ),
    );
  }
}
