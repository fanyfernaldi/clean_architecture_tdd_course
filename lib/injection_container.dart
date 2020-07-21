import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

//the GetIt class has the call() method to make for an easier syntax, very much like our cases
//have a call() method too
final sl = GetIt.instance; //sl tu maksudnya service locator

Future<void> init() async {
  //! Features = Number Trivia
  // * Bloc
  //Classes requiring cleanup(such as Blocs) shouldn't be registered as singletons.
  //They are very close to the UI and if your app has multiple pages between which you navigate, you
  //probaly want do some clean up (like closing Streams of Bloc) from the dispose() method of
  //a StatefulWidget
  //Having a singleton for classes with this kind of a disposal would lead(menyebabkan) to tying to use
  //a presentation logic holder (such as Bloc) with closed Stream's, instead of creating a new instance
  //with opened Stream's whenever you'd try to get an object of that type from GetIt
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      inputConverter: sl(),
      random: sl(),
    ),
  );

  // * Use cases
  //GetIt give us two option when it comes to singletons. We can either registerSingleton or
  //registerLazySingleton. The only difference between them is that a non-lazy singleton is always 
  //registered immediately after the app starts, while a lazy singleton is registered only when it's
  //requested as a dependency for some other class.
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // * Repository
  //However, we cannot instantiate a contract (which is an abstract class). Instead, we have to
  //instantiate the repository. This is possible by specifying a type parameter on the
  //registerLazySingleton method
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // * Data sources
  //Repository also depends on contracts, so we're again going to specify a type parameter manually.
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  //Unlike all of the other classes, SharedPreferences cannot be simply instantiated with a regular 
  //constructor call. Instead, we have to call SharedPreferences.getInstance() which is an asyncdhronous
  //methodd! You think that we cana simply do this : 
  //sl.registerLazySingleton(() async => SharedPreferences.getInstance()); the higher-order function, 
  //however, would in this case return a Future<SharedPreferences>, which is not what we want. We want
  //to register a simple instance of SharedPreferences instead.
  //For that we need to await the call t getInstance() outside of the registration. This will require us
  //to change the init() method signature to add the async on there
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
