# Blocs
Blocs manage the state of a domain in an application.
A domain can be anything from a single widget/component to entire app/web pages.
Blocs can also be used to perform operations like network calls and state persistence without directly manipulating the applications state.
Bloc output Observables (from Fields) will also emit the last emitted value to every new listener that is added.
This means views do not have to wait for a value to be updated (or supply a default value) to display correct information.


Each "type" of Bloc has two classes, an abstract interface class, and an abstract implementation class. 
Inter