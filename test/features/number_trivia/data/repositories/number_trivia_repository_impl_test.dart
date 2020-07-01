import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

//we know that the repository should take in all of the class which we have created in this part, there is the
//remote and the local data source and also network info object

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body){
    group('device is online', () {
      //setUp the mockNetworkInfo to always return true,
      //this setUp method only applies to test within this group
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body){
    group('device is offline', () {
      //setUp the mockNetworkInfo to always return false,
      //this setUp method only applies to test within this group
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    //to keep our test managable, we are going to create variable for it
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    //create final tNumberTrivia which will be the entity, its gonna be equal to tNumberTriviaModel because
    //remember that model is only a subclass of the entity. So, we can make it be the entity.
    //now this tNumberTriviaModel will be cache into the entity type
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      ()async {
        // arange
        //we need to tell the mockNetworkInfo, to always return true for its connect
        //kita pake .thenAnswer karena .isConnected meretrun Future
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true );
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        //we want to just verify that the mockNetworkInfo.isConnected has been called
        verify(mockNetworkInfo.isConnected);
      }
    );

    runTestOnline(() {
      //whenever the device is online, the repository should return remote data, when the call
      //to remote data source is successfull
      test(
        //format: should do something, when something
        'should return remote data when the call to remote data source is successful',
        ()async {
          // arange
          //whenever mocktheRemoteDataSource.getConcreteNumberTrivia with any number is called,
          //it doesnt really matter for the mock with which number is called, we are going to verify
          //the proper number calling in the verify in the assert part.
          //So.. thenAnswer with async and we are answering with tNumberTriviaModel, because 
          //.getConcreteNumberTrivia jika di hover, mereturn ke Future containing numberTriviModel.
          //So, we are returning our instance of the model(tNumberTriviaModel) that we have set up on above
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //we should to await here, because the Either type of .getConcreteNumberTrivia is wrapped
          //inside Future. (ini akan berpengaruh di assert)
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          //this is where we are going to verify that the mockRemoteDataSource.getConcreteNumberTrivia
          //has actually been call with the proper parameter. 
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //we expect that the reult from calling the repository will actually be equal to the Right 
          //side of the Either type because repository.getConcreteNumberTrivia return 
          //Either<Failure, NumberTrivia> 
          //So we wanna check that the result is the Right side of Either, and it should contain
          //tNumberTrivia, not the model anymore but instead the actual entity because while the data
          //sources return models, repository should casted in to being an entity which does not toJson 
          //or fromJson convertion method, because its in domain layer not in the data layer after all.
          expect(result, equals(Right(tNumberTrivia)));
        }
      );

      //we will always cache every single NumberTrivia which comes out from the API, so that
      //whenever there is no internet connection, we can always should delete this NumberTrivia to
      //the user
      test(
      'should cache the data locally when the call to remote data source is successfull',
        ()async {
          // arange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //we actually do not even need to store its result, because we are not going to expect
          //anything in assert area. Instead we are just going to verify second thing in assert area
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //verify that the mockLocalDatasource.cacheNumberTrivia has been called with the
          //tNumberTriviaModel
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        }
      );

       test(
        'should return server failure when the call to remote data surce is unsuccessful',
        ()async {
          //arange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //we wanna make sure that nothing is cached because there is nothing to cached after all
          //if we do not get a proper successfull response.
          //So we wanna verifyZeroInteraction on the mockLocalDataSource. So, nothing no method
          //should be called on the localDataSource whenever there is an exception thrown from
          //the mockRemoteDataSrouce.getConcreteNumberTrivia
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        }
      );

    });

    //when the device is offline, we want to return the cache data
    runTestOffline(() {
      test(
        'should return last locally cached data when the cache data is present',
        ()async {
          // arange
          //when mockLocalDataSource.getLastNumberTrivia() on it is called, we want to answer with 
          //acync which will return simply tNumberTriviaModel
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //testing repository.getConcreteNumberTrivia 
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          //we want to check that there no interaction with the RemoteDataSource, because after all
          //if we are offline, nothing should happen with the remoteAPI 
          verifyZeroInteractions(mockRemoteDataSource);
          //verify that actually the mockLocalDataSource.getLastNumberTrivia() has been calles once
          verify(mockLocalDataSource.getLastNumberTrivia());
          //expecting that the result is equal the Right side of the Either type, containing again 
          //tNumberTrivia entity
          expect(result, equals(Right(tNumberTrivia)));
        }
      );

      //whenever the device is offline, and there is no cached data present, its should return
      //cache Failure
      test(
        'should return CacheFailure when there is no cached data present',
        ()async {
          // arange
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
      );
    });
  });

  group('getRandomNumberTrivia', () {
    //to keep our test managable, we are going to create variable for it
    // final tNumber = 1; //getRandom does'nt need this variable
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia'); //specify te random number, for example 123
    //create final tNumberTrivia which will be the entity, its gonna be equal to tNumberTriviaModel because
    //remember that model is only a subclass of the entity. So, we can make it be the entity.
    //now this tNumberTriviaModel will be cache into the entity type
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      ()async {
        // arange
        //we need to tell the mockNetworkInfo, to always return true for its connect
        //kita pake .thenAnswer karena .isConnected meretrun Future
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true );
        // act
        //.getRandomNumberTrivia parameternya kosong ngga diisi angka karena dia method random
        repository.getRandomNumberTrivia();
        // assert
        //we want to just verify that the mockNetworkInfo.isConnected has been called
        verify(mockNetworkInfo.isConnected);
      }
    );

    runTestOnline(() {
      //whenever the device is online, the repository should return remote data, when the call
      //to remote data source is successfull
      test(
        //format: should do something, when something
        'should return remote data when the call to remote data source is successful',
        ()async {
          // arange
          //whenever mocktheRemoteDataSource.getRandomNumberTrivia with any number is called,
          //it doesnt really matter for the mock with which number is called, we are going to verify
          //the proper number calling in the verify in the assert part.
          //So.. thenAnswer with async and we are answering with tNumberTriviaModel, because 
          //.getRandomNumberTrivia jika di hover, mereturn ke Future containing numberTriviModel.
          //So, we are returning our instance of the model(tNumberTriviaModel) that we have set up on above
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //we should to await here, because the Either type of .getRandomNumberTrivia is wrapped
          //inside Future. (ini akan berpengaruh di assert)
          final result = await repository.getRandomNumberTrivia();
          // assert
          //this is where we are going to verify that the mockRemoteDataSource.getRandomNumberTrivia
          //has actually been call with the proper parameter. 
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //we expect that the result from calling the repository will actually be equal to the Right 
          //side of the Either type because repository.getRandomNumberTrivia return 
          //Either<Failure, NumberTrivia> 
          //So we wanna check that the result is the Right side of Either, and it should contain
          //tNumberTrivia, not the model anymore but instead the actual entity because while the data
          //sources return models, repository should casted in to being an entity which does not toJson 
          //or fromJson convertion method, because its in domain layer not in the data layer after all.
          expect(result, equals(Right(tNumberTrivia)));
        }
      );

      //we will always cache every single NumberTrivia which comes out from the API, so that
      //whenever there is no internet connection, we can always should delete this NumberTrivia to
      //the user
      test(
      'should cache the data locally when the call to remote data source is successfull',
        ()async {
          // arange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //we actually do not even need to store its result, because we are not going to expect
          //anything in assert area. Instead we are just going to verify second thing in assert area
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //verify that the mockLocalDatasource.cacheNumberTrivia has been called with the
          //tNumberTriviaModel
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        }
      );

       test(
        'should return server failure when the call to remote data surce is unsuccessful',
        ()async {
          //arange
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //we wanna make sure that nothing is cached because there is nothing to cached after all
          //if we do not get a proper successfull response.
          //So we wanna verifyZeroInteraction on the mockLocalDataSource. So, nothing no method
          //should be called on the localDataSource whenever there is an exception thrown from
          //the mockRemoteDataSrouce.getRandomNumberTrivia
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        }
      );

    });

    //when the device is offline, we want to return the cache data
    runTestOffline(() {
      test(
        'should return last locally cached data when the cache data is present',
        ()async {
          // arange
          //when mockLocalDataSource.getLastNumberTrivia() on it is called, we want to answer with 
          //acync which will return simply tNumberTriviaModel
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          // act
          //testing repository.getRandomNumberTrivia 
          final result = await repository.getRandomNumberTrivia();
          // assert
          //we want to check that there no interaction with the RemoteDataSource, because after all
          //if we are offline, nothing should happen with the remoteAPI 
          verifyZeroInteractions(mockRemoteDataSource);
          //verify that actually the mockLocalDataSource.getLastNumberTrivia() has been calles once
          verify(mockLocalDataSource.getLastNumberTrivia());
          //expecting that the result is equal the Right side of the Either type, containing again 
          //tNumberTrivia entity
          expect(result, equals(Right(tNumberTrivia)));
        }
      );

      //whenever the device is offline, and there is no cached data present, its should return
      //cache Failure
      test(
        'should return CacheFailure when there is no cached data present',
        ()async {
          // arange
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
      );
    });
  });
}