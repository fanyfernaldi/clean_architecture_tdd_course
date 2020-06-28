import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  //start writing the implementation of call() method, usecase should always have this method
  @override     //override from UseCase implements
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

//create a dump data holder class, which will be called Params, and this will be the case for all of the usecases.
//And the Params class will hold all of the parameters for the call() methods. So in this case it would hold only
//the integer number
class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}