import 'package:get_it/get_it.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ToastService());
  locator.registerLazySingleton(() => JobService());
  locator.registerLazySingleton(() => ChatService());
}
