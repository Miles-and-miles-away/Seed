import 'package:seed_app/core/constants/app_constants.dart';

/// Whether [option] indexes one of the comparison columns.
bool isValidOption(int option) => option >= 0 && option < optionCount;

/// [state] with [option]'s list replaced by an unmodifiable copy of
/// [items]; the other columns are carried over untouched.
List<List<T>> withOption<T>(List<List<T>> state, int option, List<T> items) =>
    List.unmodifiable([
      for (var i = 0; i < optionCount; i++)
        if (i == option) List<T>.unmodifiable(items) else state[i],
    ]);
