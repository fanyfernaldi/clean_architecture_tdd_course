import 'package:equatable/equatable.dart';

//ini tidak akan di tes karena ini abstract class
abstract class Failure extends Equatable {
  //penerapan equatable
  Failure([List properties = const<dynamic>[]]) : super(properties);
}