import 'package:auto_route/auto_route.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/routes/auth_gaurd.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard = AuthGuard();
  final UnAuthGuard unAuthGuard = UnAuthGuard();
  final RoleGuard roleGuard = RoleGuard();

  @override
  List<AutoRoute> get routes => [
        // Unauthenticated Screens

        AutoRoute(
            page: WelcomeRoute.page,
            path: '/welcome',
            initial: true,
            guards: [unAuthGuard]),
        AutoRoute(
          page: IntroRoute.page,
          path: '/intro',
        ),
        AutoRoute(page: LoginRoute.page, path: '/login', guards: [unAuthGuard]),
        AutoRoute(
            page: SignUpRoute.page, path: '/signup', guards: [unAuthGuard]),
        AutoRoute(
          page: RegisterComplitionRoute.page,
          path: '/register-completion',
          guards: [unAuthGuard],
        ),
        // Authenticated Screens
        // Client Screens ------------------------------------------------
        AutoRoute(page: ClientMainRoute.page, path: '/client', guards: [
          authGuard,
          roleGuard
        ], children: [
          AutoRoute(page: ClientHomeRoute.page, path: 'home'),
          AutoRoute(page: InboxNavigationRoute.page, path: 'inbox', children: [
            AutoRoute(page: InboxRoute.page, path: '', initial: true),
            // AutoRoute(page: ChatRoute.page, path: 'chat/:userId'),
          ]),
          AutoRoute(page: ClientSearchRoute.page, path: 'search'),
          AutoRoute(
              page: ClientJobNavigationRoute.page,
              path: 'history',
              children: [
                AutoRoute(
                    page: ClientHistoryRoute.page, path: '', initial: true),
                AutoRoute(
                  path: ':id',
                  page: JobDetailsRoute
                      .page, // Replace with the page that displays job details
                ),
              ]),
          AutoRoute(
              page: ClientProfileNavigationRoute.page,
              path: 'profile',
              children: [
                AutoRoute(
                    page: ClientProfileRoute.page, path: '', initial: true),
                AutoRoute(page: ClientAccountRoute.page, path: 'account'),
              ]),
        ]),
        // Tasker Screens ------------------------------------------------
        AutoRoute(page: TaskerMainRoute.page, path: '/tasker', guards: [
          authGuard,
          roleGuard
        ], children: [
          AutoRoute(page: TaskerHomeRoute.page, path: 'home'),
          AutoRoute(
              page: TaskerSearchNavigationRoute.page,
              path: 'search',
              children: [
                AutoRoute(
                    page: TaskerSearchRoute.page, path: '', initial: true),
                AutoRoute(page: TaskerJobDetailsRoute.page, path: 'job/:id'),
                AutoRoute(
                    page: TaskerAppliedJobRoute.page, path: 'applied_job'),
              ]),
          AutoRoute(page: InboxNavigationRoute.page, path: 'inbox', children: [
            AutoRoute(page: InboxRoute.page, path: '', initial: true),
            // AutoRoute(page: ChatRoute.page, path: 'chat/:userId'),
          ]),
          AutoRoute(
              page: TaskerProfileNavigationRoute.page,
              path: 'profile',
              children: [
                AutoRoute(
                    page: TaskerProfileRoute.page, path: '', initial: true),
                // AutoRoute(page: ChatRoute.page, path: 'chat/:id'),
                AutoRoute(page: TaskerAccountRoute.page, path: 'account'),
              ]),
        ]),
        AutoRoute(
            page: ChatRoute.page, path: '/chat/:userId', guards: [authGuard]),
        // AutoRoute(page: IntroRoute.page, path: '/intro'),
        // AutoRoute(
        //   page: FreelancerHomeRoute.page,
        //   path: '/freelancer-home',
        //   guards: [authGuard, roleGuard],
        // ),
        // AutoRoute(
        //   page: AdminHomeRoute.page,
        //   path: '/admin-home',
        //   guards: [authGuard, roleGuard],
        // ),
      ];
}
