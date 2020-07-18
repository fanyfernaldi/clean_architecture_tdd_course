import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable 
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

//Empty state = no trivia is displayed
class Empty extends NumberTriviaState {}

//Loading state = which the UI react by displaying circular loading indicator
class Loading extends NumberTriviaState {}

//Loaded state = which will actually hold the field because whenever the NumberTrivia is Loaded, it should
//hold the NumberTrivia entity
class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia}) : super([trivia]);
}

//Error state = will be emitted(dipancarkan) from the bloc to the UI whenever some Failure happen. 
//For example, if the user input an InvalidInput (ex: -123 / abc), this InvalidInputFailure will trigger 
//the BLoC to output the error states which containg a String of error message
class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message}) : super([message]);
}