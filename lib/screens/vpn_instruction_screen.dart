/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flag/flag.dart';

import '../providers/exit_node_providers.dart';
import '../models/exit_node_service.dart';
import '../widgets/service_tile_header.dart';
import '../widgets/vpn_badge.dart';

class VpnInstructionScreen extends StatelessWidget {
  static const routeName = '/vpn-instruction';

  String _convertOvpnTemplate(String template, ExitNodeService _service) {
    template = template.replaceAll('{ip}', '${_service.vpnEndpoint}');
    template =
        template.replaceAll('{port}', '${_service.vpnPort.split('/')[0]}');
    template = template.replaceAll(
        '{proto}', '${_service.vpnPort.split('/')[1].toLowerCase()}');
    template = template.replaceAll('{tundev}', 'tun1');
    template = template.replaceAll('{comment_dn}', '');
    template = template.replaceAll('{tunnode}', '/dev/net/tun');
    template = template.replaceAll('{mtu}', '1400');
    template = template.replaceAll('{mssfix}', '1300');
    template = template.replaceAll('{auth_file}', ''); // We could use this!
    template = template.replaceAll('{pull_filters}', '');
    template = template.replaceAll('{mgmt_comment}', '');
    template = template.replaceAll('{mgmt_sock}', '127.0.0.1 11193');
    template = template.replaceAll('{hproxy_comment}', '#');
    template = template.replaceAll('{http_proxy}', '');
    template = template.replaceAll('{http_proxy_port}', '');
    template = template.replaceAll('{comment_syslog}', '');
    template = template.replaceAll('{rgw_comment}', '');
    template = template.replaceAll('{bdns_comment}', '#');
    template = template.replaceAll('{f_ca}',
        '${utf8.decode(base64.decode(_service.providerCertContent))}');
    return template;
  }

  @override
  Widget build(BuildContext context) {
    final ExitNodeService _service = ModalRoute.of(context).settings.arguments;

    return Consumer<ExitNodeProviders>(builder: (ctx, provider, child) {
      final _exitNode =
          provider.providers.firstWhere((p) => p.id == _service.providerId);
      return Scaffold(
        appBar: AppBar(
          title: Text('${_service.name}'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Flag(
                      _exitNode.country.code,
                      width: 60.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      _service.providerName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      '${_exitNode.country.name} ' +
                          '${_exitNode.country.code}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    // trailing: const Icon(Icons.arrow_forward_ios),
                    // onTap: () {
                    //   Navigator.pushNamed(
                    //     context,
                    //     ServicesListScreen.routeName,
                    //     arguments: _currentNode,
                    //   );
                    // },
                  ),
                  ServiceTileHeader(
                    service: _service,
                    badge: VpnBadge(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Card(
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
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.save),
                                    onPressed: () async {
                                      var template = await DefaultAssetBundle
                                              .of(context)
                                          .loadString(
                                              'assets/openvpn_client_template.txt');
                                      template = _convertOvpnTemplate(
                                          template, _service);
                                      var status =
                                          await Permission.storage.request();
                                      final extDir = await ExtStorage
                                          .getExternalStoragePublicDirectory(
                                              ExtStorage.DIRECTORY_DOWNLOADS);
                                      if (status == PermissionStatus.granted) {
                                        var filePath = path.join(
                                            extDir,
                                            _service.providerName +
                                                '_' +
                                                _service.id +
                                                '.ovpn');
                                        filePath = filePath
                                            .trim()
                                            .replaceAll(' ', '_');
                                        final ovpnFile = File(filePath);
                                        await ovpnFile.writeAsString(template,
                                            flush: true);
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      'OpenVPN configuration saved'),
                                                  content: Text(
                                                      'File path:\n${ovpnFile.path}'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ));
                                      }
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text('Press save icon to save the OpenVPN configuration file' +
                              ' to Download directory. Then import this file to your OpenVPN app.' +
                              ' Verified to work with OpenVPN Connect and OpenVPN for Android.'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Payment Id',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              SelectableText(
                                '${_service.paymentId}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      final newPaymentId =
                                          ExitNodeService.generatePaymentId(
                                              _service.id);
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
                          Text(
                            'First Payment',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          Text('First payment of ${_service.cost * _service.firstPrePaidMinutes} LTHN' +
                              ' gets you ${_service.firstPrePaidMinutes}' +
                              ' minutes of VPN subscription. Payment is made by using Lethean' +
                              ' cryptocurrency LTHN. Payments are not yet implemented in this app.' +
                              ' You can use any official Lethean wallet to pay e.g. desktop GUI or CLI.'),
                          const SizedBox(height: 14),
                          const Text(
                              'Lethean command line wallet or Discord tipbot command format :\n' +
                                  'transfer <Address> <Amount> <Payment Id>'),
                          const SizedBox(height: 14),
                          SelectableText('transfer ${_service.providerWallet} ' +
                              '${_service.cost * _service.firstPrePaidMinutes} ' +
                              '${_service.paymentId}'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Text(
                            'Connect to VPN',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                              'Use the VPN profile that was created in the OpenVPN app ' +
                                  'when importing the file.' +
                                  ' You need to login with Payment Id :'),
                          const SizedBox(height: 14),
                          SelectableText('Username : ${_service.paymentId}'),
                          SelectableText('Password : ${_service.paymentId}'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Text(
                            'Additional Payments',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          Text('Additional payment of ${_service.cost * _service.subsequentPrePaidMinutes}' +
                              ' LTHN adds ${_service.subsequentPrePaidMinutes}' +
                              ' minutes to your VPN subscription.' +
                              ' Pay before previous subscription period ends. ' +
                              'Use the same Payment Id as used on first payment.'),
                          const SizedBox(height: 14),
                          SelectableText('transfer ${_service.providerWallet} ' +
                              '${_service.cost * _service.subsequentPrePaidMinutes} ' +
                              '${_service.paymentId}'),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
