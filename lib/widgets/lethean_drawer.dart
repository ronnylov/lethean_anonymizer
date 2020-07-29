import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lethean_anonymizer/widgets/lethean_colors.dart';

import '../screens/providers_list_screen.dart';

class LetheanDrawer extends StatelessWidget {
  const LetheanDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.alphaBlend(
                LetheanColors.guidebluegreen.withAlpha(150),
                LetheanColors.guidedarkgray,
              ),
              Color.alphaBlend(
                LetheanColors.guidebluegreen.withAlpha(10),
                LetheanColors.guidedarkgray,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                color: LetheanColors.guidedarkgray.withAlpha(190),
                image: DecorationImage(
                    image: AssetImage("assets/splash/lethean-splash.png"),
                    fit: BoxFit.contain),
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
      ),
      // ),
    );
  }
}
