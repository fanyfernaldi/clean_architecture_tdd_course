import 'dart:convert';

import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  //this property will be use inside all of the test in this file
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      //all we wanna checks here is expect the tNumberTriviaModel, to be a Type a.. so its should be a NumberTrivia
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    }
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      ()async {
        //arange
        //we want to get the fixtures to simulates the json and converted to a Map<String, dynamic>
        final Map<String, dynamic> jsonMap = 
            //json file converted to a String using fixture_reader and then converted to Map<String, dynamic> using json.decode
            json.decode(fixture('trivia.json'));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        //we want to expect that the result is the same as tNumberTriviaModel
        // expect(result, equals(tNumberTriviaModel));  //sama saja seperti yang dibwah
        expect(result, tNumberTriviaModel);
      }
    );
    
    test(
      'should return a valid model when the JSON number is regarded as a double',
      ()async {
        //arange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, tNumberTriviaModel);
      }
    );
  });

  group('toJson', (){
    test(
      'should return a JSON map conaining the proper data',
      ()async {
        // arrange
        //we will not have anything in arrange because there is nothing to arrange, or we could say that we have
        //already arrange something because we already have tNumberTriviaModel variabel on top

        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        //now lets assert(menegaskan) that the result is expected to be a Map
        expect(result, expectedMap);
      }
    );
  });

}