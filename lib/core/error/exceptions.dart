//biasanya namanya exception.dart bukan exceptions.dart

class ServerException implements Exception {}

class CacheException implements Exception {}

//lets also creates Failures, because remember that the repository will cache this exceptions and it will transform
//them into Failures then they would be return using the Either type. More precisely(tepat) as the Left side of
//the Either type.
//So, because of that usually Failures map exactly one to one to exception
//(lihat di lib/core/error/failures.dart), yang ada comentar 'General failures'