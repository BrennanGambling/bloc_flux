import '../bloc/bloc.dart';
import '../bloc/state_bloc.dart';
import '../bloc/value_bloc.dart';
import 'base_dispatcher.dart';
import 'impl/dispatcher_impl.dart';

//TODO: does dispatcher need to handle field/state queries

//TODO: document all functionality in class doc.

///[Dispatcher] interface.
///
///**IMPLEMENT** this class to create an interface for a [DispatcherImpl].
///This class should **NOT** be extended as it contains a factory constructor.
///
///See [DispatcherImpl] for more information.
abstract class Dispatcher implements BaseDispatcher {
  factory Dispatcher() => DispatcherImpl();

  ///{@template add_bloc}
  ///Registers [bloc] with this [Dispatcher].
  ///
  ///This method is also used for [ValueBloc]s and [StateBloc]s. [bloc] will
  ///be checked to see if it is either of these types.
  ///
  ///If a [Bloc] with the same [Bloc.key] is already registered it will be
  ///replaced with [bloc].
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void addBloc(Bloc bloc);

  ///{@template remove_bloc}
  ///Removes [bloc] from this [Dispatcher].
  ///
  ///If [bloc] is not registered with this [Dispatcher] nothing will happen.
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void removeBloc(Bloc bloc);

  ///{@template remove_bloc_with_key}
  ///Removes the [Bloc] with [Bloc.key] [key].
  ///
  ///If a [Bloc] with [Bloc.key] [key] has not been registered with this
  ///[Dispatcher] nothing will happen.
  ///{@endtemplate}
  ///
  ///{@macro dispatcher_closed}
  void removeBlocWithKey(String key);
}
