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
    return ListTile(
      dense: false,
      isThreeLine: true,
      leading: _badge,
      title: Text(
        _service.name,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Stability '),
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
                      : const Text('No rating'),
                ],
              ),
              Text('${_service.cost} LTHN / min')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text('Speed'),
                  const SizedBox(
                    width: 15,
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
                      : const Text('No rating'),
                ],
              ),
              Text('${(_service.downloadSpeed ~/ 1000000)} Mbit / s')
            ],
          ),
        ],
      ),
    );
  }
}
