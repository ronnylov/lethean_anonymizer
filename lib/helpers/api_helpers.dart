/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelpers {
  static Future<Map<String, dynamic>> fetchExitNodes([
    String url = 'https://sdp.lethean.io/v1/services/search',
  ]) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch Lethean service decriptions');
    }
  }

  static Future<String> fetchMyIp([
    String url = 'https://api.ipify.org/?format=json',
  ]) async {
    final response = await http.get(url);
    String myIpAddress;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      myIpAddress = (json.decode(response.body) as Map<String, dynamic>)['ip'];
      return myIpAddress;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch external IP address');
    }
  }

  static Future<Map<String, dynamic>> fetchCountryFromIp(
    String ipAddress, [
    String url = 'https://api.ipgeolocationapi.com/geolocate/',
  ]) async {
    final response = await http.get(url + '$ipAddress');
    Map<String, dynamic> jsonMap;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return jsonMap;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch country from IP address');
    }
  }

    static Future<Map<String, dynamic>> fetchCountryFromCode(
    String countryCode, [
    String url = 'https://api.ipgeolocationapi.com/countries/',
  ]) async {
    final response = await http.get(url + '$countryCode');
    Map<String, dynamic> jsonMap;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return jsonMap;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch country from country code');
    }
  }
}
