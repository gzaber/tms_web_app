//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tms_web_app/composition_root.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();

  runApp(
    BlocProvider(
      create: (context) => AuthDataCubit(),
      child: MyApp(CompositionRoot.composeAuthUI()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp(this.startPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMS',
      theme: ThemeData(
        primarySwatch: UIHelper.themeColor,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: startPage,
    );
  }
}
