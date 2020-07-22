import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Why stateful? TriviaControls will have a TextField and in order to deliver the inputted String to
//bloc whenever a button is pressed, this widget will need to hold that string as local state.
//In addition to dispatch-ing the GetTriviaForConcreteNumber event when the concrete button is pressed,
//this event will get dispatched also when the TextField is submitted by pressing a button on the keyboard
class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlState createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Input a number',
        ),
        onChanged: (value) {
          inputStr = value;
        },
        onSubmitted: (_) {    //on submit ini biar ketika kita bisa submit lewat keyboard
          dispatchConcrete();
        },
      ),
      SizedBox(height: 10),
      Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text('Search'),
              color: Theme.of(context).accentColor, //memberi warna tombol
              textTheme: ButtonTextTheme.primary, //memberi warna tulisan di tombol jadi putih
              onPressed: dispatchConcrete,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: RaisedButton(
              child: Text('Get random trivia'),
              onPressed: dispatchRandom,
            )
          )
        ],
      )
    ]);
  }

  void dispatchConcrete() {
    controller.clear(); //agar ketika setiap submit button maka value input formnya ngosong lagi
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForRandomNumber());
  }
}