import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_data_model.dart';


class data_provider with ChangeNotifier {
  List<userdata> _users = [];
  int _page = 0;
  bool _isLoading = false;
  String _sortColumn = 'id';
  bool _sortAscending = true;
  String _genderFilter = '';
  String _countryFilter = '';

  List<userdata> get users => _users;
  bool get isLoading => _isLoading;
  String get genderFilter => _genderFilter;
  String get countryFilter => _countryFilter;

  data_provider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://dummyjson.com/users?limit=10&skip=${_page * 10}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetched users: ${json.encode(data['users'])}');

      final List<userdata> fetchedUsers = (data['users'] as List)
          .map((user) => userdata.fromJson(user))
          .toList();

      _users.addAll(fetchedUsers);
      _page++;
      notifyListeners();
    } else {
      // Handle errors
      print('Failed to load users: ${response.statusCode}');
    }

    _isLoading = false;
    notifyListeners();
  }

  void sortUsers(String column) {
    if (_sortColumn == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = true;
    }

    _users.sort((a, b) {
      final valueA = a.toJson()[_sortColumn];
      final valueB = b.toJson()[_sortColumn];
      return _sortAscending
          ? valueA.compareTo(valueB)
          : valueB.compareTo(valueA);
    });

    notifyListeners();
  }

  void filterUsers(String gender, String country) {
    _genderFilter = gender;
    _countryFilter = country;

    _users = _users.where((user) {
      final matchesGender = _genderFilter.isEmpty || user.demography == _genderFilter;
      final matchesCountry = _countryFilter.isEmpty || user.location == _countryFilter;
      return matchesGender && matchesCountry;
    }).toList();

    notifyListeners();
  }
}
