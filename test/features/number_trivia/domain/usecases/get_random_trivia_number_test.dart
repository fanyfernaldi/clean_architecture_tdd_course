import 'package:clean_architecture_tdd_course/core/usecases/usecases.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

// all of the test run inside this main method
void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  //setup method runs before every single test
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repository',  //this test should get trivia from the repository (we have already the repository instance, yaitu mockNumberTriviaRepository)
    () async {
      // arrange 
      when(mockNumberTriviaRepository.getRandomNumberTrivia()) 
          .thenAnswer((_) async => Right(tNumberTrivia)); //.thenAnswer ya bukan then return, karena ini pakai async. Kita bebas pake Left atau Right, karena ini testing
      // act  
      //final result = await usecase.call(number: tNumber);  //cara 1
      final result = await usecase(NoParams());  //cara 2, karena dart support sesuatu yang bernama callable class
      // assert  
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    }
  );
}
