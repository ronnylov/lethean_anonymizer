/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';

import '../models/exit_node_provider.dart';

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

  List<ExpansionPanel> _buildExpansionPanelRadioList(ExitNodeProvider _exitNode) {
    return [...(_exitNode.vpnServices != null && _exitNode.vpnServices.isNotEmpty
              ? _exitNode.vpnServices
                  .map<ExpansionPanelRadio>(
                    (vpnService) => ExpansionPanelRadio(
                      value: vpnService.id,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) => ListTile(
                        leading: Card(
                          color: Colors.lightBlue,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                            child: Text('VPN', style: Theme.of(context).accentTextTheme.subtitle1,),
                          ),
                        ),
                        title: Text(
                          vpnService.name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      body: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0,
                          top: 0.0,
                          right: 20.0,
                          left: 20.0,
                        ),
                        width: double.infinity,
                        child: Text('Body'),
                      ),
                    ),
                  )
                  .toList()
              : []), ...(_exitNode.proxyServices != null && _exitNode.proxyServices.isNotEmpty
              ? _exitNode.proxyServices
                  .map<ExpansionPanelRadio>(
                    (proxyService) => ExpansionPanelRadio(
                      value: proxyService.id,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) => ListTile(
                        leading: Card(
                          color: Colors.lightGreen,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                            child: Text('Proxy', style: Theme.of(context).accentTextTheme.subtitle1,),
                          ),
                        ),
                        title: Text(
                          proxyService.name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      body: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0,
                          top: 0.0,
                          right: 20.0,
                          left: 20.0,
                        ),
                        width: double.infinity,
                        child: Text('Body'),
                      ),
                    ),
                  )
                  .toList()
              : [])];
  }
}
