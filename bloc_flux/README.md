A reactive flux-like state management library using the BLoC pattern.

## Overview
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




## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/BrennanGambling/bloc_flux/issues
[general_architecture_img]: https://github.com/BrennanGambling/bloc_flux/blob/master/bloc_flux/doc/images/main/bloc_flux_architecture.png?raw=true