import 'dart:io';

//we are'nt going to test with the json string gotten from the live API, instead we are gonna create a fixture,
//which is a regular json file used for testing. Thats because we want to have a predictable json string to
//test with. 
//Because think about it, what if the json numbers API is under maintenance, even in such case we still want to
//be able to run our test just fine. Or what if we not have any internet connection under such circumstances
//we still want those test to pass

//the test code cannot work with files (it needs to have String) so we somehow needs to read json file and ouput
//a string 
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();