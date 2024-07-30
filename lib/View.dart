import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/data_provider.dart';
// Adjust the path according to your directory structure

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          _buildFilters(context),
          _buildSortOptions(context),
          Expanded(
            child: _buildUserList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final userProvider = Provider.of<data_provider>(context);
    return Row(
      children: [
        DropdownButton<String>(
          value: userProvider.genderFilter.isEmpty ? null : userProvider.genderFilter,
          hint: Text('Select Gender'),
          items: [
            DropdownMenuItem(value: '', child: Text('All')),
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
          ],
          onChanged: (value) {
            userProvider.filterUsers(value ?? '', userProvider.countryFilter);
          },
        ),
        SizedBox(width: 16),
        DropdownButton<String>(
          value: userProvider.countryFilter.isEmpty ? null : userProvider.countryFilter,
          hint: Text('Select Location'),
          items: [
            DropdownMenuItem(value: '', child: Text('All')),
            DropdownMenuItem(value: 'USA', child: Text('USA')),
            DropdownMenuItem(value: 'Canada', child: Text('Canada')),
            // Add more locations as needed
          ],
          onChanged: (value) {
            userProvider.filterUsers(userProvider.genderFilter, value ?? '');
          },
        ),
      ],
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    final userProvider = Provider.of<data_provider>(context);
    return SizedBox(
      height: 30.0, // Adjust height as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSortButton(context, 'ID'),
            _buildSortButton(context, 'Image'),
            _buildSortButton(context, 'Name'),
            _buildSortButton(context, 'Demography'),
            _buildSortButton(context, 'Designation'),
            _buildSortButton(context, 'Location'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, String column) {
    final userProvider = Provider.of<data_provider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        onPressed: () {
          userProvider.sortUsers(column.toLowerCase());
        },
        child: Text(
          column,
          style: TextStyle(fontSize: 10.0),
        ),
      ),
    );
  }


  Widget _buildUserList(BuildContext context) {
    final userProvider = Provider.of<data_provider>(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!userProvider.isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          userProvider.fetchUsers();
        }
        return false;
      },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              child: DataTable(
                dataRowHeight: 30.0,
                headingRowHeight: 30.0,
                columnSpacing: 0.0,
                columns: [
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                  DataColumn(label: Text('', style: TextStyle(fontSize: 10))),
                ],
                rows: userProvider.users.map((user) {
                  return DataRow(cells: [
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 10.0),
                        child: Text(user.id.toString(), style: TextStyle(fontSize: 8)),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 25),
                        child: Image.network(
                          user.image,
                          height: 30.0,
                          width: 25.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 90),
                        child: Text(user.fullname, style: TextStyle(fontSize: 10)),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 40),
                        child: Text('${user.demography == 'male' ? 'M' : 'F'}/${user.age.toString()}', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 80),
                        child: Text(user.designation, style: TextStyle(fontSize: 10)),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 90),
                        child: Text(user.location, style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
            if (userProvider.isLoading)
              Center(child: CircularProgressIndicator()),
          ],
        ),






    );
  }
}
