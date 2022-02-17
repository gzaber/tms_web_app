//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/user_model.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/helpers/members_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_icon_button.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  AuthApiCubit authApiCubit;

  @override
  void initState() {
    authApiCubit = BlocProvider.of<AuthApiCubit>(context);
    authApiCubit.getAllUsers(BlocProvider.of<AuthDataCubit>(context).state.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MembersCubit membersCubit = BlocProvider.of<MembersCubit>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: UIHelper.customBorderRadius,
        border: Border.all(color: UIHelper.themeColor),
      ),
      child: Column(
        children: [
          Container(
            height: UIHelper.barHeight,
            color: UIHelper.themeColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'MEMBERS',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.add,
                  iconColor: Colors.white,
                  onPressed: _addUserDialog,
                ),
              ],
            ),
          ),
          Container(
            height: 250.0,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              itemCount: membersCubit.state.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(membersCubit.state[index]),
                    leading: Icon(Icons.person),
                    trailing: InkWell(
                      child: Icon(Icons.delete),
                      onTap: () {
                        setState(() {
                          List<String> members = membersCubit.state;
                          members.removeAt(index);
                          membersCubit.update(members);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _addUserDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Add a user'),
            content: BlocBuilder<AuthApiCubit, AuthApiState>(
              bloc: authApiCubit,
              builder: (_, state) {
                if (state is AuthApiLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is AuthApiLoadUserListSuccess) {
                  return _showDialogContent(state.users);
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
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _showDialogContent(List<UserModel> users) {
    MembersCubit membersCubit = BlocProvider.of<MembersCubit>(context);
    List<String> _usernames = users.map((userModel) => userModel.username).toList();
    List<String> _availableUsers = _usernames
        .where((element) => !BlocProvider.of<MembersCubit>(context).state.contains(element))
        .toList();

    return Container(
      width: 200.0,
      height: 300.0,
      child: _availableUsers.length > 0
          ? ListView.builder(
              itemCount: _availableUsers.length,
              itemBuilder: (_, index) {
                return InkWell(
                  child: ListTile(
                    title: Text(_availableUsers[index]),
                    leading: Icon(Icons.person),
                  ),
                  onTap: () {
                    setState(() {
                      List<String> members = membersCubit.state;
                      members.add(_availableUsers[index]);
                      membersCubit.update(members);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            )
          : Center(
              child: Text(
                'No available users',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
    );
  }
}
