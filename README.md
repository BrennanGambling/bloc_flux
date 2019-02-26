A reactive flux-like state management library using the BLoC pattern.

# Overview
The goal of the bloc_flux package is to take the best parts of the Flux and BLoC state management patterns.

![General Architecture][general_architecture_img]

The general architecture of a bloc_flux application is similar to that of a Flux application. 
A bloc_flux application consists of a single Dispatcher that dispatches Actions to all registered Blocs. 
The only input and output to the Dispatcher occur in the form of Actions. 
The Blocs then receive any dispatched Actions from the Dispatchers actionObservable. 
The Blocs do not receive input from anywhere else. 
Blocs then update their state in response to the Action. 
Any changed values will be added to an output Observable. 
Views listen to the output observables on the Blocs and rebuild whenever a new value is available. 
The output observable also emits the last emitted value to every new listener so default init values do not have to be specified.

#### Observables/Streams
* **A. actionObservable:** the observable that emits all Actions dispatched to the Dispatcher.
The Blocs listen to this Observable as their only form of input.
* **B. Data Observables:** output Observables from Blocs containing the data used by things like UI components/views.
Views listen to these observables and redraw/update when a new value is emitted.
Bloc output Observables will also emit the last emitted value to every new listener that is added.
This means views do not have to wait for a value to be updated to display correct information.
* **C. Action Input:** The only input to the Dispatcher.
Actions are dispatched to the Dispatcher by calling the dispatch(Action action) method or by adding an input Observable by calling the addInputObservable(Observable<Action> inputObservable);

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





## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BrennanGambling/bloc_flux/issues
[general_architecture_img]: https://github.com/BrennanGambling/bloc_flux/blob/master/bloc_flux/doc/images/main/bloc_flux_architecture.png?raw=true
[action_api]: insert_link
[bloc_api]: insert_link
[dispatcher_api]: insert_link
[field_api]: insert_link