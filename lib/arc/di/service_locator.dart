import 'package:get_it/get_it.dart';
import '../network/api_provider.dart';


GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ApiProvider>(ApiProvider());
  
}