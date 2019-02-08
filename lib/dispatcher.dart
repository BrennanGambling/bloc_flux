///All dispatcher classes and global [dispatcher].
///
///This does not include dispatcher impl classes. dispatcher_impl.dart exports
///this library as well as the dispatcher impl classes.
///
///{@template hide_global_dispatcher}
///The global [dispatcher] can be hidden by appending `hide dispatcher` to the
///import statement.
///```dart
///import 'package:bloc_flux/dispatcher.dart' hide dispatcher;
///```
///**OR**
///```dart
///import 'package:bloc_fluc/dispatcher_impl.dart' hide dispatcher;
///```
///**OR**
///```dart
///import 'package:bloc_flux/bloc_flux.dart' hide dispatcher;
///```
///{@endtemplate}
///
///{@macro global_dispatcher}
library dispatcher;

import 'src/dispatcher/dispatcher.dart';

export 'src/dispatcher/base_dispatcher.dart';
export 'src/dispatcher/dispatcher.dart';

///Global Dispatcher.
///
///{@template global_dispatcher}
///[dispatcher] is lazily instantiated so if it is never accessed it will not
///be instantiated.
///{@endtemplate}
final Dispatcher dispatcher = Dispatcher();

///@nodoc
///Map of all [Dispatcher]s created with [getDispatcher].
///
///This is a private variable.
final Map<String, Dispatcher> _dispatcherMap = Map();

///Get a [Dispatcher] with [key] as a unique identifier.
///
///If the [key] has never been used in a call to this method a new [Dispatcher]
///will be created.
///
///If a new [Dispatcher] is required with the same [key] set [overwrite] to true.
///The previous [Dispatcher] created with [key] will be lost.
Dispatcher getDispatcher(String key, {bool overwrite: false}) {
  if (!_dispatcherMap.containsKey(key)) {
    _dispatcherMap[key] = Dispatcher();
  } else {
    if (overwrite) {
      _dispatcherMap[key] = Dispatcher();
    }
  }
  return _dispatcherMap[key];
}