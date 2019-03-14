import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../action/actions.dart';
import '../field/field_id.dart';

//TODO: when source generation is added generate interfaces for blocs with just
//the added fields and key visible. maybe for annotated members only

///[Bloc] interface. Extend this class to create an interface for a [BlocImpl].
///
///See [BlocImpl] for more information.
///{@category Blocs}
abstract class Bloc {
  //TODO: this should probably be removed as it should not be needed outside of a Bloc.
  ///{@macro bloc_action_observable_getter}
  @protected
  Observable<Action> get actionObservable;

  ///{@macro bloc_closed_getter}
  bool get closed;

  ///{@macro field_ids_getter}
  Iterable<FieldID> get fieldIDs;

  ///{@macro bloc_key_getter}
  String get key;

  ///Dispose of all resources.
  ///
  ///{@macro closed_state_error}
  void dispose();
}
