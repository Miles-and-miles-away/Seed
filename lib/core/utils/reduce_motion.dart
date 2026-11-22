import 'package:flutter/widgets.dart';

/// Whether the platform asks for less motion, under either setting name.
bool reduceMotionOf(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.reduceMotionOf(context);
