import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/widgets/slideLeft.dart';

class ApproveEmployee extends StatefulWidget {
  final String _token;
  ApproveEmployee(this._token);

  @override
  _ApproveEmployeeState createState() => _ApproveEmployeeState();
}

class _ApproveEmployeeState extends State<ApproveEmployee> {
  Map<String, dynamic> _employees;
  int _responseStatus = -1;
  String _responseMessage = "";

  @override
  void initState() {
    super.initState();
    getEmployees();
  }

  Future<void> getEmployees() async{
    var e = await getAuthData('$SERVER_IP/company/employee/all', widget._token);
    setState(() {
      _responseStatus = 200;
      _responseMessage = "Employee list fetched.";
      _employees = e;
    });
    Timer(Duration(milliseconds: 800), (){
      setState(() {
        _responseStatus = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("All Employees",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SFM",
            )),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _employees == null ? 0 : _employees['data'].length,
            itemBuilder: (BuildContext context, int index) {
              var employee = _employees['data'][index];
              return ListTile(
                title: Text(
                  '${employee['name']} | ${employee['email']}',
                  style: TextStyle(fontFamily: "SFCM"),
                ),
                subtitle: Text(
                  employee['id'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: "SFCR",
                  ),
                ),
                leading: employee['is_approved']
                    ? Icon(
                  Icons.check_circle,
                  color: new Color(0xffbbd984),
                  size: 40.0,
                )
                    : Icon(
                  Icons.add_circle,
                  color: Colors.orange,
                  size: 40.0,
                ),
                onTap: employee['is_approved']
                    ? () => {}
                    : () async {
                  setState(() {
                    _responseMessage = "Updating employee list.";
                    _responseStatus = 0;
                  });
                  var _ = await putAuthData(
                      '$SERVER_IP/company/employee/approve/${employee['id']}',
                      {},
                      widget._token);
                  var employees = await getAuthData(
                      '$SERVER_IP/company/employee/all',
                      widget._token);
                  setState(() {
                    _responseMessage = "Employee list updated.";
                    _responseStatus = 200;
                    _employees = employees;
                  });
                  Timer(Duration(milliseconds: 500), (){
                    setState(() {
                      _responseStatus = -1;
                    });
                  });
                },
              );
            },
          ),
          ProcessLoading(responseStatus: _responseStatus, message: _responseMessage, showBackButton: false,),
        ],
      ),
    );
  }
}
