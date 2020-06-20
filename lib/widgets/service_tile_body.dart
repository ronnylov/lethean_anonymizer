/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';

import '../models/exit_node_service.dart';

class ServiceTileBody extends StatelessWidget {
  const ServiceTileBody({
    Key key,
    ExitNodeService service,
  })  : _service = service,
        super(key: key);

  final ExitNodeService _service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16.0,
        top: 0.0,
        right: 28.0,
        left: 20.0,
      ),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('1st PrePaid Mins'),
              Text('${_service.firstPrePaidMinutes * _service.cost} LTHN / ' +
                  '${_service.firstPrePaidMinutes} mins'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Additional Mins'),
              Text(
                  '${_service.subsequentPrePaidMinutes * _service.cost} LTHN / ' +
                      '${_service.subsequentPrePaidMinutes} mins'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Endpoint'),
              SelectableText(_service.proxyEndpoint != null
                  ? '${_service.proxyEndpoint}'
                  : _service.vpnEndpoint != null
                      ? '${_service.vpnEndpoint}'
                      : ''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Port'),
              SelectableText(_service.proxyPort != null
                  ? '${_service.proxyPort}'
                  : _service.vpnPort != null
                      ? '${_service.vpnPort}'
                      : ''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Service Id'),
              SelectableText('${_service.id}'),
            ],
          ),
          SizedBox(height: 14),
          Text('Provider Id\n${_service.providerId}'),
          SizedBox(height: 14),
          SelectableText('Provider Wallet Address\n${_service.providerWallet}'),
        ],
      ),
    );
  }
}
