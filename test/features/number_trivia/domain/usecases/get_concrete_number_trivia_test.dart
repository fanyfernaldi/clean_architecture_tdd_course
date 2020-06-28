import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

//writing the test requires a bit of a set up, we know that the usecase should get its data from the number_trivia_repository.dart
//for which we currently have only the contract to the abstract class, because we have only the abstract class
//we are going to mock it so that we can add some functionality to it only for this test, and mocking something also
//allows to check whether or not some method had been called on that object, 
//and overall it really allows for nice testing experience
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

//and now we have to think about how will the usecase which we currently do not even have a file for, and that is
//perfectly fine with Test Driven Development (TDD). How will be usecase operate with the repository?
//well off course its going to get that repository pass in through the constructor, so that later on we can use
//get_it package to do some nice dependency injection, this is calles loose coupling, and loose coupling is 
//absolutely crucial for TDD, because without loose coupling you cannot test anything basicly. 
//And to pass this Mock version of repository into the now not yet existance usecase, we are going to use method
//called setUp() which is available for every test that you write in dart. 
//And the setUp() method runs before every single test

// all of the test run inside this main method
void main() {
  //create the variable in which the object in question will be stored
  GetConcreteNumberTrivia usecase;
  // and then also the mcok NumberTriviaRepository will be stored here,
  //so that we can than later on we get_it and do some mocking on this instance
  MockNumberTriviaRepository mockNumberTriviaRepository;

  //setup method runs before every single test
  setUp((){
    //initialize/instantiate all the object we need
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  // tNumber atau test number 
  final tNumber = 1;
  //this is what is going to be return from the Mock class, we are going to get all of this just a little while
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  
  //strart writing a test
  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange | setup test
      //provide some functionality to the mock instance of the repository
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)) //any maksudnya ketika ..called with any argument / any number 1/2/3/, then..
          .thenAnswer((_) async => Right(tNumberTrivia)); //.thenAnswer ya bukan then return, karena ini pakai async. Kita bebas pake Left atau Right, karena ini testing
      
      // act | execute unit test
      //final result = await usecase.call(number: tNumber);  //cara sebelumnya
      final result = await usecase(Params(number: tNumber));  //cara sekarang (pake / g pake .call sama aja), karena dart support sesuati yang bernama callable class
      
      // assert  | verify test result with expected result
      //what we gonna check for? well, we expect that the result of the call() method on the usecase above will
      //really be the same thing as was just return from the mockNumberTriviaRepository, because the usecase
      //does really simple just get the data from the repository and in the case of numberTriviaApp
      //soo.. therefore we expect the result to be Rigth(tNumberTrivia)
      expect(result, Right(tNumberTrivia));
      //verify using the mockito package
      //we wanna verify that mockNumberTriviaRepository.getConcreteNumberTrivia was called with tNumber
      //if we didnt have this verify here, we wouldn't find out because the mocked repository always returns the same
      //tNumberTrivia. verification is therefore a life-saver
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      //verify no more interactions are happening on the mockNumberTriviaRepository, because once we call .call(), the
      //use case should not do anything more with the repository
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    }
  );
}


// The AAA (Arrange, Act, Assert) pattern is a common way of writing unit tests for a method under test.

// The Arrange section of a unit test method initializes objects and sets the value of the data that is passed to the method under test.
// The Act section invokes the method under test with the arranged parameters.
// The Assert section verifies that the action of the method under test behaves as expected.