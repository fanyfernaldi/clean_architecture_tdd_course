export 'loading_widget.dart';
export 'message_display.dart';
export 'trivia_display.dart';
export 'trivia_controls.dart';


//The widgets.dart file is something called a barrel file. Since Dart doesn't support 'package imports'
//like kotlin or java do, we have to help ourselves to get rid of a lot of individual imports with barrel
//files. It simply exports all of the other file present inside the folder

//intinya, semua file yang di folder widget ini akan diimport ke pages/number_trivia_page.dart. And then
//its enough to import just the barrel file: import '../widgets/widgets.dart';