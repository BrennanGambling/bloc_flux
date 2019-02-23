import 'package:test/test.dart';
import 'package:bloc_flux/bloc_flux.dart';

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
      final ErrorAction<String, Error> errorAction2 = ErrorAction(action, error);
      final ErrorAction<String, Error> diffErrorAction = ErrorAction(diffAction, error);
      final ErrorAction<String, Error> nullError = ErrorAction(action, null);

      expect(() => ErrorAction(null, error), throwsA(isArgumentError));
      expect(() => ErrorAction(action, null), returnsNormally);

      expect(errorAction, equals(errorAction2));
      expect(errorAction, isNot(equals(diffErrorAction)));
      expect(errorAction, isNot(equals(nullError)));

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
      expect(valueAction.hashCode, isNot(equals(diffValueAction)));
    });
  });
}

