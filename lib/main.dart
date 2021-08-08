import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/Route/appRoute.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/checkPublishCubit.dart';
import 'package:iot_device_simulator/logic/mqttSubscribeCubit.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';
import 'logic/checkConCubit.dart';
import 'logic/connectionCubit.dart';
import 'logic/mqttConnectionCubit.dart';
import 'logic/protocolCubit.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(HiveConObjectAdapter());
 await Hive.openBox<HiveConObject>(ConnectionsBoxName);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter=AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider(
              create:(context)=>ProtocolCubit(),
          ),
          BlocProvider(
              create:(context) =>ConnectionCubit(),
          ),
          BlocProvider(
              create:(context) =>MqttConnectionCubit(),
          ),
          BlocProvider(
              create:(context)=>CheckConCubit(),
          ) ,
          BlocProvider(
              create:(context)=>CheckPublishCubit(),
          ) ,
          BlocProvider(
              create:(context)=>MqttSubscribeCubit(),
          ),
          BlocProvider(
              create:(context)=>AutomateCubit(),
          )
        ],

      child: MaterialApp(
        onGenerateRoute: _appRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          appBarTheme:AppBarTheme(backgroundColor:appbarColor),
          canvasColor:primaryColor,
          backgroundColor: bgColor,
          elevatedButtonTheme:ElevatedButtonThemeData(
            style:ElevatedButton.styleFrom(
              primary:buttonColor,

            )
          ),
          visualDensity:VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}


