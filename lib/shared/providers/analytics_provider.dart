import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/analytics_service.dart';

part 'analytics_provider.g.dart';

/// Provider for the AnalyticsService singleton.
///
/// This provides access to analytics tracking throughout the app.
@Riverpod(keepAlive: true)
AnalyticsService analytics(Ref ref) {
  return AnalyticsService.instance;
}
