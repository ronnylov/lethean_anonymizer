/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';

import '../models/exit_node_provider.dart';
import '../models/exit_node_service.dart';
import '../widgets/vpn_badge.dart';
import '../widgets/proxy_badge.dart';
import '../widgets/service_tile_header.dart';
import '../widgets/service_tile_body.dart';

class ServicesListScreen extends StatefulWidget {
  static const routeName = '/services-list';

  @override
  _ServicesListScreenState createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  @override
  Widget build(BuildContext context) {
    final ExitNodeProvider _exitNode =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_exitNode.name} services'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: ExpansionPanelList.radio(
            children: _buildExpansionPanelRadioList(_exitNode),
          ),
        ),
      ),
    );
  }

  List<ExpansionPanel> _buildExpansionPanelRadioList(
      ExitNodeProvider _exitNode) {
    return [
      ...(_exitNode.vpnServices != null && _exitNode.vpnServices.isNotEmpty
          ? _exitNode.vpnServices
              .map<ExpansionPanelRadio>(
                (vpnService) => _expansionPanelRadioServiceDescription(
                  vpnService,
                  VpnBadge(),
                ),
              )
              .toList()
          : []),
      ...(_exitNode.proxyServices != null && _exitNode.proxyServices.isNotEmpty
          ? _exitNode.proxyServices
              .map<ExpansionPanelRadio>(
                (proxyService) => _expansionPanelRadioServiceDescription(
                  proxyService,
                  ProxyBadge(),
                ),
              )
              .toList()
          : [])
    ];
  }

  ExpansionPanelRadio _expansionPanelRadioServiceDescription(
    ExitNodeService service,
    Widget badge,
  ) {
    return ExpansionPanelRadio(
      value: service.id,
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => ServiceTileHeader(
        service: service,
        badge: badge,
      ),
      body: ServiceTileBody(
        service: service,
      ),
    );
  }
}

