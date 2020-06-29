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
          elevation: 4.0,
          margin: EdgeInsets.all(6.0),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              top: 16.0,
              right: 20.0,
              left: 20.0,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Save OpenVPN Configuration File',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.save),
                          onPressed: () async {
                            var template = await DefaultAssetBundle.of(context)
                                .loadString(
                                    'assets/openvpn_client_template.txt');
                            template = template.replaceAll(
                                '{ip}', '${_service.vpnEndpoint}');
                            template = template.replaceAll(
                                '{port}', '${_service.vpnPort.split('/')[0]}');
                            template = template.replaceAll('{proto}',
                                '${_service.vpnPort.split('/')[1].toLowerCase()}');
                            template = template.replaceAll('{tundev}', 'tun1');
                            template = template.replaceAll('{comment_dn}', '');
                            template = template.replaceAll(
                                '{tunnode}', '/dev/net/tun');
                            template = template.replaceAll('{mtu}', '1400');
                            template = template.replaceAll('{mssfix}', '1300');
                            template = template.replaceAll(
                                '{auth_file}', ''); // We could use this!
                            template =
                                template.replaceAll('{pull_filters}', '');
                            template =
                                template.replaceAll('{mgmt_comment}', '');
                            template = template.replaceAll(
                                '{mgmt_sock}', '127.0.0.1 11193');
                            template =
                                template.replaceAll('{hproxy_comment}', '#');
                            template = template.replaceAll('{http_proxy}', '');
                            template =
                                template.replaceAll('{http_proxy_port}', '');
                            template =
                                template.replaceAll('{comment_syslog}', '');
                            template = template.replaceAll('{rgw_comment}', '');
                            template =
                                template.replaceAll('{bdns_comment}', '#');
                            template = template.replaceAll('{f_ca}',
                                '${utf8.decode(base64.decode(_service.providerCertContent))}');
                            print(template);
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(thickness: 2.0),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Payment Id',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    SelectableText(
                      '${_service.paymentId}',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            final newPaymentId =
                                ExitNodeService.generatePaymentId(_service.id);
                            Provider.of<ExitNodeProviders>(context,
                                    listen: false)
                                .setPaymentId(
                              _service.providerId,
                              _service.id,
                              newPaymentId,
                            );
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                    'For privacy reasons it is recommended to refresh Payment Id' +
                        ' before making a new VPN connection.'),
                const SizedBox(height: 14),
                const Divider(thickness: 2.0),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
