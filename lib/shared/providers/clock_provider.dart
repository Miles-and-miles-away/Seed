import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wall clock behind every "today" decision; tests pin it to a fixed date.
final clockProvider = Provider<DateTime Function()>((_) => DateTime.now);
