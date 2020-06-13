/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:lthn_vpn/models/exit_node_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';

import '../providers/exit_node_providers.dart';
import '../widgets/exit_node_provider_tile.dart';
import '../widgets/world_map.dart';

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
  final List<Marker> _markers = [];

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
                  : Column(
                      children: <Widget>[
                        WorldMap(
                          mapMarkers: _markers,
                        ),
                        SizedBox(
                          height: 6,
                        ), // Add some vertical spacing
                        Expanded(
                          // Was necessary to wrap this in Expanded
                          // to avoid error in Column
                          child: ListView.builder(
                            itemCount: _currentNodeList.length,
                            itemBuilder: (context, index) =>
                                ExitNodeProviderTile(
                                    currentNode: _currentNodeList[index]),
                          ),
                        ),
                      ],
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


// Commented code below is left there to be moved somewhere else.
// Don't want to loose the code but not yet decided where to use it.
// Map markers creted by country locations.

// Create markers for usage on the WorldMap from stored countries.
// Only one marker per country even if more exit nodes in a country.
// _providers.forEach((provider) {
//   _markers.firstWhere(
//         (marker) =>
//             marker.point ==
//             LatLng(provider.country.latitude, provider.country.longitude),
//         orElse: () {
//           // There was no marker already for this provider country.
//           // So let's add a new marker on the list pointing to this new country.
//           // But only if a country is set (country is optional)
//           if (provider.country != null) {
//             final marker = Marker(
//               point:
//                   LatLng(provider.country.latitude, provider.country.longitude),
//               height: 28,
//               width: 28,
//               builder: (context) => Container(
//                 child: Icon(
//                   Icons.location_on,
//                   color: Colors.lightBlue,
//                 ),
//               ),
//             );
//             _markers.add(marker);
//             print('Marker added');
//             notifyListeners();
//             return marker;
//           } else {
//             return null;
//           }
//         },
//       );
//     });
