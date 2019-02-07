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
