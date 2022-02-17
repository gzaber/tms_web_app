//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/composition_root.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController(initialPage: 1);

  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Task Management System',
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),
                ),
              ),
              SizedBox(height: 20.0),
              BlocConsumer<AuthApiCubit, AuthApiState>(
                builder: (_, state) {
                  return _buildUI();
                },
                listener: (context, state) {
                  if (state is AuthApiLoading) {
                    UIHelper.showLoader(context);
                  }
                  if (state is AuthApiLoginSuccess) {
                    BlocProvider.of<AuthDataCubit>(context).update(
                      id: state.userModel.id,
                      username: state.userModel.username,
                      email: state.userModel.email,
                      role: state.userModel.role,
                      token: state.token,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CompositionRoot.composeHomeUI(),
                      ),
                    );
                  }
                  if (state is AuthApiRegisterSuccess) {
                    UIHelper.hideLoader(context);
                    _controller.previousPage(
                        duration: Duration(milliseconds: 500), curve: Curves.linear);
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackBar.show(
                            'User registered\nCheck your mailbox for confirmation', true, context),
                      );
                  }
                  if (state is AuthApiForgotPasswordSuccess) {
                    UIHelper.hideLoader(context);
                    _controller.nextPage(
                        duration: Duration(milliseconds: 500), curve: Curves.linear);
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackBar.show(
                            'Send email for reset password\nCheck your mailbox', true, context),
                      );
                  }
                  if (state is AuthApiFailure) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackBar.show(state.message, false, context),
                      );
                    UIHelper.hideLoader(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  Widget _buildUI() => Container(
        height: 400.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _forgotPassword(),
            _login(),
            _register(),
          ],
        ),
      );
  // ===========================================================================
  Widget _forgotPassword() => Center(
        child: Container(
          width: Responsive.getAuthViewWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Email',
                  obscure: false,
                  onChanged: (val) {
                    _email = val;
                  }),
              SizedBox(height: 10.0),
              CustomElevatedButton(
                text: 'RESET PASSWORD',
                onPressed: () {
                  BlocProvider.of<AuthApiCubit>(context).forgotPassword(_email);
                },
              ),
              SizedBox(height: 10.0),
              CustomRichText(
                text: 'Go back to',
                linkText: 'Login',
                onTap: () {
                  _controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
              ),
            ],
          ),
        ),
      );
  // ===========================================================================
  Widget _login() => Center(
        child: Container(
          width: Responsive.getAuthViewWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Email',
                  obscure: false,
                  onChanged: (val) {
                    _email = val;
                  }),
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Password',
                  obscure: true,
                  onChanged: (val) {
                    _password = val;
                  }),
              SizedBox(height: 10.0),
              CustomElevatedButton(
                text: 'LOGIN',
                onPressed: () {
                  BlocProvider.of<AuthApiCubit>(context).login(_email, _password);
                },
              ),
              SizedBox(height: 10.0),
              CustomRichText(
                text: 'Forgot password?',
                linkText: 'Reset',
                onTap: () {
                  _controller.previousPage(
                      duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
              ),
              SizedBox(height: 10.0),
              CustomRichText(
                text: 'Don\'t have an account?',
                linkText: 'Register',
                onTap: () {
                  _controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
              ),
            ],
          ),
        ),
      );
  // ===========================================================================
  Widget _register() => Center(
        child: Container(
          width: Responsive.getAuthViewWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Username',
                  obscure: false,
                  onChanged: (val) {
                    _username = val;
                  }),
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Email',
                  obscure: false,
                  onChanged: (val) {
                    _email = val;
                  }),
              SizedBox(height: 10.0),
              CustomTextField(
                  hint: 'Password',
                  obscure: true,
                  onChanged: (val) {
                    _password = val;
                  }),
              SizedBox(height: 10.0),
              CustomElevatedButton(
                text: 'REGISTER',
                onPressed: () {
                  BlocProvider.of<AuthApiCubit>(context).register(_username, _email, _password);
                },
              ),
              SizedBox(height: 10.0),
              CustomRichText(
                text: 'Already have an account?',
                linkText: 'Login',
                onTap: () {
                  _controller.previousPage(
                      duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
              ),
            ],
          ),
        ),
      );
}
