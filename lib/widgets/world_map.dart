/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class WorldMap extends StatelessWidget {
  const WorldMap({
    Key key,
    @required List<Marker> mapMarkers,
  })  : _mapMarkers = mapMarkers,
        super(key: key);

  final List<Marker> _mapMarkers;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(6.0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(30.00, 0.00),
                zoom: 1.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: _mapMarkers),
              ],
            ),
          ),
        ),
        FlatButton(
          textTheme: ButtonTextTheme.accent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 0.0,
          ),
          onPressed: () async {
            const url = 'https://www.openstreetmap.org/copyright';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text('© OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
