/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

import '../models/country.dart';
import '../models/exit_node_service.dart';
import '../widgets/vpn_badge.dart';
import '../widgets/service_tile_header.dart';

class VpnInstructionHeader extends StatelessWidget {
  const VpnInstructionHeader({
    Key key,
    @required Country country,
    @required ExitNodeService service,
  })  : _country = country,
        _service = service,
        super(key: key);

  final Country _country;
  final ExitNodeService _service;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          ListTile(
            // Country is not required so better check if set
            leading: _country == null
                ? const SizedBox(
                    width: 60,
                    height: 40,
                    child: const Icon(
                      Icons.help_outline,
                      size: 40,
                    ),
                  )
                : Flag(
                    _country.code,
                    width: 60.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
            title: Text(
              _service.providerName,
              style: Theme.of(context).textTheme.headline6,
            ),
            // Country is not required so better check if set
            subtitle: _country == null
                ? Text(
                    'Unknown Country',
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                : Text(
                    '${_country.name} ' + '${_country.code}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
            trailing: null,
          ),
          ServiceTileHeader(
            service: _service,
            badge: VpnBadge(),
          ),
        ],
      ),
    );
  }
}
