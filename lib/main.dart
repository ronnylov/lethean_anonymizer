/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/exit_node_providers.dart';
import './screens/providers_list_screen.dart';
import './screens/services_list_screen.dart';

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
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.cyan,
          cardColor: Colors.blueGrey[700],
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProviderListScreen(),
        routes: {
          ServicesListScreen.routeName: (ctx) => ServicesListScreen(),
        },
      ),
    );
  }
}
