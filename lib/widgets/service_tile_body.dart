/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exit_node_service.dart';
import '../providers/exit_node_providers.dart';

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
            const Divider(thickness: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('1st PrePaid Mins'),
                Text('${_service.firstPrePaidMinutes * _service.cost} LTHN / ' +
                    '${_service.firstPrePaidMinutes} mins'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Additional Mins'),
                Text(
                    '${_service.subsequentPrePaidMinutes * _service.cost} LTHN / ' +
                        '${_service.subsequentPrePaidMinutes} mins'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Download Speed'),
                Text('${_service.downloadSpeed ~/ 1000000} Mbit / s'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Upload Speed'),
                Text('${_service.uploadSpeed ~/ 1000000} Mbit / s'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Endpoint'),
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
                const Text('Port'),
                SelectableText(_service.proxyPort != null
                    ? '${_service.proxyPort}'
                    : _service.vpnPort != null ? '${_service.vpnPort}' : ''),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Provider Id'),
            SelectableText('${_service.providerId}'),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Service Id'),
                SelectableText('${_service.id}'),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Provider Wallet Address'),
            SelectableText('${_service.providerWallet}'),
            const SizedBox(height: 14),
            const Divider(thickness: 2.0),
            if (_service.vpnEndpoint != null && _service.vpnPort != null)
              ...buildVpnInstructions(context),
            if (_service.proxyEndpoint != null && _service.proxyPort != null)
              Text('Lethean Proxy is not supported on mobile devices.'),
          ],
        ),
      ),
    );
  }

  List<Widget> buildVpnInstructions(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Payment Id'),
          CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.refresh),
                onPressed: () {
                  final newPaymentId =
                      ExitNodeService.generatePaymentId(_service.id);
                  Provider.of<ExitNodeProviders>(context, listen: false)
                      .setPaymentId(
                    _service.providerId,
                    _service.id,
                    newPaymentId,
                  );
                }),
          ),
          SelectableText('${_service.paymentId}'),
        ],
      ),
      const Divider(thickness: 2.0),
      const Text(
          'For privacy reasons it is recommended to refresh Payment Id before making a new VPN connection.'),
      const SizedBox(height: 14),
      // const Text('First Payment'),
      // const SizedBox(height: 14),
    ];
  }
}
