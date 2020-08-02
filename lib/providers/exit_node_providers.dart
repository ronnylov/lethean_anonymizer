/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/exit_node_service.dart';
import '../models/exit_node_provider.dart';
import '../models/country.dart';
import '../helpers/api_helpers.dart';

class ExitNodeProviders with ChangeNotifier {
  List<ExitNodeProvider> _providers = [];
  List<Country> _countries = [];

  List<ExitNodeProvider> get providers {
    return [..._providers];
  }

  List<Country> get countries {
    return [..._countries];
  }

  void setPaymentId(String providerId, String serviceId, String paymentId) {
    final provider = _providers.firstWhere((p) => p.id == providerId);
    if (provider.vpnServices != null && provider.vpnServices.isNotEmpty) {
      final foundService = provider.vpnServices.firstWhere(
        (vpnService) => vpnService.id == serviceId,
        orElse: () {
          // The serviceId was not found as VPN service, search Proxy services
          if (provider.proxyServices != null &&
              provider.proxyServices.isNotEmpty) {
            return provider.proxyServices
                .firstWhere((proxyService) => proxyService.id == serviceId);
          } else {
            return null; // The service does not exist
          }
        },
      );
      if (foundService != null) {
        foundService.paymentId = paymentId;
        notifyListeners();
      }
    }
  }

  ExitNodeService getServiceFromIds(String providerId, String serviceId) {
    final provider = _providers.firstWhere((p) => p.id == providerId);
    if (provider.vpnServices != null) {
      final service = provider.vpnServices.firstWhere((s) => s.id == serviceId);
      return ExitNodeService(
        providerId: service.providerId,
        providerName: service.providerName,
        providerWallet: service.providerWallet,
        providerCertContent: service.providerCertContent,
        id: service.id,
        name: service.name,
        type: service.type,
        cost: service.cost,
        firstPrePaidMinutes: service.firstPrePaidMinutes,
        firstVerificationsNeeded: service.firstVerificationsNeeded,
        subsequentPrePaidMinutes: service.subsequentPrePaidMinutes,
        subsequentVerificationsNeeded: service.subsequentPrePaidMinutes,
        downloadSpeed: service.downloadSpeed,
        uploadSpeed: service.uploadSpeed,
        proxyEndpoint: service.proxyEndpoint,
        proxyPort: service.proxyPort,
        vpnEndpoint: service.vpnEndpoint,
        vpnPort: service.vpnPort,
        mSpeed: service.mSpeed,
        mStability: service.mStability,
        disable: service.disable,
        paymentId: service.paymentId,
      );
    }
    if (provider.proxyServices != null) {
      final service =
          provider.proxyServices.firstWhere((s) => s.id == serviceId);
      return ExitNodeService(
        providerId: service.providerId,
        providerName: service.providerName,
        providerWallet: service.providerWallet,
        providerCertContent: service.providerCertContent,
        id: service.id,
        name: service.name,
        type: service.type,
        cost: service.cost,
        firstPrePaidMinutes: service.firstPrePaidMinutes,
        firstVerificationsNeeded: service.firstVerificationsNeeded,
        subsequentPrePaidMinutes: service.subsequentPrePaidMinutes,
        subsequentVerificationsNeeded: service.subsequentPrePaidMinutes,
        downloadSpeed: service.downloadSpeed,
        uploadSpeed: service.uploadSpeed,
        proxyEndpoint: service.proxyEndpoint,
        proxyPort: service.proxyPort,
        vpnEndpoint: service.vpnEndpoint,
        vpnPort: service.vpnPort,
        mSpeed: service.mSpeed,
        mStability: service.mStability,
        disable: service.disable,
        paymentId: service.paymentId,
      );
    }
    return null;
  }

  Future<void> fetchAndSetProviders() async {
    final result = await ApiHelpers.fetchExitNodes();
    if (result['providers'] != null) {
      _providers = [];
      _countries = [];
      (result['providers'] as List).forEach(
        (serviceMap) {
          final service = ExitNodeService.fromJson(serviceMap);
          final currentProvider = _providers.firstWhere(
            // Check if an existing providerId match this new service providerId
            // If true then use the existing provider as currentProvider
            (provider) => provider.id == service.providerId,
            orElse: () {
              // No provider with this providerId was found in _providers list.
              // Let's add this new provider to _providers and use it as currentProvider
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
              return _providers[providers.length - 1];
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
        // _providerEndPoint should now contain an url or an IP address
        // First check if it is an IP address
        String _ipAddress;
        try {
          InternetAddress(_providerEndPoint); // Will throw error if not IP
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
          if (provider.country != null) {
            _countries.add(provider.country);

            // Remove duplicated countries from the list.
            _countries = _countries.toSet().toList();
          }

          // Seems required to notify listeners to make the flags
          // painted when reloading data from sdp API
          // When a new country is added the listeners should be notified.
          notifyListeners();
        }
      });

      notifyListeners();
    }
    return;
  }
}
