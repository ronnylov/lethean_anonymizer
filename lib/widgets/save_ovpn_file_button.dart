/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
// import 'package:path_provider/path_provider.dart';

import '../models/exit_node_service.dart';

class SaveOvpnFileButton extends StatelessWidget {
  const SaveOvpnFileButton({
    Key key,
    @required ExitNodeService service,
  })  : _service = service,
        super(key: key);

  final ExitNodeService _service;

  String _convertOvpnTemplate(
    String template,
    ExitNodeService service,
    String authFile,
  ) {
    template = template.replaceAll('{ip}', '${service.vpnEndpoint}');
    template =
        template.replaceAll('{port}', '${service.vpnPort.split('/')[0]}');
    template = template.replaceAll(
        '{proto}', '${service.vpnPort.split('/')[1].toLowerCase()}');
    template = template.replaceAll('{tundev}', 'tun1');
    template = template.replaceAll('{comment_dn}', '');
    template = template.replaceAll('{tunnode}', '/dev/net/tun');
    template = template.replaceAll('{mtu}', '1400');
    template = template.replaceAll('{mssfix}', '1300');
    template = template.replaceAll('{auth_file}', authFile);
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
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.save),
          onPressed: () async {
            var template = await DefaultAssetBundle.of(context)
                .loadString('assets/openvpn_client_template.txt');
             // Replace '' with authfile path below
            template = _convertOvpnTemplate(template, _service, '');
            var status = await Permission.storage.request();
            final extDir = await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_DOWNLOADS);
            if (status == PermissionStatus.granted) {
              var filePath = path.join(
                  extDir, _service.providerName + '_' + _service.id + '.ovpn');
              filePath = filePath.trim().replaceAll(' ', '_');
              final ovpnFile = File(filePath);
              await ovpnFile.writeAsString(template, flush: true);
              await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text('OpenVPN configuration saved'),
                        content: Text('File path:\n${ovpnFile.path}'),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            }
          }),
    );
  }
}
