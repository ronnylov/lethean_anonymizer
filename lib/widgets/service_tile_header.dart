/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/exit_node_service.dart';

class ServiceTileHeader extends StatelessWidget {
  const ServiceTileHeader({
    Key key,
    ExitNodeService service,
    Widget badge,
  })  : _service = service,
        _badge = badge,
        super(key: key);

  final ExitNodeService _service;
  final Widget _badge;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      textColor: Colors.white70,
      child: ListTile(
        dense: false,
        isThreeLine: true,
        leading: _badge,
        title: Text(
          _service.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 55,
                  child: const Text('Stability'),
                ),
                _service.mStability != null
                    ? RatingBarIndicator(
                        rating: _service.mStability,
                        itemCount: 5,
                        itemSize: 14,
                        direction: Axis.horizontal,
                        itemBuilder: (ctx, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      )
                    : Text(
                        'No rating',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                        ),
                      ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 55,
                  child: const Text('Speed'),
                ),
                _service.mSpeed != null
                    ? RatingBarIndicator(
                        rating: _service.mSpeed,
                        itemCount: 5,
                        itemSize: 14,
                        direction: Axis.horizontal,
                        itemBuilder: (ctx, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      )
                    : Text(
                        'No rating',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2.color,
                        ),
                      ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 55,
                  child: const Text('Price'),
                ),
                Text(
                  '${_service.cost} LTHN / min',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
