/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exit_node_providers.dart';

import '../models/exit_node_service.dart';

class VpnInstructionScreen extends StatelessWidget {
  static const routeName = '/vpn-instruction';

  @override
  Widget build(BuildContext context) {
    final ExitNodeService _service = ModalRoute.of(context).settings.arguments;

    return Consumer<ExitNodeProviders>(
      builder: (ctx, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text('${_service.name}'),
        ),
        body: Card(
          margin: EdgeInsets.all(6.0),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              top: 16.0,
              right: 20.0,
              left: 20.0,
            ),
            width: double.infinity,
            child: Column(children: [
              Container(
                width: double.infinity,
                child: RaisedButton.icon(
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () async {
                    var template = await DefaultAssetBundle.of(context)
                        .loadString('assets/openvpn_client_template.txt');
                    final String replaced =
                        template.replaceAll('{ip}', '${_service.vpnEndpoint}');
                    print(replaced);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save OpenVPN Configuration File'),
                ),
              ),
              const Divider(thickness: 2.0),
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
              // const Text('Decoded CA'),
              // SelectableText(
              //   utf8.decode(
              //     base64.decode(_service.providerCertContent),
              //   ),
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}
