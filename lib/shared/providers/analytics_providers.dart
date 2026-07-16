import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/shared/services/analytics_service.dart';

part 'analytics_providers.g.dart';

/// App analytics service. Overridable in tests to avoid touching Firebase.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) => AnalyticsService.instance;

/// Firebase Crashlytics. Overridable in tests to avoid touching Firebase.
@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(Ref ref) => FirebaseCrashlytics.instance;
