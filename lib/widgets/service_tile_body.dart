/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exit_node_service.dart';
import '../providers/exit_node_providers.dart';

class ServiceTileBody extends StatefulWidget {
  const ServiceTileBody({
    Key key,
    ExitNodeService service,
  })  : _service = service,
        super(key: key);

  final ExitNodeService _service;

  @override
  _ServiceTileBodyState createState() => _ServiceTileBodyState();
}

class _ServiceTileBodyState extends State<ServiceTileBody> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Divider(thickness: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('1st PrePaid Mins'),
              Text(
                  '${widget._service.firstPrePaidMinutes * widget._service.cost} LTHN / ' +
                      '${widget._service.firstPrePaidMinutes} mins'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Additional Mins'),
              Text(
                  '${widget._service.subsequentPrePaidMinutes * widget._service.cost} LTHN / ' +
                      '${widget._service.subsequentPrePaidMinutes} mins'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Download Speed'),
              Text('${widget._service.downloadSpeed ~/ 1000000} Mbit / s'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Upload Speed'),
              Text('${widget._service.uploadSpeed ~/ 1000000} Mbit / s'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Endpoint'),
              SelectableText(widget._service.proxyEndpoint != null
                  ? '${widget._service.proxyEndpoint}'
                  : widget._service.vpnEndpoint != null
                      ? '${widget._service.vpnEndpoint}'
                      : ''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Port'),
              SelectableText(widget._service.proxyPort != null
                  ? '${widget._service.proxyPort}'
                  : widget._service.vpnPort != null
                      ? '${widget._service.vpnPort}'
                      : ''),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Provider Id'),
          SelectableText('${widget._service.providerId}'),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Service Id'),
              SelectableText('${widget._service.id}'),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Provider Wallet Address'),
          SelectableText('${widget._service.providerWallet}'),
          const SizedBox(height: 14),
          const Divider(thickness: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Payment Id'),
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      final newPaymentId =
                          ExitNodeService.generatePaymentId(widget._service.id);
                      Provider.of<ExitNodeProviders>(context, listen: false)
                          .setPaymentId(
                        widget._service.providerId,
                        widget._service.id,
                        newPaymentId,
                      );
                    });
                  }),
              SelectableText('${widget._service.paymentId}'),
            ],
          ),
          const Divider(thickness: 2.0),
          const Text(
              'For privacy reasons it is recommended to refresh Payment Id before making a new VPN connection.'),
          const SizedBox(height: 14),
          // const Text('First Payment'),
          // const SizedBox(height: 14),
        ],
      ),
    );
  }
}
