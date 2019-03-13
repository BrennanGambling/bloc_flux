# Actions
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

#### Action
The class that all Actions must implement or extend.

#### ErrorAction
A wrapper for Action indicating the event the Action represents can fail.
The ErrorAction also includes a `E error` field for data related to the potential error.

#### ValueAction
An Action that has a non null `data` field.
Attempting to instaniate a ValueAction with a null `data` field will result in an `ArgumentError` being thrown.

## Action Marker Interfaces

#### InternalAction
Marker interface indicating an Action was dispatched from another Bloc.

#### QueryAction
Marker interface indicating an Action is related to the StateQuery or FieldQuery functionality.

[]