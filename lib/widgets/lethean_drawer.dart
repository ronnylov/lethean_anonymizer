import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/providers_list_screen.dart';

class LetheanDrawer extends StatelessWidget {
  const LetheanDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(),
              // const Text(
              //   'Anonymizer',
              //   style: TextStyle(color: LetheanColors.lthnlightblue),
              // ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage("assets/images/lethean-shield-logo-wide.png"),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
              // color: LetheanColors.lthnblue,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              // Go to default screen.
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ProviderListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              // Information about app.
              showAboutDialog(context: context);
            },
          ),
          if (!Platform.isIOS)
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Exit',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () {
                // Not allowed on iOS - app will be rejected by Apple if trying.
                Navigator.pop(context);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
        ],
      ),
      // ),
    );
  }
}
