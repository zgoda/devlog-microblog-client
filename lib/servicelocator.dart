import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  locator.registerSingletonAsync<LocalStorageService>(() async {
    return await LocalStorageService.getInstance();
  });
}
