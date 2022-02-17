//@dart=2.9

import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:task/task.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/helpers/settings_menu_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/ui/pages/auth/auth_page.dart';
import 'package:tms_web_app/ui/pages/home/home_page.dart';
import 'package:tms_web_app/ui/pages/settings/settings_page.dart';

class CompositionRoot {
  static String _baseUrl;
  static Client _client;
  static IAuthApi _authApi;
  static ITaskApi _taskApi;

  static configure() async {
    await dotenv.load(fileName: '.env');
    _baseUrl = dotenv.env['API_URL'];
    _client = Client();
    _authApi = AuthApi(_baseUrl, _client);
    _taskApi = TaskApi(_baseUrl, _client);
  }

  static Widget composeAuthUI() {
    AuthApiCubit _authApiCubit = AuthApiCubit(_authApi);

    return BlocProvider(
      create: (BuildContext context) => _authApiCubit,
      child: AuthPage(),
    );
  }

  static Widget composeHomeUI() {
    TaskApiCubit _taskCubit = TaskApiCubit(_taskApi);

    return BlocProvider(
      create: (BuildContext context) => _taskCubit,
      child: HomePage(),
    );
  }

  static Widget composeSettingsUI() {
    AuthApiCubit _authApiCubit = AuthApiCubit(_authApi);
    TaskApiCubit _taskApiCubit = TaskApiCubit(_taskApi);
    SettingsCubit _settingsCubit = SettingsCubit();
    SettingsMenuCubit _settingsMenuCubit = SettingsMenuCubit();
    StatusCubit _statusCubit = StatusCubit();
    ColorCubit _colorCubit = ColorCubit();
    MembersCubit _membersCubit = MembersCubit();
    RoleCubit _roleCubit = RoleCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthApiCubit>(
          create: (BuildContext context) => _authApiCubit,
        ),
        BlocProvider<TaskApiCubit>(
          create: (BuildContext context) => _taskApiCubit,
        ),
        BlocProvider<SettingsCubit>(
          create: (BuildContext context) => _settingsCubit,
        ),
        BlocProvider<SettingsMenuCubit>(
          create: (BuildContext context) => _settingsMenuCubit,
        ),
        BlocProvider<StatusCubit>(
          create: (BuildContext context) => _statusCubit,
        ),
        BlocProvider<ColorCubit>(
          create: (BuildContext context) => _colorCubit,
        ),
        BlocProvider<MembersCubit>(
          create: (BuildContext context) => _membersCubit,
        ),
        BlocProvider<RoleCubit>(
          create: (BuildContext context) => _roleCubit,
        ),
      ],
      child: SettingsPage(),
    );
  }
}
