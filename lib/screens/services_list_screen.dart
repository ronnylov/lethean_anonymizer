/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';

import '../models/exit_node_provider.dart';

class ServicesListScreen extends StatelessWidget {
  static const routeName = '/services-list';

  @override
  Widget build(BuildContext context) {
    final ExitNodeProvider exitNode = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(title: Text('${exitNode.name} services'),),
    );
  }
}