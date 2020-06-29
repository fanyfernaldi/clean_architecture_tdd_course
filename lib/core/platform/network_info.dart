//this contract is inside the core, because this can be shared accross multiple feature, because checking for
//connectivity is something which is really not exclusive to the NumberTrivia features.
//And its inside the platform folder because, it deals with the underline platform off course. On android the
//proses of getting network info can be different than on iOS, but off course we are going to use library
//which will just streamline this process into just one method call, but should do not use a connectivity library,
//and you will implementing yourself, you would have probably a bit different code for each platform, so thats why 
//its goes over here, to the platform folder

abstract class NetworkInfo {
  Future<bool> get isConnected;
}