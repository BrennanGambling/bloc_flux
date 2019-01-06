import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'action.dart';
import 'bloc.dart';

///Extend to create custom Dispatchers.
abstract class BaseDispatcher {
  ///The Stream that ALL blocs receive Actions from.
  Observable<Action> _actionObservable;

  ///Getter for public access to actionObservable.
  Observable<Action> get actionObservable => _actionObservable;

  BaseDispatcher(this._actionObservable);

  ///Call to dispatch an Action to the blocs.
  void dispatch(Action action);

  ///Add a new Stream of Actions to pass on to the blocs.
  void addInputStream(String key, Stream<Action> stream);

  ///Remove a Stream of Action from being passed on to the blocs.
  Stream<Action> removeInputStream(String key);
}

//TODO: add support for Middleware like action stream transformers. Maybe a new stream
//should be created that is not modified by any of the Middleware transformers.
///A basic Singleton implementation of BaseDispatcher.
class Dispatcher extends BaseDispatcher {
  ///Dispatcher Singleton
  static final Dispatcher _dispatcher = Dispatcher._internal(PublishSubject());

  ///factory constructor that returns the Singleton instance of Dispatcher.
  factory Dispatcher() {
    return _dispatcher;
  }

  ///Private constructor for Singleton creation. The subject to use is passed in
  ///to the constructor instead of creating it in the initializer list as doing
  ///so makes it impossible to access the created subject to get its Observable
  ///and pass it to the super constructor.
  Dispatcher._internal(this._subject) : super(_subject.stream) {
    _blocMap = Map();
  }

  ///The Subject managing the actionObservable.
  PublishSubject<Action> _subject;

  ///A map of Bloc keys to BaseBlocs.
  Map<String, BaseBloc> _blocMap;

  ///A map of keys to all of the Action Streams forwarding Actions to this Dispatcher.
  Map<String, Stream<Action>> _streamMap;

  ///The StreamSubscription managing the merged Stream of all of the Streams in
  ///this _streamMap.
  StreamSubscription<Action> _inputStreamSubscription;

  ///All Actions flowing through this Dispatcher will go through this method
  ///including the Actions from the input Streams.
  @override
  void dispatch(Action action) {
    _subject.add(action);
  }

  ///Forwards Actions from all added streams to this Dispatchers dispatch method.
  @override
  void addInputStream(String key, Stream<Action> stream) {
    _streamMap[key] = stream;
    _updateInputStream();
  }

  ///Removes the Stream<Action> associated with the key parameter from the
  ///_streamMap then returns the Stream<Action>.
  ///
  ///If there was not a Stream<Action> associated with the key parameter null
  ///will be returned.
  @override
  Stream<Action> removeInputStream(String key) {
    final Stream<Action> stream = _streamMap.remove(key);
    _updateInputStream();
    return stream;
  }

  ///Updates the merged input stream.
  ///
  /// This should be called after modifying the _streamMap. This method cancels
  /// the current _inputStreamSubscription and then creates a new one with
  /// the updated _streamMap.
  void _updateInputStream() {
    _inputStreamSubscription?.cancel();
    final Stream<Action> inputStream = Observable.merge(_streamMap.values);
    _inputStreamSubscription = inputStream.listen(dispatch);
  }

  ///Register the provided BaseBloc to receive dispatched Actions.
  void addBloc(BaseBloc bloc) {
    _blocMap[bloc.key] = bloc;
    bloc.setActionObservable(_actionObservable);
  }

  ///Registers all of the provided BaseBlocs to receive dispatched Action.
  void addAllBlocs(Iterable<BaseBloc> blocs) {
    blocs.forEach(addBloc);
  }

  ///Removes the BaseBloc associated with the ey parameter from the _blocMap
  ///then returns the BaseBloc.
  ///
  /// If there was not a BaseBloc associated with the key parameter null will
  /// be returned.
  BaseBloc removeBloc(String key) {
    return _blocMap.remove(key);
  }

  ///Gets the BaseBloc associated with the key parameter.
  //This goes against the the Effective Dart style guide (the rule "AVOID
  //starting a method name with get." under the design section) but neither of
  //the suggested alternatives make much sense for this use case. The first
  //suggestion, dropping the get, would mean the method is named bloc(). This is
  //too ambiguous. The second suggestion, using a different verb in the place of
  //get would cause even more confusion. Most other verbs that would make sense
  //in the place of get would imply that this method does something other than
  //just returning the BaseBloc. For example create, download, fetch and calculate
  //all imply other actions.
  BaseBloc getBloc(String key) => _blocMap[key];
}
