# Blocs
Blocs manage the state of a domain in an application.
A domain can be anything from a single widget/component to entire app/web pages.
Blocs can also be used to perform operations like network calls and state persistence without directly manipulating the applications state.
Bloc output Observables (from Fields) will also emit the last emitted value to every new listener that is added.
This means views do not have to wait for a value to be updated (or supply a default value) to display correct information.


Each "type" of Bloc has two classes, an abstract interface class, and an abstract implementation class. 

## Interface Classes
Bloc interface classes define the publicly accessable interface for a  Bloc class.
This is done to allow for attribute/method access from subclasses outside of the defining library while limiting access from classes not inheriting from the class.
This class should define any attributes that should be publicly accessible such as FieldViews.
Interface classes are not required but are recommended.

## Implementation Classes
The implementation classes contain the actual implementation of the Bloc.
All Bloc implementation classes should have an Impl postfix. For example Bloc's implementation class is BlocImpl.

## Types
There are 3 "types" of Blocs in the bloc_flux package, Bloc, ValueBloc and StateBloc each with extra case specific functionality.

#### [Bloc][bloc_api] and [BlocImpl][bloc_impl_api]
The Bloc classes represent the most basic possible Bloc with no functionality other than the actionObservable input, a map of all registered Fields and a implemented dispose method.

#### [ValueBloc][value_bloc_api] and [ValueBlocImpl][value_bloc_impl_api]
The ValueBloc classes contain all of the functionality of the Bloc classes plus an output Observable for easy dispatching of Actions from within the ValueBloc.
ValueBlocs can also handle FieldQueries which allows other Blocs to request the current value of a Field or all future values of a Field.

#### [StateBloc][state_bloc_api] and [StateBlocImpl][state_bloc_impl_api]
The StateBloc classes contain all of the functionality of the ValueBloc classes plus whole Bloc states (contained within a [StateBlocState][state_bloc_state_api]).
Anytime the value of a registered [StateField][state_field_api] changes a new StateBlocState is created and dispatched if dispatchState is true.

[bloc_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Bloc-class.html
[bloc_impl_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BlocImpl-class.html
[value_bloc_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/ValueBloc-class.html
[value_bloc_impl_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/ValueBlocImpl-class.html
[state_bloc_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/StateBloc-class.html
[state_bloc_impl_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/StateBlocImpl-class.html

[state_bloc_state_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/StateBlocState-class.html
[state_field_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/StateField-class.html