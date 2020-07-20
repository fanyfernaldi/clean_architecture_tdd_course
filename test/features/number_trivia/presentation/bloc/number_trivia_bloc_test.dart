import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecases.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia, 
      random: mockGetRandomNumberTrivia, 
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = 1;
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    //refactoring our code (karena ini digunakan di beberapa test)
    void setUpMockInputConverterSuccess() => 
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      ()async {
        // arange
        setUpMockInputConverterSuccess();
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        //we await untilCalled() because the logic inside a BLoC is triggered through a Stream<Event>
        //which is, of course, asynchronous itself. Had we not awaited until the stringToUnsignedInteger
        //has been called, the verification would always fail, since we'd verify before the code had a 
        //chance to execute
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      }
    );

    test(
      'should emit [Error] when the input is invalid',
      ()async {
        // arange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          // The initial state (kondisi awal) is always emitted(dipancarkan) first, initial state
          // ada di parameter pertama, kalo disini berarti si Empty()
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected)); 
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      }
    );

    test(
      'should get data from the concrete use case',
      ()async {
        // arange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      }
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      }
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      ()async {
        // arange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));        
      }
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      ()async {
        // arange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));        
      }
    );

  });

  group('GetTriviaForRandomNumber', () {
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the ranom use case',
      ()async {
        // arange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      }
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      }
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      ()async {
        // arange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());        
      }
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      ()async {
        // arange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());  
      }
    );
    
  });
}