import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:iot_device_simulator/Route/appRoute.dart';
import 'package:iot_device_simulator/data/hiveConObject.dart';
import 'package:iot_device_simulator/logic/HTTP/HttpRepo.dart';
import 'package:iot_device_simulator/logic/HTTP/httpBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/MqttBloc.dart';
import 'package:iot_device_simulator/logic/MQTT/Repo/mqttRepo.dart';
import 'package:iot_device_simulator/logic/MQTT/randomDataCubit.dart';
import 'package:iot_device_simulator/logic/automateCubit.dart';
import 'package:iot_device_simulator/logic/MQTT/mqttSubscribeCubit.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';
import 'logic/connectionBloc.dart';
import 'logic/connectionCubit.dart';
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
              create:(context)=>AutomateCubit(),
          ) ,
          BlocProvider(
              create:(context)=>RandomDataCubit(),
          ) ,
          BlocProvider(
              create:(context)=>HttpBloc(HttpRepo()),
          ),
          BlocProvider(
              create:(context)=>MqttBloc(MqttRepo()),
          ),
          BlocProvider(
              create:(context)=>ConnetionBloc(new HiveConObject("","","","",0,"","",60)),
          ),
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
              scrollbarTheme: ScrollbarThemeData().copyWith(
    thumbColor: MaterialStateProperty.all(Colors.black38)),
          visualDensity:VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}


