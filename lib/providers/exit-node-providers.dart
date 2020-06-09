/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/exit-node-service.dart';
import '../models/exit-node-provider.dart';
import '../models/country.dart';
import '../helpers/api_helpers.dart';

class ExitNodeProviders with ChangeNotifier {
  List<ExitNodeProvider> _providers = [];

  List<ExitNodeProvider> get providers {
    return [..._providers];
  }

  Future<void> fetchAndSetProviders() async {
    final result = await ApiHelpers.fetchExitNodes();
    (result['providers'] as List).forEach(
      (serviceMap) {
        final service = ExitNodeService.fromJson(serviceMap);
        final currentProvider = _providers.firstWhere(
          // Check if an existing providerId match this new service providerId
          // If true then use the existing provider as currentProvider
          (provider) => provider.id == service.providerId,
          orElse: () {
            // No provider with this providerId was found in _providers list.
            // Let's add this new provider to _providers and use as currentProvider
            _providers.add(
              ExitNodeProvider(
                id: service.providerId,
                name: service.providerName,
                wallet: service.providerWallet,
                certContent: service.providerCertContent,
                proxyServices: [],
                vpnServices: [],
              ),
            );
            return _providers[providers.length - 1]; //
          },
        );
        if (service.proxyPort != null && service.proxyEndpoint != null) {
          // This is a proxy service. Let's add it to the proxy services list
          // Proxy services list is then sorted by service id (1A, 1B, 1C ...)
          currentProvider.proxyServices.add(service);
          currentProvider.proxyServices.sort((a, b) => a.id.compareTo(b.id));
        } else if (service.vpnPort != null && service.vpnEndpoint != null) {
          // This is a VPN service. Let's add it to the VPN services list
          // VPN services list is then sorted by service id (2A, 2B, 2C ...)
          currentProvider.vpnServices.add(service);
          currentProvider.vpnServices.sort((a, b) => a.id.compareTo(b.id));
        }
      },
    );

    // Search for an endpoint through all services of each provider
    String _providerEndPoint;
    _providers.forEach((provider) async {
      if (provider.vpnServices != null && provider.vpnServices.isNotEmpty) {
        _providerEndPoint = provider.vpnServices
            .firstWhere((vpnService) => vpnService.vpnEndpoint != null)
            .vpnEndpoint;
      } else if (provider.proxyServices != null &&
          provider.proxyServices.isNotEmpty) {
        _providerEndPoint = provider.proxyServices
            .firstWhere((proxyService) => proxyService.proxyEndpoint != null)
            .proxyEndpoint;
      }
      // _providerEndPoint should now contain url or IP address
      // First check if IP address
      String _ipAddress;
      try {
        InternetAddress(_providerEndPoint);
        _ipAddress = _providerEndPoint;
      } catch (error) {
        // It was not IPv4 or IPv6 if error, so probably an url then.
        // Convert it to IP address by doing DNS lookup of the url
        _ipAddress =
            (await InternetAddress.lookup(_providerEndPoint))[0].address;
      }
      if (_ipAddress != null) {
        // Assuming we got a valid IP address for this provider
        // Let's fetch the country location and store it
        provider.country = Country.fromJson(
          await ApiHelpers.fetchCountryFromIp(_ipAddress),
        );
        // Seems required to get the flags painted at start of app
        // When a country is fetched the listeners should know about it.
        notifyListeners();
      }
    });

    notifyListeners();
    return;
  }
}
