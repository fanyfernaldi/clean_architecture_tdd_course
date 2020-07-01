import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

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

//Refactoring setelah test berhasil dijalankan (setelah green face)
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  //create an instance of SharedPreferences
  final SharedPreferences sharedPreferences;

  //create constructor
  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  //calling this getLastNumberTrivia method, should return NumberTriviaModel, off course only
  //given that it has been previouse the cached, if it was not cached (for example if the user open
  //the app for the first time) we are going to throw exception.
  //What are we going to store and then later on also retrieve NumberTriviaModel inside 
  //sharedPreferences? Well, we cannot just store a class inside sharedPreferences just like that,
  //we have to first convert it to json. And good thing is that we already have a tested 
  //implementation of toJson and fromJson method on the NumberTriviaModel. Because we are using that
  //we're gonna be using it also when we get data from the remote API, we are going to also convert
  //from Json, and we are going to do the same thing when we get the data from the sharedPreferences
  //where its also going be stored as json.
  //So now we have to have a way to test with some json, because we have to test that calling
  //getLastNumbertTrivia will really convert the jsonString present inside sharedPreferences into
  //our beautiful NumberTriviaModel
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    //we are going to get jsonString from the sharedPreferences
    //we should get the same String as we have specified inside the test
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      //the way we can convert a value to a Future is by returning Future.value
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    //if there is nothing inside the sharedPreferences which case, in we will trhow a CacheException
    //this will usually happen when the user first log used the app in which case the sharedPreferences
    //will simply return null when we try to get a String from it
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    //key of cached is: CACHED_NUMBER_TRIVIA. And the value is json.encode(triviaToCache.toJson()
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}