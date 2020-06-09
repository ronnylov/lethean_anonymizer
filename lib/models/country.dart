/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

class Country {
  final String name;
  final String code;
  final double latitude;
  final double longitude;

  Country({
    this.name,
    this.code,
    this.latitude,
    this.longitude,
  });

// Country.fromJson constructor is using the result format
// from https://api.ipgeolocationapi.com/geolocate/ API
// This type of data is returned by the function ApiHelpers.fetchIpCountry()
// See https://ipgeolocationapi.com/ about API details

  Country.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'],
        code = jsonMap['un_locode'],
        latitude = double.parse(jsonMap['geo']['latitude_dec']),
        longitude = double.parse(jsonMap['geo']['longitude_dec']);
}
