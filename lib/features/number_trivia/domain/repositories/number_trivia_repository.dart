import 'package:dartz/dartz.dart';  

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number); //Either didapat dari dartz.dart
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia(); //Either Failure or NumberTrivia
}