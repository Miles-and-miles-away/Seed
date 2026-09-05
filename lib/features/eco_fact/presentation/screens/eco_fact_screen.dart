import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_list_tile.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Inbox-style screen listing the user's eco-fact mail. Tapping a row
/// opens the detail screen and marks the fact as read.
class EcoFactScreen extends ConsumerWidget {
  const EcoFactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final inboxAsync = ref.watch(ecoFactInboxProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ecoFactInboxTitle)),
      body: inboxAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return _EmptyInbox(message: l10n.ecoFactInboxEmpty);
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _InboxRow(item: items[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }
}

class _InboxRow extends ConsumerWidget {
  const _InboxRow({required this.item});

  final EcoFactInboxItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final state = item.isLocked
        ? MailRowState.locked
        : item.isRead
        ? MailRowState.read
        : MailRowState.unread;

    final name = item.fact.name(locale);
    final subject = item.isLocked
        ? l10n.ecoFactInboxLockedSubject
        : name.isNotEmpty
        ? name
        : l10n.ecoFactTitle;

    return MailListTile(
      subject: subject,
      date: item.date,
      state: state,
      onTap: () => context.push(appRoutes.dailyFactDetail(item.dateKey)),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              size: spacingHuge,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: spacingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
