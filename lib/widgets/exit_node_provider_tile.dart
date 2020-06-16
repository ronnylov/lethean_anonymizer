/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

import '../models/exit_node_provider.dart';
import '../screens/services_list_screen.dart';

class ExitNodeProviderTile extends StatelessWidget {
  const ExitNodeProviderTile({
    Key key,
    @required ExitNodeProvider currentNode,
  })  : _currentNode = currentNode,
        super(key: key);

  final ExitNodeProvider _currentNode;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(_currentNode.id),
      child: ListTile(
        // Country is not required so better check if set
        leading: _currentNode.country == null
            ? const SizedBox(
                width: 60,
                height: 40,
                child: const Icon(
                  Icons.help_outline,
                  size: 40,
                ),
              )
            : Flag(
                _currentNode.country.code,
                width: 60.0,
                height: 40.0,
                fit: BoxFit.cover,
              ),
        title: Text(
          _currentNode.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        // Country is not required so better check if set
        subtitle: _currentNode.country == null
            ? Text(
                'Unknown Country',
                style: Theme.of(context).textTheme.subtitle1,
              )
            : Text(
                '${_currentNode.country.name} ' +
                    '${_currentNode.country.code}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(
            context,
            ServicesListScreen.routeName,
            arguments: _currentNode,
          );
        },
      ),
      elevation: 4,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
