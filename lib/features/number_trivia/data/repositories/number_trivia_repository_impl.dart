import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

//repository is the brain of the data layer of an app, its handle data from remote and local data sources
//besides which data source to prefer, and also this is where data casing policy is decided upon.

typedef Future<NumberTrivia> _ConcreteOrRandomChoose();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  //START CARA 1 (BASIC, ANTARA GETCONCRETENUMBER TRIVIA DAN GETRANDOMTRIVIA TIDAK DI REFACTOR KE SUATU METHOD) 
  //its a job of the repository to get fresh data from the API when there is an internet connectioon, and then also
  //we're gonna cache it locally whenever we get it from the API, but also when we find out over here that there is
  //internet connection, we are going to cache data, so the user will always see some trivia displayed on the screen
  //so therefore getting to know the network status is the first thing that should happen from within getConcreteNumberTrivia
  //which we are currently implementing.

  // @override
  // Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
  //   //if we are online
  //   if(await networkInfo.isConnected) {
  //     try{
  //       final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
  //       //we also cache this NumberTriviaModel instance model into localDataSource
  //       //so cacheNumberTrivia and the trivia to case is remoteTrivia
  //       localDataSource.cacheNumberTrivia(remoteTrivia);
  //       return Right(remoteTrivia);
  //     } on ServerException {
  //       return Left(ServerFailure());
  //     }
  //   //if we are not online
  //   } else {
  //     try {
  //       final localTrivia = await localDataSource.getLastNumberTrivia();
  //       return Right(localTrivia);
  //     } on CacheException {
  //       return Left(CacheFailure());
  //     }
  //   }
  // }

  // @override
  // Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
  //   //if we are online
  //   if(await networkInfo.isConnected) {
  //     try{
  //       final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
  //       //we also cache this NumberTriviaModel instance model into localDataSource
  //       //so cacheNumberTrivia and the trivia to case is remoteTrivia
  //       localDataSource.cacheNumberTrivia(remoteTrivia);
  //       return Right(remoteTrivia);
  //     } on ServerException {
  //       return Left(ServerFailure());
  //     }
  //   //if we are not online
  //   } else {
  //     try {
  //       final localTrivia = await localDataSource.getLastNumberTrivia();
  //       return Right(localTrivia);
  //     } on CacheException {
  //       return Left(CacheFailure());
  //     }
  //   }
  // }
  //END CARA 1


  //START CARA 2 (LEBIH TERHINDAR DARI DUPLIKASI CODE, KARENA SUDAH DIREFACTOR MENGGUNAKAN METHOD _getTrivia)
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    // Future<NumberTrivia> Function() getConcreteOrRandom //cara 1, tanpa implementasi typedef
    _ConcreteOrRandomChoose getConcreteOrRandom //cara 2, implementasi typedef _ConcreteOrRandomChoose
  ) async {
      //if we are online
    if(await networkInfo.isConnected) {
      try{
        final remoteTrivia = await getConcreteOrRandom();
        //we also cache this NumberTriviaModel instance model into localDataSource
        //so cacheNumberTrivia and the trivia to case is remoteTrivia
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    //if we are not online
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
  //END CARA 2
}
