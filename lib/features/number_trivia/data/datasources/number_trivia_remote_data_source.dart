import '../models/number_trivia_model.dart';

//this will almost identical to the interface of the NumberTriviaRepository. But the different is the return type
//this just only return NumberTriviaModel.
//Its not gonna be dealing with Failures, instead we are going to throw exception as any regular old dart code.
//We are doing this because the remote data source is at the total bundary between our own app code and the 
//undfiendly & unpredictable outside world of third party libraries and API's
abstract class NumberTriviaRemoteDataSource{
  /// Calls the http://numbersapi.com/{number} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}