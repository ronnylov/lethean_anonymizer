/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class WorldMap extends StatelessWidget {
  const WorldMap({
    Key key,
    @required List<Marker> mapMarkers,
  })  : _mapMarkers = mapMarkers,
        super(key: key);

  final List<Marker> _mapMarkers;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 1.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(markers: _mapMarkers
                // [
                //   Marker(
                //     width: 28.0,
                //     height: 28.0,
                //     point: LatLng(51.5, -0.09),
                //     builder: (ctx) => Container(
                //       child: Icon(
                //         Icons.home,
                //         color: Colors.red,
                //       ),
                //     ),
                //   ),
                // ],
                ),
          ],
        ),
      ),
    );
  }
}
