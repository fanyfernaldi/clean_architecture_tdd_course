import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

//kenapa harus ada model? kan udah ada entities. Jadi.. Domain layer should be completedly independent of any
//outside forces.
//fromJson and toJson functionality should really not go into the domain layer, but instead into the data layer
//and inside the data layer, we are not gonna have an entities, but we are going to have models, which extends entity

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required String text,
    @required int number,
    // pass the property to the super constructor of NumberTrivia entity
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      //json['number'] is dynamic, but this dynamic type will won't to be case into a number field of 
      //NumberTriviaModel which is a type of integer. And whenever such an implisit case happen, dart will first
      //determine the type of the dynamic value because even though its dynamic, in factory we has some underline
      //type, in this case is the double. And whats gonna happen is that an implisit case from double to an int fails
      //so we have to make in explicite case or explicite convertion
      //num data type can be both of integer and also double, thanks dart
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text, 
      'number': number
    };
  }
}
