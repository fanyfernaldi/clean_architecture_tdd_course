import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

//Events are dispatched from the Widgets. The widget into which the user writes a number will be 
//a TextField. A value held inside a TextField is always a String.

//Converting a String to an int directly in the UI or even inside the Event class itself would go 
//against(melawan) what we have been trying to accomplish(menyelesaikan) with Clean Architecture all along - 
//maintainability, readability and testability. Oh, and we would also violate the first SOLID principle 
//of separation of concerns.

//Never put any business or presentation logic into the UI. Flutter apps are especially 
//susceptible(rentan) to this since the UI code is also written in Dart.

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}