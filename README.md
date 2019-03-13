A reactive flux-like state management library using the BLoC pattern.

# Overview
The goal of the bloc_flux package is to take the best parts of the Flux and BLoC state management patterns.

![General Architecture][general_architecture_img]

The general architecture of a bloc_flux application is similar to that of a Flux application. 
A bloc_flux application consists of a single Dispatcher that dispatches Actions to all registered Blocs. 
All data flows from component to component in [Observables][observable_api].
Observables (from [RxDart][rxdart_api]) are like streams with more built in features for stream transformations and are by default **synchronous** whereas most stream implementations are **asynchronous**.
The only input and output to the Dispatcher occur in the form of Actions. 
The Blocs then receive any dispatched Actions from the Dispatchers actionObservable. 
The Blocs do not receive input from anywhere else. 
Blocs then update their state in response to the Action. 
Any changed values will be added to an output Observable. 
Views listen to the output observables on the Blocs and rebuild whenever a new value is available. 
The output observable also emits the last emitted value to every new listener so default init values do not have to be specified.

#### Observables/Streams
* **A. Output Observable:** [actionObservable][actionObservable_api] is the observable that emits all Actions dispatched to the Dispatcher.
The Blocs listen to this Observable as their only form of input.
* **B. Data Observables:** output Observables from Blocs containing the data used by things like UI components/views.
Views listen to these observables and redraw/update when a new value is emitted.
Bloc output Observables will also emit the last emitted value to every new listener that is added.
This means views do not have to wait for a value to be updated to display correct information.
* **C. Action Input:** The only input to the Dispatcher.
Actions are dispatched to the Dispatcher by calling the [dispatch][dispatch_api] method or by adding an input Observable by calling the [addInputObservable][addInputObservable_api]

## Glossary
[**Actions**][action_api] are the only form of input to the Blocs (via the Dispatcher).
Actions represent a single event happening in the application.
These can be anything from a UI event like a button click to asynchronous network responses.

[**Blocs**][bloc_api] manage the state of a domain of the application.
The domain can be anything from a single widget/component to entire app/web pages.
Blocs can also be used to perform IO operations like networks calls and state persistence.
This is the equivalent to a flux or redux store.

[**Dispatchers**][dispatcher_api] are the central hub that all data flows through.
Data can be dispatched to a Dispatcher by calling the dispatch(Action action) method.
All data is wrapped in an Action. 
The dispatcher will then dispatch the Action to all registered Blocs. 
The dispatcher allows for easy logging and debugging as any events affecting the state of the application will flow through the Dispatcher and can be logged.

[**Fields**][field_api] represent a single output from a Bloc. 
They allow access to an observable (stream) and the last value that was emitted from the observable. 
Most Blocs will contain multiple fields.

## Main Advantages
The main goal of bloc_flux is to combine the reusability and compartmentalization of the BLoC pattern and the centralization of the Flux pattern.

* **Compartmentalized:** every domain in an application will have its own Bloc. 
This allows for domain specific functionality to be localized into one component. 
The outputs from each Bloc are also compartmentalized as each output should consist of one “unit” of information. 
With most other state management patterns and packages the output consists of one entire state. 
This makes efficiently redrawing UI components difficult as a new state does not necessarily mean the specific information the UI component cares about has changed.
* **Encapsulated:** Blocs only provide one source of input (the actionObservable) and an output for each of the relevant data fields. 
Blocs cannot be manipulated from anything other than input actions.
* **Testable:** having business logic compartmentalized makes unit and component testing significantly easier. 
Simulating test scenarios also become easier due to Actions. 
A good example of this is a network response. 
Because Blocs only have one input they cannot rely on other components with potentially complex APIs. 
This reduces the number of mock objects needed when writing tests.
* **Debuggable:** the centrality of the Dispatcher makes finding what Action caused an error easier. 
When the Action that caused an error if found it narrows down the number of components that could possibly be causing the issue as most Actions usually only affect the state of one Bloc. 
The compartmentalization of Blocs also prevents manipulation of state from anywhere outside the Bloc making errors less likely to occur and when they do easier to find.
* **Portable:** Blocs can be reused across different projects and platforms as they by definition do not rely on any external output other than the Action input stream.

# Counter Example
![Counter Architecture][counter_architecture_img]

This diagram represents that state management architecture of a simple counting app that has 3 main functions:
1. Displays current count in **Counter Display**.
2. Increments the counter when the **Increment Button** is clicked.
3. Persists the count to local (or server) storage.

In bloc_flux all data flow is through Observables (streams). 
In the above diagram every arrow represents a stream. 
An action stream is a stream which only ever emits Actions. 
A data stream stream refers to any stream not containing exclusively Actions. 
This can be any data from primitives to complex objects. 

#### Observables/Streams
* **A.** The [actionObservable][actionObservable_api] from the Dispatcher. 
This is the observable that all Blocs receive their Action inputs from.
* **B.** A data output observable from the **Counter Bloc** that emits the new count whenever it is updated. 
**Counter View** listens to this observable and redraws/updates itself whenever a new count is emitted.
* **C.** The input stream for the Dispatcher. 
Actions can be added to the input stream from anywhere in an the application. 
The most common type of input would be UI events (like button clicks)but other Blocs can also add Actions to the input stream. 
This can be done by calling the [dispatch][dispatch_api] method or by adding an Observable using the [addInputObservable][addInputObservable_api] method.
* **D.** Action output from Blocs. 
Blocs can also dispatch Actions in response to other Actions. 
The [ValueBloc][value_bloc_api] extends Bloc class allows for easy dispatching of Actions and automatic dispatching of [FieldValueActions][field_value_action_api] when Field values are updated. 
A FieldValueAction is an Action with a non null [FieldID][field_id_api] identifying the Field the value came from and a non null [data][field_value_action_data_api] field with the new value.

#### Components
* **Increment Button:** This button *dispatches* an Action when it is clicked, telling the **Counter Bloc** to increment the counter.
* **Counter Display:** Displays the current count. 
The display will listen to the count output Observable on the **Counter Bloc** and will rebuild whenever a new count is avaliable.
* **Counter Bloc:** This Bloc is responsible for managing the state of the counter function. 
All Blocs recieve all Actions dispatched to the Dispatcher but will only mutate its state it response to some of them. 
In the case of the Counter Bloc these Actions are IncrementAction (increment the count by 1), and SetCountAction (set the count). 
These Actions will be implemented in the example code. 
The Counter Bloc will have a counter Observable that emitts a new count whenever it is updated.
The count wrapped in a FieldValueAction will also be dispatched after the **Persistence Bloc** requests updates using a [FieldQuery][field_query_api].
* **Persistence Bloc:** This Bloc is responsible for presisting the count (the state of the Counter Bloc) to local storage.
For this example this will be simulated to allow the code to be run on any platform.
The Persistence Bloc recieves the updated counts by dispatching a FieldQueryAction wrapping a FieldQuery.
It is important that the Bloc does not directly listen to the count Observable as this defeats the purpose of having a central Dispatcher.
* **Dispatcher:** The dispatcher has actions *dispatched* to it. 
The Actions are than sent to the Blocs. 
In this example the **Increment Button** dispatches an Action to the Dispatcher. 
The Action will be forwarded to the registered Blocs. 
In most cases the default Dispatcher has enough functionality and is already implemented.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BrennanGambling/bloc_flux/issues

[rxdart_api]: https://pub.dartlang.org/documentation/rxdart/latest/
[observable_api]: https://pub.dartlang.org/documentation/rxdart/latest/rx/Observable-class.html

[general_architecture_img]: https://github.com/BrennanGambling/bloc_flux/blob/master/bloc_flux/doc/images/main/bloc_flux_architecture.png?raw=true
[counter_architecture_img]: https://github.com/BrennanGambling/bloc_flux/blob/master/bloc_flux/doc/images/main/counter_example_architecture.png?raw=true

[action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Action-class.html
[bloc_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Bloc-class.html
[dispatcher_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Dispatcher-class.html
[field_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Field-class.html

[actionObservable_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BaseDispatcher/actionObservable.html
[dispatch_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BaseDispatcher/dispatch.html
[addInputObservable_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/BaseDispatcher/addInputObservable.html
[value_bloc_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/ValueBloc-class.html
[field_value_action_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/FieldValueAction-class.html
[field_value_action_data_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/Action/data.html
[field_id_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/FieldID-class.html
[field_query_api]: https://pub.dartlang.org/documentation/bloc_flux/latest/bloc_flux/FieldQuery-class.html