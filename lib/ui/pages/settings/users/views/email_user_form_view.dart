//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/models.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';
import 'package:tms_web_app/ui/pages/settings/users/widgets/role_radio_group.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class EmailUserFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthApiCubit authApiCubit = BlocProvider.of<AuthApiCubit>(context);
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: BlocProvider.of<SettingsCubit>(context),
      builder: (_, state) {
        if (state is SettingsUserLoadSuccess) {
          BlocProvider.of<RoleCubit>(context).update(state.user.role);
          return _buildUserFormUI(context, authDataCubit, authApiCubit, state.user);
        }
        if (state is SettingsEmailLoadSuccess) {
          BlocProvider.of<RoleCubit>(context).update(state.email.role);
          return _buildEmailFormUI(context, authDataCubit, authApiCubit, state.email);
        }
        return SizedBox();
      },
    );
  }

  Container _buildUserFormUI(BuildContext context, AuthDataCubit authDataCubit,
      AuthApiCubit authApiCubit, UserModel user) {
    return Container(
      child: Column(
        children: [
          Container(
            height: UIHelper.barHeight,
            decoration: BoxDecoration(
              color: UIHelper.themeColor,
              borderRadius: UIHelper.customBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  icon: Icons.clear,
                  iconColor: Colors.white,
                  onPressed: () {
                    BlocProvider.of<SettingsCubit>(context).hideForm();
                  },
                ),
                if (!(user.id == authDataCubit.state.id))
                  CustomIconButton(
                    icon: Icons.delete,
                    iconColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomConfirmDialog(
                          title: 'Delete User',
                          content: 'Delete this User?',
                          onOKPressed: () {
                            authApiCubit.deleteUser(
                              authDataCubit.state.token,
                              user.id,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                if (user.id != authDataCubit.state.id)
                  CustomIconButton(
                    icon: Icons.save,
                    iconColor: Colors.white,
                    onPressed: () {
                      authApiCubit.updateUserRole(
                        authDataCubit.state.token,
                        user.id,
                        BlocProvider.of<RoleCubit>(context).state,
                      );
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: TextEditingController(text: user.username),
                      hint: 'Username',
                      obscure: false,
                      enabled: false,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 10.0),
                    CustomTextField(
                      controller: TextEditingController(text: user.email),
                      hint: 'Email',
                      obscure: false,
                      enabled: false,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 10.0),
                    CustomTextField(
                      controller: TextEditingController(text: user.isConfirmed ? 'YES' : 'NO'),
                      hint: 'Active account',
                      obscure: false,
                      enabled: false,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 10.0),
                    RoleRadioGroup(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildEmailFormUI(BuildContext context, AuthDataCubit authDataCubit,
      AuthApiCubit authApiCubit, EmailModel email) {
    String _email = email.email;

    return Container(
      child: Column(
        children: [
          Container(
            height: UIHelper.barHeight,
            decoration: BoxDecoration(
              color: UIHelper.themeColor,
              borderRadius: UIHelper.customBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  icon: Icons.clear,
                  iconColor: Colors.white,
                  onPressed: () {
                    BlocProvider.of<SettingsCubit>(context).hideForm();
                  },
                ),
                if ((email.email != authDataCubit.state.email) && email.id != null)
                  CustomIconButton(
                    icon: Icons.delete,
                    iconColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomConfirmDialog(
                          title: 'Delete Email',
                          content: 'Delete this Email?',
                          onOKPressed: () {
                            authApiCubit.deleteEmail(
                              authDataCubit.state.token,
                              email.id,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                if (email.email != authDataCubit.state.email)
                  CustomIconButton(
                    icon: Icons.save,
                    iconColor: Colors.white,
                    onPressed: () {
                      if (email.id == null) {
                        authApiCubit.addEmail(
                          authDataCubit.state.token,
                          _email,
                          BlocProvider.of<RoleCubit>(context).state,
                        );
                      } else {
                        authApiCubit.updateEmail(
                          authDataCubit.state.token,
                          email.id,
                          _email,
                          BlocProvider.of<RoleCubit>(context).state,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: TextEditingController(text: _email),
                      hint: 'Email',
                      obscure: false,
                      enabled: email.hasUser ? false : true,
                      onChanged: (val) {
                        _email = val;
                      },
                    ),
                    SizedBox(height: 10.0),
                    RoleRadioGroup(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
