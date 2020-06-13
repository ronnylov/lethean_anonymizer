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

  /* Need to override both == operator and hashCode in order to
  make .toSet() work with deduplication of a List<Country>
  Trying to use countries.toSet().toList() to remove duplicated countries
  in exit_node_providers.dart
  See how to override here:
  https://dart-lang.github.io/linter/lints/hash_and_equals.html
  For Country we only care if country.code is identical when converted to uppercase.
  I mean location could be different but still within the same country.
  We do not check if the location is within the borders of a country. */

  @override
  bool operator ==(Object other) =>
      other is Country && other.code.toUpperCase() == code.toUpperCase();

  @override
  int get hashCode => code.toUpperCase().hashCode;

  /* Country.fromJson constructor is using the result format
  from https://api.ipgeolocationapi.com/geolocate/ API
  This type of data is returned by the function ApiHelpers.fetchIpCountry()
  See https://ipgeolocationapi.com/ about API details */

  Country.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'],
        code = jsonMap['un_locode'],
        latitude = double.parse(jsonMap['geo']['latitude_dec']),
        longitude = double.parse(jsonMap['geo']['longitude_dec']);
}
