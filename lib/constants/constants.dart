import 'package:flutter/material.dart';

const primaryColor = Color(0xFFF9F8F9);
const secondaryColor = Color(0xFFF0D2B2);
const bgColor = Color(0xFFF7E0EB);

const buttonColor = Color(0xFFAC115E);
const ConnectingColor = Color(0xFFAC115E);
const appbarColor = Color(0xFFAC115E);
const clickedListTileColor = Color(0xFFE7E5E7);
const checkBoxColor =  Color(0xFFAC115E);


const String ConnectionsBoxName="CONNECTIONS";
const double TextBoxRadius = 5;
const double TextBoxHeight = 45;
const TextFieldColour = Colors.black12;

const String MQTT = 'MQTT';
const String HTTP = 'HTTP';
const String TCP = 'TCP';
const String CoAP = 'CoAP';

enum SingingCharacter { event, action, createDevice, createScene, device }

enum TcpConnectionStates { connected, disconnected, connecting }

enum ApiSceneActionCharacter  {device , global}