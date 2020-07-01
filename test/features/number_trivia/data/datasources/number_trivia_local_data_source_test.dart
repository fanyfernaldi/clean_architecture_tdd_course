import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

//create a class which will be for the Mock SharedPreferences which are going to be dependency
//of local data source
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  //hold the instance of NumberTriviaLocalDataSourceImpl
  NumberTriviaLocalDataSourceImpl dataSource;
  //instance of MockSharedPreferences let just call it mockSharedPreferences
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });


  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      ()async {
        // arange
        //.getString because the NumberTriviaModel are going to be store as jsonString
        //and when a string with any kind of a key is gotten from the mockSharedPreferences
        //we are going to return (not .thenAnswer but .thenReturn because .getString is not 
        //return a Future, its return a String directly) a fixture, and we are going to read
        //the fixture trivia_cached.json
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        //what are we going to check for? 
        //we are going to verify that we've called something on the sharedPreferences.getString
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        //after we've check for that, we also expect that te result equals to tNumberTriviaModel
        //convert it from the trivia_cached.json fixture.
        expect(result, equals(tNumberTriviaModel));
      }
    );

     test(
      'should throw a CacheExeption when there is not a cached value',
      ()async {
        // arange
        when(mockSharedPreferences.getString(any))
            .thenReturn(null);
        // act
        //we are going to store the method actually inside variabel call. So this call is in fact
        //reference to a function which return a Future<NumberTriviaModel>(coba aja di hover callnya)
        final call =  dataSource.getLastNumberTrivia;
        // assert
        //
        //expect(() => data.getLastNumberTrivia(), throwsA(TypeMatcher<CacheException>())); //cara 1
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));                       //cara2
      }
    );
  });

  group('cachedNumberTrivia', (){
    //its will be equal to NumberTriviaModel, but this time its not going to be fromJson, its not 
    //gonna get converted from fixtre, but instead we are just going to created our self (number: 1,
    //text: 'test trivia')
    //we can also create it from json fixture as we are doing in the previous test above, but 
    //there will not be the case with the actual implementation, because the implementation of 
    //cached NumberTrivia will getting already converted instance of the Model 
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      ()async {
        // arange
        //not used because we really cannot test in the sharedPreferences contain something
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        //key of cached is: CACHED_NUMBER_TRIVIA. And the value is expectedJsonString
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      }
    );
  });

}
