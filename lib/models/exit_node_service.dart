/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:math' show Random;

import 'package:flutter/foundation.dart';

class ExitNodeService {
  @required
  final String id;
  @required
  final String providerId;
  @required
  final String providerName;
  @required
  final String providerWallet;
  @required
  final String providerCertContent;
  final String name;
  final String type;
  @required
  final double cost;
  @required
  final int firstPrePaidMinutes;
  @required
  final int firstVerificationsNeeded;
  @required
  final int subsequentPrePaidMinutes;
  @required
  final int subsequentVerificationsNeeded;
  final int downloadSpeed;
  final int uploadSpeed;
  final String proxyPort;
  final String proxyEndpoint;
  final String vpnPort;
  final String vpnEndpoint;
  final double mSpeed;
  final double mStability;
  @required
  final bool disable;
  String paymentId;

  ExitNodeService(
      {this.id,
      this.providerId,
      this.providerName,
      this.providerWallet,
      this.providerCertContent,
      this.name,
      this.type,
      this.cost,
      this.firstPrePaidMinutes,
      this.firstVerificationsNeeded,
      this.subsequentPrePaidMinutes,
      this.subsequentVerificationsNeeded,
      this.downloadSpeed,
      this.uploadSpeed,
      this.proxyPort,
      this.proxyEndpoint,
      this.vpnPort,
      this.vpnEndpoint,
      this.mSpeed,
      this.mStability,
      this.disable,
      this.paymentId});

  ExitNodeService.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        paymentId = generatePaymentId(jsonMap['id']),
        providerId = jsonMap['provider'],
        providerName = jsonMap['providerName'],
        providerWallet = jsonMap['providerWallet'],
        providerCertContent = jsonMap['certArray'][0]['certContent'],
        name = jsonMap['name'],
        type = jsonMap['type'],
        cost = double.parse(jsonMap['cost']),
        firstPrePaidMinutes = jsonMap['firstPrePaidMinutes'],
        firstVerificationsNeeded = jsonMap['firstVerificationsNeeded'],
        subsequentPrePaidMinutes = jsonMap['subsequentPrePaidMinutes'],
        subsequentVerificationsNeeded =
            jsonMap['subsequentVerificationsNeeded'],
        downloadSpeed = jsonMap['downloadSpeed'],
        uploadSpeed = jsonMap['uploadSpeed'],
        proxyPort = (jsonMap['proxy'] as List).isNotEmpty
            ? jsonMap['proxy'][0]['port']
            : null,
        proxyEndpoint = (jsonMap['proxy'] as List).isNotEmpty
            ? jsonMap['proxy'][0]['endpoint']
            : null,
        vpnPort = (jsonMap['vpn'] as List).isNotEmpty
            ? jsonMap['vpn'][0]['port']
            : null,
        vpnEndpoint = (jsonMap['vpn'] as List).isNotEmpty
            ? jsonMap['vpn'][0]['endpoint']
            : null,
        mSpeed = jsonMap['mSpeed'] is int
            ? jsonMap['mSpeed'].toDouble()
            : jsonMap['mSpeed'],
        mStability = jsonMap['mStability'] is int
            ? jsonMap['mStability'].toDouble()
            : jsonMap['mSpeed'],
        disable = jsonMap['disable'];

  static String generatePaymentId(String serviceId) {
    final middleString =
        Random().nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
    final endString =
        Random().nextInt(0x1000000).toRadixString(16).padLeft(6, '0');
    return serviceId.toLowerCase() + middleString + endString;
  }
}
