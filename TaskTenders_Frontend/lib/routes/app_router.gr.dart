// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:flutter/material.dart' as _i28;
import 'package:tasktender_frontend/models/chat.model.dart' as _i29;
import 'package:tasktender_frontend/models/job.model.dart' as _i30;
import 'package:tasktender_frontend/screens/client/client_main_screen.dart'
    as _i6;
import 'package:tasktender_frontend/screens/client/pages/history/client_history_page.dart'
    as _i3;
import 'package:tasktender_frontend/screens/client/pages/history/client_job_navigation_screen.dart'
    as _i5;
import 'package:tasktender_frontend/screens/client/pages/history/job__details/job_details_page.dart'
    as _i13;
import 'package:tasktender_frontend/screens/client/pages/home/client_home_page.dart'
    as _i4;
import 'package:tasktender_frontend/screens/client/pages/job/client_search_page.dart'
    as _i9;
import 'package:tasktender_frontend/screens/client/pages/profile/client_account_page.dart'
    as _i2;
import 'package:tasktender_frontend/screens/client/pages/profile/client_profile_navigation_screen.dart'
    as _i7;
import 'package:tasktender_frontend/screens/client/pages/profile/client_profile_page.dart'
    as _i8;
import 'package:tasktender_frontend/screens/register_complition/register_complition_screen.dart'
    as _i15;
import 'package:tasktender_frontend/screens/shared/chat_screen.dart' as _i1;
import 'package:tasktender_frontend/screens/shared/inbox/inbox_navigation_screen.dart'
    as _i10;
import 'package:tasktender_frontend/screens/shared/inbox/inbox_page.dart'
    as _i11;
import 'package:tasktender_frontend/screens/shared/introduction_screen.dart'
    as _i12;
import 'package:tasktender_frontend/screens/shared/login_screen.dart' as _i14;
import 'package:tasktender_frontend/screens/shared/signup_screen.dart' as _i16;
import 'package:tasktender_frontend/screens/shared/welcome_screen.dart' as _i26;
import 'package:tasktender_frontend/screens/tasker/pages/home/tasker_home_page.dart'
    as _i19;
import 'package:tasktender_frontend/screens/tasker/pages/jobs/applied_job/tasker_applied_job_screen.dart'
    as _i18;
import 'package:tasktender_frontend/screens/tasker/pages/jobs/tasker_job_details_page.dart'
    as _i20;
import 'package:tasktender_frontend/screens/tasker/pages/jobs/tasker_search_navigation_screen.dart'
    as _i24;
import 'package:tasktender_frontend/screens/tasker/pages/jobs/tasker_search_page.dart'
    as _i25;
import 'package:tasktender_frontend/screens/tasker/pages/profile/tasker_account_page.dart'
    as _i17;
import 'package:tasktender_frontend/screens/tasker/pages/profile/tasker_profile_navigation_screen.dart'
    as _i22;
import 'package:tasktender_frontend/screens/tasker/pages/profile/tasker_profile_page.dart'
    as _i23;
import 'package:tasktender_frontend/screens/tasker/tasker_main_screen.dart'
    as _i21;

/// generated route for
/// [_i1.ChatScreen]
class ChatRoute extends _i27.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i28.Key? key,
    required String chatId,
    required _i29.Chat chat,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            chatId: chatId,
            chat: chat,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i1.ChatScreen(
        key: args.key,
        chatId: args.chatId,
        chat: args.chat,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.chatId,
    required this.chat,
  });

  final _i28.Key? key;

  final String chatId;

  final _i29.Chat chat;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatId: $chatId, chat: $chat}';
  }
}

/// generated route for
/// [_i2.ClientAccountPage]
class ClientAccountRoute extends _i27.PageRouteInfo<void> {
  const ClientAccountRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientAccountRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i2.ClientAccountPage();
    },
  );
}

/// generated route for
/// [_i3.ClientHistoryPage]
class ClientHistoryRoute extends _i27.PageRouteInfo<void> {
  const ClientHistoryRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientHistoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i3.ClientHistoryPage();
    },
  );
}

/// generated route for
/// [_i4.ClientHomePage]
class ClientHomeRoute extends _i27.PageRouteInfo<void> {
  const ClientHomeRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientHomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i4.ClientHomePage();
    },
  );
}

/// generated route for
/// [_i5.ClientJobNavigationScreen]
class ClientJobNavigationRoute extends _i27.PageRouteInfo<void> {
  const ClientJobNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientJobNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientJobNavigationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i5.ClientJobNavigationScreen();
    },
  );
}

/// generated route for
/// [_i6.ClientMainScreen]
class ClientMainRoute extends _i27.PageRouteInfo<void> {
  const ClientMainRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientMainRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.ClientMainScreen();
    },
  );
}

/// generated route for
/// [_i7.ClientProfileNavigationScreen]
class ClientProfileNavigationRoute extends _i27.PageRouteInfo<void> {
  const ClientProfileNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientProfileNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileNavigationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.ClientProfileNavigationScreen();
    },
  );
}

/// generated route for
/// [_i8.ClientProfilePage]
class ClientProfileRoute extends _i27.PageRouteInfo<void> {
  const ClientProfileRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i8.ClientProfilePage();
    },
  );
}

/// generated route for
/// [_i9.ClientSearchPage]
class ClientSearchRoute extends _i27.PageRouteInfo<void> {
  const ClientSearchRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ClientSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSearchRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i9.ClientSearchPage();
    },
  );
}

/// generated route for
/// [_i10.InboxNavigationScreen]
class InboxNavigationRoute extends _i27.PageRouteInfo<void> {
  const InboxNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          InboxNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'InboxNavigationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i10.InboxNavigationScreen();
    },
  );
}

/// generated route for
/// [_i11.InboxPage]
class InboxRoute extends _i27.PageRouteInfo<InboxRouteArgs> {
  InboxRoute({
    _i28.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          InboxRoute.name,
          args: InboxRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'InboxRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<InboxRouteArgs>(orElse: () => const InboxRouteArgs());
      return _i11.InboxPage(key: args.key);
    },
  );
}

class InboxRouteArgs {
  const InboxRouteArgs({this.key});

  final _i28.Key? key;

  @override
  String toString() {
    return 'InboxRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.IntroScreen]
class IntroRoute extends _i27.PageRouteInfo<void> {
  const IntroRoute({List<_i27.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.IntroScreen();
    },
  );
}

/// generated route for
/// [_i13.JobDetailsPage]
class JobDetailsRoute extends _i27.PageRouteInfo<JobDetailsRouteArgs> {
  JobDetailsRoute({
    _i28.Key? key,
    required String id,
    required _i30.Job job,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          JobDetailsRoute.name,
          args: JobDetailsRouteArgs(
            key: key,
            id: id,
            job: job,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'JobDetailsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JobDetailsRouteArgs>();
      return _i13.JobDetailsPage(
        key: args.key,
        id: args.id,
        job: args.job,
      );
    },
  );
}

class JobDetailsRouteArgs {
  const JobDetailsRouteArgs({
    this.key,
    required this.id,
    required this.job,
  });

  final _i28.Key? key;

  final String id;

  final _i30.Job job;

  @override
  String toString() {
    return 'JobDetailsRouteArgs{key: $key, id: $id, job: $job}';
  }
}

/// generated route for
/// [_i14.LoginScreen]
class LoginRoute extends _i27.PageRouteInfo<void> {
  const LoginRoute({List<_i27.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i14.LoginScreen();
    },
  );
}

/// generated route for
/// [_i15.RegisterComplitionScreen]
class RegisterComplitionRoute extends _i27.PageRouteInfo<void> {
  const RegisterComplitionRoute({List<_i27.PageRouteInfo>? children})
      : super(
          RegisterComplitionRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterComplitionRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.RegisterComplitionScreen();
    },
  );
}

/// generated route for
/// [_i16.SignUpScreen]
class SignUpRoute extends _i27.PageRouteInfo<void> {
  const SignUpRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i16.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i17.TaskerAccountPage]
class TaskerAccountRoute extends _i27.PageRouteInfo<void> {
  const TaskerAccountRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerAccountRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i17.TaskerAccountPage();
    },
  );
}

/// generated route for
/// [_i18.TaskerAppliedJobScreen]
class TaskerAppliedJobRoute
    extends _i27.PageRouteInfo<TaskerAppliedJobRouteArgs> {
  TaskerAppliedJobRoute({
    _i28.Key? key,
    required _i30.Job job,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          TaskerAppliedJobRoute.name,
          args: TaskerAppliedJobRouteArgs(
            key: key,
            job: job,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskerAppliedJobRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskerAppliedJobRouteArgs>();
      return _i18.TaskerAppliedJobScreen(
        key: args.key,
        job: args.job,
      );
    },
  );
}

class TaskerAppliedJobRouteArgs {
  const TaskerAppliedJobRouteArgs({
    this.key,
    required this.job,
  });

  final _i28.Key? key;

  final _i30.Job job;

  @override
  String toString() {
    return 'TaskerAppliedJobRouteArgs{key: $key, job: $job}';
  }
}

/// generated route for
/// [_i19.TaskerHomePage]
class TaskerHomeRoute extends _i27.PageRouteInfo<void> {
  const TaskerHomeRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerHomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.TaskerHomePage();
    },
  );
}

/// generated route for
/// [_i20.TaskerJobDetailsPage]
class TaskerJobDetailsRoute
    extends _i27.PageRouteInfo<TaskerJobDetailsRouteArgs> {
  TaskerJobDetailsRoute({
    _i28.Key? key,
    required String jobId,
    required _i30.Job job,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          TaskerJobDetailsRoute.name,
          args: TaskerJobDetailsRouteArgs(
            key: key,
            jobId: jobId,
            job: job,
          ),
          rawPathParams: {'jobId': jobId},
          initialChildren: children,
        );

  static const String name = 'TaskerJobDetailsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskerJobDetailsRouteArgs>();
      return _i20.TaskerJobDetailsPage(
        key: args.key,
        jobId: args.jobId,
        job: args.job,
      );
    },
  );
}

class TaskerJobDetailsRouteArgs {
  const TaskerJobDetailsRouteArgs({
    this.key,
    required this.jobId,
    required this.job,
  });

  final _i28.Key? key;

  final String jobId;

  final _i30.Job job;

  @override
  String toString() {
    return 'TaskerJobDetailsRouteArgs{key: $key, jobId: $jobId, job: $job}';
  }
}

/// generated route for
/// [_i21.TaskerMainScreen]
class TaskerMainRoute extends _i27.PageRouteInfo<void> {
  const TaskerMainRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerMainRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i21.TaskerMainScreen();
    },
  );
}

/// generated route for
/// [_i22.TaskerProfileNavigationScreen]
class TaskerProfileNavigationRoute extends _i27.PageRouteInfo<void> {
  const TaskerProfileNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerProfileNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerProfileNavigationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i22.TaskerProfileNavigationScreen();
    },
  );
}

/// generated route for
/// [_i23.TaskerProfilePage]
class TaskerProfileRoute extends _i27.PageRouteInfo<void> {
  const TaskerProfileRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i23.TaskerProfilePage();
    },
  );
}

/// generated route for
/// [_i24.TaskerSearchNavigationScreen]
class TaskerSearchNavigationRoute extends _i27.PageRouteInfo<void> {
  const TaskerSearchNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerSearchNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerSearchNavigationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i24.TaskerSearchNavigationScreen();
    },
  );
}

/// generated route for
/// [_i25.TaskerSearchPage]
class TaskerSearchRoute extends _i27.PageRouteInfo<void> {
  const TaskerSearchRoute({List<_i27.PageRouteInfo>? children})
      : super(
          TaskerSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskerSearchRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i25.TaskerSearchPage();
    },
  );
}

/// generated route for
/// [_i26.WelcomeScreen]
class WelcomeRoute extends _i27.PageRouteInfo<void> {
  const WelcomeRoute({List<_i27.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.WelcomeScreen();
    },
  );
}
