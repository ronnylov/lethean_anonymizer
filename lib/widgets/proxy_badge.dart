/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';

class ProxyBadge extends StatelessWidget {
  const ProxyBadge({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 18.0,
          backgroundColor: Theme.of(context).accentColor,
          child: const Icon(
            Icons.lock_outline,
            size: 26.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'PROXY',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
