/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/foundation.dart';

import './exit-node-service.dart';
import './country.dart';

class ExitNodeProvider {
  @required final String id;
  @required final String name;
  @required final String wallet;
  @required final String certContent;
  final List<ExitNodeService> proxyServices;
  final List<ExitNodeService> vpnServices;
  Country country;

  ExitNodeProvider({
    this.id,
    this.name,
    this.wallet,
    this.certContent,
    this.proxyServices,
    this.vpnServices,
    this.country
  });
}
