//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class UsernameFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthApiCubit authApiCubit = BlocProvider.of<AuthApiCubit>(context);
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    return BlocBuilder<AuthApiCubit, AuthApiState>(
      bloc: authApiCubit,
      builder: (_, state) {
        if (state is AuthApiLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AuthApiFailure) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          );
        }
        return _buildProfileUI(authApiCubit, authDataCubit);
      },
    );
  }

  Container _buildProfileUI(AuthApiCubit authApiCubit, AuthDataCubit authDataCubit) {
    String _username = authDataCubit.state.username;
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconButton(
                  icon: Icons.save,
                  iconColor: Colors.white,
                  onPressed: () {
                    authApiCubit.updateUserName(
                      authDataCubit.state.token,
                      authDataCubit.state.id,
                      _username,
                    );
                    authDataCubit.update(
                      id: authDataCubit.state.id,
                      username: _username != '' ? _username : authDataCubit.state.username,
                      email: authDataCubit.state.email,
                      role: authDataCubit.state.role,
                      token: authDataCubit.state.token,
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
                      controller: TextEditingController(text: _username),
                      hint: 'Username',
                      obscure: false,
                      enabled: true,
                      onChanged: (val) {
                        _username = val;
                      },
                    ),
                    SizedBox(height: 15.0),
                    CustomTextField(
                      controller: TextEditingController(text: authDataCubit.state.email),
                      hint: 'Email',
                      obscure: false,
                      enabled: false,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 15.0),
                    CustomTextField(
                      controller: TextEditingController(text: authDataCubit.state.role),
                      hint: 'Role',
                      obscure: false,
                      enabled: false,
                      onChanged: (val) {},
                    ),
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
