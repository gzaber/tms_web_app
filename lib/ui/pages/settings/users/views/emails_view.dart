//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/models/email_model.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class EmailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsCubit settingsCubit = BlocProvider.of<SettingsCubit>(context);
    AuthApiCubit authApiCubit = BlocProvider.of<AuthApiCubit>(context);
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    settingsCubit.hideForm();
    authApiCubit.getAllEmails(authDataCubit.state.token);

    return BlocBuilder<AuthApiCubit, AuthApiState>(
      builder: (_, state) {
        if (state is AuthApiLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AuthApiLoadEmailListSuccess) {
          return _buildEmailsList(settingsCubit, state.emails);
        }
        if (state is AuthApiActionSuccess) {
          settingsCubit.hideForm();
          authApiCubit.getAllEmails(authDataCubit.state.token);
        }
        if (state is AuthApiActionFailure) {
          authApiCubit.getAllEmails(authDataCubit.state.token);
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

  Padding _buildEmailsList(SettingsCubit settingsCubit, List<EmailModel> emails) {
    ScrollController _scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CustomElevatedButton(
              text: 'NEW',
              onPressed: () {
                settingsCubit.showAddEmailForm();
              },
            ),
          ),
          SizedBox(height: 5.0),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: emails.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text(emails[index].email),
                    subtitle: Text(emails[index].role),
                    onTap: () {
                      settingsCubit.showEmailForm(emails[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
