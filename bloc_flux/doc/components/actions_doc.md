# **Actions**
Actions represent an event such as a ui event or network reponse that results in a potential change to the application's state.
All state changes are made by *dispatching* an Action to the Dispatcher. 
The dispatched Action is forwarded to all registered Blocs.
To create an Action extend the Action class.
All classes extending Action should be immutable, that is all fields should be final.
The Action class has a generic type field `T data` field.
Any data related to the event this Action represents can be stored here.

Marker interfaces are also provided to classify Actions into categories based on their usage.
Marker interfaces **should NOT** be extended as they do not provide a constructor that calls the Action super constructor, and therefore the final `data` field cannot be set.

## Action Classes

#### [Action][action_api]
The class that all Actions must implement or extend.

#### [ErrorAction][error_action_api]
A wrapper for Action indicating the event the Action represents can fail.
The ErrorAction also includes a `E error` field for data related to the potential error.

#### [ValueAction][value_action_api]
An Action that has a non null `data` field.
Attempting to instaniate a ValueAction with a null `data` field will result in an `ArgumentError` being thrown.

## Action Marker Interfaces

#### [InternalAction][internal_action_api]
Marker interface indicating an Action was dispatched from another Bloc.

#### [QueryAction][query_action_api]
Marker interface indicating an Action is related to the StateQuery or FieldQuery functionality.

# **Bloc Actions**
Below are the Actions that are directly related to Bloc functionality.

## Bloc Action Classes

#### [BlocStateAction][bloc_state_action_api]
An Action used to set the state of a StateBloc.

#### [BlocStateValueAction][bloc_state_value_action_api]
A ValueAction containing the state of a StateBloc.

#### [StateQueryAction][state_query_action_api]
An Action used to register a StateQuery.

# **Field Actions**
Below are the Actions that are directly related to Field functionality.

## Field Action Classes

#### [FieldQueryAction][field_query_action_api]
An Action used to register a FieldQuery.

#### [FieldValueAction][field_value_action_api]
A ValueAction containing the current data attribute of a Field.

[action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Action-class.html
[error_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/ErrorAction-class.html
[value_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/ValueAction-class.html

[internal_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/InternalAction-class.html
[query_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/QueryAction-class.html


[bloc_state_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BlocStateAction-class.html
[bloc_state_value_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BlocStateValueAction-class.html
[state_query_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/StateQueryAction-class.html


[field_query_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/FieldQueryAction-class.html
[field_value_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/FieldValueAction-class.html