/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exit_node_service.dart';
import '../providers/exit_node_providers.dart';
import '../screens/vpn_instruction_screen.dart';

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
      padding: const EdgeInsets.only(
        bottom: 16.0,
        top: 0.0,
        right: 28.0,
        left: 20.0,
      ),
      width: double.infinity,
      child: Consumer<ExitNodeProviders>(
        // Normally a consumer would use the data in builder
        // (providers below) but here we just use it to rebuild widgets
        // when the original data is changed.
        // Most likely when provider id refresh button is pressed.
        // But also if new data arrives from sdp server.
        builder: (ctx, providers, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const Divider(thickness: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '1st PrePaid Mins',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text('${_service.firstPrePaidMinutes * _service.cost} LTHN / ' +
                    '${_service.firstPrePaidMinutes} mins'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Additional Mins',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                    '${_service.subsequentPrePaidMinutes * _service.cost} LTHN / ' +
                        '${_service.subsequentPrePaidMinutes} mins'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Download Speed',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text('${_service.downloadSpeed ~/ 1000000} Mbit / s'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Upload Speed',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text('${_service.uploadSpeed ~/ 1000000} Mbit / s'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Endpoint',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
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
                Text(
                  'Port',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SelectableText(_service.proxyPort != null
                    ? '${_service.proxyPort}'
                    : _service.vpnPort != null ? '${_service.vpnPort}' : ''),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Provider Id',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SelectableText('${_service.providerId}'),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Service Id',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SelectableText('${_service.id}'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Provider Wallet Address',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SelectableText('${_service.providerWallet}'),
            const SizedBox(height: 14),
            // const Divider(thickness: 2.0),
            if (_service.vpnEndpoint != null && _service.vpnPort != null)
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).accentIconTheme.color,
                  ),
                  title: Text(
                    'How to use this VPN',
                    style: Theme.of(context).accentTextTheme.button,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).accentIconTheme.color,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      VpnInstructionScreen.routeName,
                      arguments: _service,
                    );
                  },
                ),
                color: Theme.of(context).accentColor,
                elevation: 2,
              ),
            if (_service.proxyEndpoint != null && _service.proxyPort != null)
              Text(
                'Lethean Proxy is not supported on mobile devices.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
          ],
        ),
      ),
    );
  }
}
