/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:lthn_vpn/models/exit-node-provider.dart';
import 'package:provider/provider.dart';

import '../providers/exit-node-providers.dart';
import '../widgets/exit-node-provider-tile.dart';

// These were used for testing detection of device external IP address
// When pressing floatingactionbutton
// import '../helpers/api_helpers.dart';
// import '../models/country.dart';

class ProviderListScreen extends StatefulWidget {
  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  Future<void> _refresh;
  List<ExitNodeProvider> _currentNodeList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh = Provider.of<ExitNodeProviders>(
      context,
      listen: false,
    ).fetchAndSetProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lethean VPN Exit Nodes'),
      ),
      body: Consumer<ExitNodeProviders>(
        builder: (ctx, exitNode, _) => FutureBuilder<void>(
          future: _refresh,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error has occured: ${snapshot.error}'),
              );
            } else {
              _currentNodeList = exitNode.providers;
              return _currentNodeList.isEmpty
                  ? Center(
                      child: const Text('No exit node available.'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView.builder(
                        itemCount: _currentNodeList.length,
                        itemBuilder: (context, index) => Card(
                          key: Key(_currentNodeList[index].id),
                          color: Colors.blueGrey[700],
                          child: ExitNodeProviderTile(currentNode: _currentNodeList[index]),
                          elevation: 4,
                          margin: const EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          setState(() {
            _refresh = Provider.of<ExitNodeProviders>(
              context,
              listen: false,
            ).fetchAndSetProviders();
          });

          // Some code for testing detecting internet location of the device
          // final myIp = await ApiHelpers.fetchMyIp();
          // final myCountryMap = await ApiHelpers.fetchCountryFromIp(myIp);
          // final myCountry = Country.fromJson(myCountryMap);
          // print('Country: ' + myCountry.name + ' ' + myCountry.code);
          // print('Latitude: ' + myCountry.latitude.toString());
          // print('Longitude: ' + myCountry.longitude.toString());
        },
      ),
    );
  }
}
