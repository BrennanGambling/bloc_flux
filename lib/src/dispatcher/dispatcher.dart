import '../blocs/bloc.dart';
import '../blocs/state_bloc.dart';
import '../blocs/value_bloc.dart';
import 'base_dispatcher.dart';

//TODO: does dispatcher need to handle field/state queries

//TODO: document all functionality in class doc.

///A standard implementation of [BaseDispatcher].
abstract class Dispatcher implements BaseDispatcher {
  ///{@template add_bloc}
  ///Registers [bloc] with this [Dispatcher].
  ///
  ///This method is also used for [ValueBloc]s and [StateBloc]s. [bloc] will
  ///be checked to see if it is either of these types.
  ///
  ///If a [Bloc] with the same [Bloc.key] is already registered it will be
  ///replaced with [bloc].
  ///{@endtemplate}
  void addBloc(Bloc bloc);

  ///{@template remove_bloc}
  ///Removes [bloc] from this [Dispatcher].
  ///
  ///If [bloc] is not registered with this [Dispatcher] nothing will happen.
  ///{@endtemplate}
  void removeBloc(Bloc bloc);

  ///{@template remove_bloc_with_key}
  ///Removes the [Bloc] with [Bloc.key] [key].
  ///
  ///If a [Bloc] with [Bloc.key] [key] has not been registered with this
  ///[Dispatcher] nothing will happen.
  ///{@endtemplate}
  void removeBlocWithKey(String key);
}
