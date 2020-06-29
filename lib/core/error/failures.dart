import 'package:equatable/equatable.dart';

//ini tidak akan di tes karena ini abstract class
abstract class Failure extends Equatable {
  //penerapan equatable
  Failure([List properties = const<dynamic>[]]) : super(properties);
}

// General failures
//using extends, because now when we implemented just without extending, we are going to missing concrete
//implementation of getter Equateable.props. Because we are extending Equatable for simplifying value equality
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}