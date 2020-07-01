import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

//we are going a mock for DataConnectionChecker because its going to be pass into the NetWorkInfoImpl
//as we are already use to
class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    //instantiate the MockDataConnectionChecker() to be a new instance of it
    mockDataConnectionChecker = MockDataConnectionChecker();
    //and then pass it over to NetworkInfoImpl instance
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  //this isconnected property should forward the call to DataConnectionChecker.hasConnection
  //all this isConnected would do is basicly nothing because it will just get its value from calling 
  //another single property on another class.
  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      ()async {
        // arange
        final tHasConnectionFuture = Future.value(true);

        //when the mockDataonnectionChecker (which is the dependency of our NetWorkInfoImpl class)
        //hasConnection is called on, its should answer but what should answer with?
        //well the isConnected should forward the call to DataConnectionChecker.hasConnection.
        //So, how can we test if a call is only forwarded? Well .hasConnection is a Future returning
        //function, and this Future contain a bool.. So, would we usually do here is that we would
        //say then answer async, and we will answer with, for example true, just for testing purposes.
        //And this would retrun a new instance of Future which we would in the able to await
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => tHasConnectionFuture);
        // act
        //get the resullt from calling the actual networkInfo.isConnected
        //we not use await on netWorkInfo.isConnected, so the result is no longer(tidak lagi) a boolean
        //because we are not awaiting the Future to complete, the result is now a Future<bool>.
        //And this Future, if the call is trully only forwarded to DataConnectionChecker.hasConnection,
        //the result in Future should be the same as the Future return from the tHasConnectionFuture
        //property. In other words, those 2 Future are really just the same Future, the same object
        //pointing the same location inside the memory
        final result = networkInfo.isConnected;
        // assert
        //verify that actually the mockDataConnectionChecker.hasConnection has been called
        verify(mockDataConnectionChecker.hasConnection);
        //we would expect that the result is true. Because if the isConnected on forworward the call
        //to DataConnectionChecker.hasConnection, when the .hasConnection return true, the result
        //of the .isConnected of our own class should be also true.
        expect(result, tHasConnectionFuture);
      }
    );
  });
}