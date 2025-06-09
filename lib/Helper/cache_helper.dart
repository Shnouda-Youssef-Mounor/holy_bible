import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static saveFilterToCache(Map<String, dynamic> newFilter, context) async {
    // Retrieve the existing filters list from the cache
    final List<Map<String, dynamic>> cachedFilters =
        CacheHelper.getMapList('filters');

    if (cachedFilters.isEmpty) {
      // If no filters exist in the cache, initialize a new list with the new filter
      CacheHelper.saveData(key: 'filters', value: [newFilter]);
    } else {
      // If filters exist, append the new filter and save back
      cachedFilters.add(newFilter);
      // Save the updated list back to the cache
      CacheHelper.saveData(key: 'filters', value: cachedFilters);
    }

    // Notify the user of success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter saved successfully!')),
    );
  }

  static List<Map<String, dynamic>> getMapList(String key) {
    List<String>? jsonStringList = sharedPreferences.getStringList(key);
    if (jsonStringList != null) {
      // Deserialize each JSON string back into a Map
      return jsonStringList
          .map((jsonString) => json.decode(jsonString) as Map<String, dynamic>)
          .toList();
    }
    return []; // Return an empty list if the key doesn't exist
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Set<String> getAllKeys() {
    return sharedPreferences.getKeys();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }
    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    }
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    }
    if (value is List<dynamic>) {
      // Serialize other lists as strings
      List<String> stringList = value.map((item) => item.toString()).toList();
      return await sharedPreferences.setStringList(key, stringList);
    }
    if (value is List<Map<String, dynamic>>) {
      // Serialize list of maps into JSON strings
      List<String> jsonStringList = value
          .map((map) => json.encode(map)) // Convert each map to a JSON string
          .toList();
      return await sharedPreferences.setStringList(key, jsonStringList);
    }
    return false; // Return false if type is not supported
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

  static Future<bool> removeArrayData({
    required List<String> keys,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String key in keys) {
      await prefs.remove(key);
    }
    return true;
  }

  // Methods specific to organizationName
  static Future<bool> setOrganizationName(dynamic value) async {
    if (value is String) {
      return await sharedPreferences.setString('organizationName', value);
    } else if (value is int) {
      return await sharedPreferences.setInt('organizationName', value);
    } else if (value is bool) {
      return await sharedPreferences.setBool('organizationName', value);
    } else if (value is double) {
      return await sharedPreferences.setDouble('organizationName', value);
    }

    // Add handling for additional types as needed

    return false; // Return false if type is not supported
  }

  static dynamic getOrganizationName() {
    return sharedPreferences.get('organizationName');
  }
}
