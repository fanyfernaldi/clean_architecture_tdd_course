import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

//Create constant for all the messages. There will be one message per distinct(berbeda) Failure
//which can occure inside the NumberTriviaBloc's dependencies.
const String SERVER_FAILURE_MESSAGE = 'Servver Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    // Changed the name of the constructor parameter (cannot use 'this.')
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
    // Asserts are how you can make sure that a passed in argument is not null.
    // We omit(menghilangkan) this elsewhere(ti tempat lain) for the sake(demi) of brevity(keringkasan)
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  //all of the BLoC's logic is executed in the mapEventToState() method. 
  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // Immediately branching the logic with type checking, in order for the event to be smart casted(dicor)
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      //Using its 'fold'(membungkus) method, we simply have to handle both the failure and the success
      //case and unlike with exceptions, there is nos imple way around it.
      //We are using the yield* keyword meaning 'yield each' to be able to practilcally nest(sarang) an 
      //async generator (async*) within another async* method
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        //throwing an UnimplementedError from the Right() case which contains the converted integer
        (integer) => throw UnimplementedError(),
      );
    }
  }
}
