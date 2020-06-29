import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';

//getLastNumberTrivia() always return NumberTriviaModel because even the local case will operate with json, 
//because we are going to store a json string inside shared preferences in later part
abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  //basicly its just void but its operate with Future so that you can await until it has completely run
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}