import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  //di tutor ngga dikasih ini, tapi aku ngasih ini karena biar ngga error exception saat applikasi di run
  //dan agar screen tidak blank white. Kode ini didapat dari github flutter.
  WidgetsFlutterBinding.ensureInitialized();
  //it's important to await the Future even though it only contains void. We definitely don't want
  //the UI to be built up before any of the dependencies had a chance to be registered
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}