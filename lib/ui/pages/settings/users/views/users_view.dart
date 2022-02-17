//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/models/user_model.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';

class UsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsCubit settingsCubit = BlocProvider.of<SettingsCubit>(context);
    AuthApiCubit authApiCubit = BlocProvider.of<AuthApiCubit>(context);
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    settingsCubit.hideForm();
    authApiCubit.getAllUsers(authDataCubit.state.token);

    return BlocBuilder<AuthApiCubit, AuthApiState>(
      builder: (_, state) {
        if (state is AuthApiLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AuthApiLoadUserListSuccess) {
          return _buildUsersList(settingsCubit, state.users);
        }
        if (state is AuthApiActionSuccess) {
          settingsCubit.hideForm();
          authApiCubit.getAllUsers(authDataCubit.state.token);
        }
        if (state is AuthApiActionFailure) {
          authApiCubit.getAllUsers(authDataCubit.state.token);
        }
        if (state is AuthApiFailure) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Padding _buildUsersList(SettingsCubit settingsCubit, List<UserModel> users) {
    ScrollController _scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5.0,
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(users[index].username),
                subtitle: Text(users[index].role),
                trailing: Text(users[index].email),
                onTap: () {
                  settingsCubit.showUserForm(users[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
