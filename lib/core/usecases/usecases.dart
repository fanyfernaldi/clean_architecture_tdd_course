import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

//because this applies all of the usecases accross all of the features of our app thats why into the core folder

abstract class UseCase<Type, Params>{
  //it won't return NumberTrivia, but it will return Type, because we are in the core folder, we cannot rely that
  //all of the usecases will work with NumberTrivia, we have to let the usecases which implements this base UseCase class
  //specify their own return type.
  Future<Either<Failure, Type>> call(Params params);
}

//kita buat class NoParams karena UseCase pada getRandomTrivia tidak memiliki parameter
//kita extendskan ke Equatable agar 2 instances dari NoParams akan menjadi selalu sama, karena mereka tidak
//mengandung apapun
class NoParams extends Equatable {}