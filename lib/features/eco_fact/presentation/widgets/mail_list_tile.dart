import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

const double _leadingIconSize = 24;
const double _unreadDotSize = 10;

/// Visual state of a mail row.
enum MailRowState { unread, read, locked }

/// Generic one-line mail row. Shared across mail types (eco-fact today,
/// past eco-facts, and future announcements) so they look consistent.
class MailListTile extends StatelessWidget {
  const MailListTile({
    required this.subject,
    required this.date,
    required this.state,
    this.onTap,
    super.key,
  });

  final String subject;
  final DateTime date;
  final MailRowState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();

    final isUnread = state == MailRowState.unread;
    final isLocked = state == MailRowState.locked;

    final iconData = switch (state) {
      MailRowState.unread => Icons.mail,
      MailRowState.read => Icons.drafts_outlined,
      MailRowState.locked => Icons.lock_outline,
    };
    final iconColor = isLocked
        ? colorScheme.onSurface.withValues(alpha: opacityMuted)
        : colorScheme.primary;
    final subjectColor = isLocked
        ? colorScheme.onSurface.withValues(alpha: opacityStrong)
        : colorScheme.onSurface;
    final subjectWeight = isUnread ? FontWeight.w700 : FontWeight.w400;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingMd,
        ),
        child: Row(
          children: [
            Icon(iconData, size: _leadingIconSize, color: iconColor),
            const SizedBox(width: spacingMd),
            Expanded(
              child: Text(
                subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: subjectColor,
                  fontWeight: subjectWeight,
                ),
              ),
            ),
            const SizedBox(width: spacingSm),
            Text(
              DateFormat.MMMd(locale).format(date),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(width: spacingSm),
            SizedBox(
              width: _unreadDotSize,
              height: _unreadDotSize,
              child: isUnread
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
