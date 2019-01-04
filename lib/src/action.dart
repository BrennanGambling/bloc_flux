import 'package:meta/meta.dart';

///Extend this class to create Actions for your project.
@immutable
abstract class Action<T> {
  ///The Actions payload. If the Action does not require a payload this can be left null.
  final T data;

  Action({this.data});
}
