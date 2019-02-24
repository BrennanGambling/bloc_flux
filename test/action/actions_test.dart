import 'package:bloc_flux/bloc_flux.dart';
import 'package:test/test.dart';

import '../mocks/mock_queries.dart';
import '../mocks/mock_states.dart';

void main() {
  group("actions.dart tests", () {
    const String testData = "Test data";
    const String diffData = "Diff data";
    final Action<String> action = Action(data: testData);
    final Action<String> diffAction = Action(data: diffData);
    test("Action test", () {
      final Action<String> action2 = Action(data: testData);
      final Action<String> nullData = Action();
      final Action<String> nullData2 = Action();
      final Action<dynamic> noGenericType = Action<dynamic>(data: testData);

      expect(action, equals(action2));
      expect(action, isNot(equals(diffAction)));
      expect(action == noGenericType, equals(false));

      expect(nullData, equals(nullData2));

      expect(action.hashCode, equals(action2.hashCode));
      expect(action.hashCode, isNot(equals(diffAction.hashCode)));
      expect(action.hashCode, isNot(equals(noGenericType.hashCode)));

      expect(nullData.hashCode, equals(nullData2.hashCode));
    });
    test("ErrorAction test", () {
      final Error error = Error();
      final ErrorAction<String, Error> errorAction = ErrorAction(action, error);
      final ErrorAction<String, Error> errorAction2 =
          ErrorAction(action, error);
      final ErrorAction<String, Error> diffErrorAction =
          ErrorAction(diffAction, error);
      final ErrorAction<String, Error> nullError = ErrorAction(action, null);

      expect(() => ErrorAction(null, error), throwsA(isArgumentError));
      expect(() => ErrorAction(action, null), returnsNormally);

      expect(errorAction, equals(errorAction2));
      expect(errorAction, isNot(equals(diffErrorAction)));
      expect(errorAction, isNot(equals(nullError)));

      expect(errorAction.action.data, equals(errorAction.data));

      expect(errorAction.hashCode, equals(errorAction2.hashCode));
      expect(errorAction.hashCode, isNot(equals(diffErrorAction.hashCode)));
      expect(errorAction.hashCode, isNot(equals(nullError.hashCode)));
    });
    test("ValueAction test", () {
      final ValueAction<String> valueAction = ValueAction(testData);
      final ValueAction<String> valueAction2 = ValueAction(testData);
      final ValueAction<String> diffValueAction = ValueAction(diffData);

      expect(() => ValueAction(null), throwsA(isArgumentError));

      expect(valueAction, equals(valueAction2));
      expect(valueAction, isNot(equals(diffValueAction)));

      expect(valueAction.hashCode, equals(valueAction2.hashCode));
      expect(valueAction.hashCode, isNot(equals(diffValueAction.hashCode)));
    });
  });

  group("bloc_actions.dart tests", () {
    final StateBlocState stateBlocState = MockStateBlocState.getExampleMock();
    final StateBlocState diffStateBlocState =
        MockStateBlocState.getExampleMock(diff: true);
    test("BlocStateAction test", () {
      final BlocStateAction blocStateAction = BlocStateAction(stateBlocState);
      final BlocStateAction blocStateAction2 = BlocStateAction(stateBlocState);
      final BlocStateAction diffBlocStateAction =
          BlocStateAction(diffStateBlocState);

      expect(() => BlocStateAction(null), throwsA(isArgumentError));

      expect(blocStateAction.blocState, equals(blocStateAction.data));
      expect(
          blocStateAction.blocKey, equals(blocStateAction.blocState.blocKey));

      expect(blocStateAction, equals(blocStateAction2));
      expect(blocStateAction, isNot(equals(diffBlocStateAction)));
    });
    test("BlocStateValueAction test", () {
      final BlocStateValueAction blocStateValueAction =
          BlocStateValueAction(stateBlocState);
      final BlocStateValueAction blocStateValueAction2 =
          BlocStateValueAction(stateBlocState);
      final BlocStateValueAction diffBlocStateValueAction =
          BlocStateValueAction(diffStateBlocState);

      expect(() => BlocStateValueAction(null), throwsA(isArgumentError));

      expect(blocStateValueAction.blocState, equals(blocStateValueAction.data));
      expect(blocStateValueAction.blocKey,
          equals(blocStateValueAction.blocState.blocKey));

      expect(blocStateValueAction, equals(blocStateValueAction2));
      expect(blocStateValueAction, isNot(equals(diffBlocStateValueAction)));
    });
    test("StateQueryAction test", () {
      final StateQuery stateQuery = MockStateQuery.getExampleMock();
      final StateQuery diffStateQuery =
          MockStateQuery.getExampleMock(diff: true);

      final StateQueryAction stateQueryAction = StateQueryAction(stateQuery);
      final StateQueryAction stateQueryAction2 = StateQueryAction(stateQuery);
      final StateQueryAction diffStateQueryAction =
          StateQueryAction(diffStateQuery);

      expect(() => StateQueryAction(null), throwsA(isArgumentError));

      expect(stateQueryAction.stateQuery, equals(stateQueryAction.data));
      expect(stateQueryAction.blocKey,
          equals(stateQueryAction.stateQuery.blocKey));
      expect(
          stateQueryAction.cancel, equals(stateQueryAction.stateQuery.cancel));
      expect(
          stateQueryAction.single, equals(stateQueryAction.stateQuery.single));
      expect(stateQueryAction.subscription,
          equals(stateQueryAction.stateQuery.subscription));

      expect(stateQueryAction, equals(stateQueryAction2));
      expect(stateQueryAction, isNot(equals(diffStateQueryAction)));
    });
  });

  group("field_actions.dart tests", () {
    test("FieldQueryAction test", () {
      //TODO:
    });
    test("FieldValueAction test", () {
      //TODO:
    });
  });
}
