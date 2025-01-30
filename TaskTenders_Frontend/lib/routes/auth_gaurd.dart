import 'package:auto_route/auto_route.dart';
import 'package:tasktender_frontend/models/user.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';

class AuthGuard extends AutoRouteGuard {
  final _userService = locator<UserService>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_userService.isAuthenticated()) {
      // Allow navigation
      resolver.next();
    } else {
      // Redirect to login screen if not authenticated
      router.replaceAll([LoginRoute()]);
    }
  }
}

class UnAuthGuard extends AutoRouteGuard {
  final _userService = locator<UserService>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_userService.isAuthenticated()) {
      final UserRole? userRole = await _userService.getUserType();
      if (userRole == null) {
        // TODO: Redirect to Screen to complete registration
        if (resolver.route.name == RegisterComplitionRoute.name) {
          print('RegisterComplitionRoute => ${resolver.route.name}');
          resolver.next();
          LoadingService.hideLoadingIndicator();
          return;
        }
        print('Redirecting to RegisterComplitionRoute in UnAuthGuard');
        router.replaceAll([RegisterComplitionRoute()]);
      } else {
        switch (userRole) {
          case UserRole.client:
            router.replaceAll([ClientHomeRoute()]);
            break;
          case UserRole.tasker:
            router.replaceAll([TaskerHomeRoute()]);
            break;
          default:
        }
      }
    } else {
      // Redirect to login screen if not authenticated
      resolver.next();
    }
    LoadingService.hideLoadingIndicator();
  }
}

class RoleGuard extends AutoRouteGuard {
  final _userService = locator<UserService>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final UserRole? userRole = await _userService
        .getUserType(); // Returns "client", "freelancer", or "admin"
    if (userRole == null) {
      router.replaceAll([RegisterComplitionRoute()]);
    } else {
      switch (userRole) {
        case UserRole.client:
          if (resolver.route.name == ClientMainRoute.name) {
            print("ClientMainRoute => ${resolver.route.name}");
            resolver.next();
          } else {
            router.replaceAll([ClientHomeRoute()]);
          }
          break;
        case UserRole.tasker:
          if (resolver.route.name == TaskerMainRoute.name) {
            print("TaskerMainRoute => ${resolver.route.name}");
            resolver.next();
          } else {
            router.replaceAll([TaskerHomeRoute()]);
          }
          break;
        default:
          router.replaceAll([LoginRoute()]);
      }
    }
    LoadingService.hideLoadingIndicator();
  }
}
