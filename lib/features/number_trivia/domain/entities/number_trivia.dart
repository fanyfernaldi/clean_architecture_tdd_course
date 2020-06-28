import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//jika 2 objek  mengandung data yang sama, will not be equal, unless they are referencing to the same point in memory
//with equatable its completely change, when 2 object contain the same values / the same data, they would be equal
class NumberTrivia extends Equatable {
  // data ini disesuaikan sama json response dari api
  final String text;
  final int number;

  NumberTrivia({
    @required this.text,
    @required this.number,
    // kita pass data tsb ke super konstruktor, karena equatable harus tahu property mana yang sedang terjadi equality/persamaan
    // sehingga kita harus pass menjadi sebuah list
  }) : super([text, number]);  
  
}
