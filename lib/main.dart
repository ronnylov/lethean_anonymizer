/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/exit_node_providers.dart';
import './screens/providers_list_screen.dart';
import './screens/services_list_screen.dart';
import './screens/vpn_instruction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExitNodeProviders(),
      child: MaterialApp(
        title: 'Lethean VPN',
        theme: ThemeData(
          scaffoldBackgroundColor: lthnbackground,
          // primarySwatch: Colors.deepPurple,
          primarySwatch: lthnbluegreen,
          // accentColor: Colors.cyan,
          accentColor: lthnblue,
          // cardColor: Colors.blueGrey[700],
          cardColor: lthndarkbluegreen[900],
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProviderListScreen(),
        routes: {
          ServicesListScreen.routeName: (ctx) => ServicesListScreen(),
          VpnInstructionScreen.routeName: (ctx) => VpnInstructionScreen(),
        },
      ),
    );
  }
}

const MaterialColor lthnblue = MaterialColor(_lthnbluePrimaryValue, <int, Color>{
  50: Color(0xFFE6FAFB),
  100: Color(0xFFC1F4F5),
  200: Color(0xFF98ECEF),
  300: Color(0xFF6EE4E9),
  400: Color(0xFF4FDFE4),
  500: Color(_lthnbluePrimaryValue),
  600: Color(0xFF2BD5DB),
  700: Color(0xFF24CFD7),
  800: Color(0xFF1ECAD2),
  900: Color(0xFF13C0CA),
});
const int _lthnbluePrimaryValue = 0xFF30D9DF;

const MaterialColor lthnblueAccent = MaterialColor(_lthnblueAccentValue, <int, Color>{
  100: Color(0xFFFAFFFF),
  200: Color(_lthnblueAccentValue),
  400: Color(0xFF94F9FF),
  700: Color(0xFF7AF7FF),
});
const int _lthnblueAccentValue = 0xFFC7FCFF;

const MaterialColor lthnbackground = MaterialColor(_lthnbackgroundPrimaryValue, <int, Color>{
  50: Color(0xFFE3E4E6),
  100: Color(0xFFBABCC0),
  200: Color(0xFF8C9096),
  300: Color(0xFF5D636C),
  400: Color(0xFF3B414D),
  500: Color(_lthnbackgroundPrimaryValue),
  600: Color(0xFF151C28),
  700: Color(0xFF111822),
  800: Color(0xFF0E131C),
  900: Color(0xFF080B11),
});
const int _lthnbackgroundPrimaryValue = 0xFF18202D;

const MaterialColor lthnbackgroundAccent = MaterialColor(_lthnbackgroundAccentValue, <int, Color>{
  100: Color(0xFF5498FF),
  200: Color(_lthnbackgroundAccentValue),
  400: Color(0xFF005FED),
  700: Color(0xFF0055D4),
});
const int _lthnbackgroundAccentValue = 0xFF217AFF;

const MaterialColor lthnbluegreen = MaterialColor(_lthnbluegreenPrimaryValue, <int, Color>{
  50: Color(0xFFE2F8F8),
  100: Color(0xFFB6EFEE),
  200: Color(0xFF86E4E3),
  300: Color(0xFF56D9D7),
  400: Color(0xFF31D0CF),
  500: Color(_lthnbluegreenPrimaryValue),
  600: Color(0xFF0BC2C0),
  700: Color(0xFF09BBB9),
  800: Color(0xFF07B4B1),
  900: Color(0xFF03A7A4),
});
const int _lthnbluegreenPrimaryValue = 0xFF0DC8C6;

const MaterialColor lthnbluegreenAccent = MaterialColor(_lthnbluegreenAccentValue, <int, Color>{
  100: Color(0xFFD1FFFE),
  200: Color(_lthnbluegreenAccentValue),
  400: Color(0xFF6BFFFC),
  700: Color(0xFF52FFFC),
});
const int _lthnbluegreenAccentValue = 0xFF9EFFFD;

const MaterialColor lthnlightblue = MaterialColor(_lthnlightbluePrimaryValue, <int, Color>{
  50: Color(0xFFF5FBFB),
  100: Color(0xFFE6F5F6),
  200: Color(0xFFD5EFF0),
  300: Color(0xFFC4E8E9),
  400: Color(0xFFB8E3E5),
  500: Color(_lthnlightbluePrimaryValue),
  600: Color(0xFFA4DADC),
  700: Color(0xFF9AD5D8),
  800: Color(0xFF91D1D3),
  900: Color(0xFF80C8CB),
});
const int _lthnlightbluePrimaryValue = 0xFFABDEE0;

const MaterialColor lthnlightblueAccent = MaterialColor(_lthnlightblueAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_lthnlightblueAccentValue),
  400: Color(0xFFEEFEFF),
  700: Color(0xFFD4FDFF),
});
const int _lthnlightblueAccentValue = 0xFFFFFFFF;

const MaterialColor lthndarkbluegreen = MaterialColor(_lthndarkbluegreenPrimaryValue, <int, Color>{
  50: Color(0xFFE5F0F1),
  100: Color(0xFFBEDADB),
  200: Color(0xFF92C2C3),
  300: Color(0xFF66A9AB),
  400: Color(0xFF469699),
  500: Color(_lthndarkbluegreenPrimaryValue),
  600: Color(0xFF217C7F),
  700: Color(0xFF1B7174),
  800: Color(0xFF16676A),
  900: Color(0xFF0D5457),
});
const int _lthndarkbluegreenPrimaryValue = 0xFF258487;

const MaterialColor lthndarkbluegreenAccent = MaterialColor(_lthndarkbluegreenAccentValue, <int, Color>{
  100: Color(0xFF8DFAFF),
  200: Color(_lthndarkbluegreenAccentValue),
  400: Color(0xFF27F5FF),
  700: Color(0xFF0EF4FF),
});
const int _lthndarkbluegreenAccentValue = 0xFF5AF8FF;
