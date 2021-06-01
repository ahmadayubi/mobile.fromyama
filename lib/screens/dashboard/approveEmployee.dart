import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fromyama/screens/loading/dotLoading.dart';
import 'package:fromyama/screens/loading/processLoading.dart';
import 'package:fromyama/utils/cColor.dart';
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
        toolbarHeight: 45,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("All Employees",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "SFM",
              fontSize: 17,
            )),
      ),
      backgroundColor: beige(),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _employees == null ? 0 : _employees['data'].length,
            padding: EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              var employee = _employees['data'][index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(1, 6, 1, 5),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.1,
                        blurRadius: 2,
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                        child: Text(
                          '${employee['name']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "SFM",
                            color: Colors.grey[800], //new Color(0xff1a1a1a),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 6,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                child: employee['is_approved']
                                    ? Icon(
                                  Icons.check_circle,
                                  color: new Color(0xffbbd984),
                                  size: 25.0,
                                )
                                    : InkWell(
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
                                      child: Icon(
                                  Icons.add_circle,
                                  color: Colors.orange,
                                  size: 25.0,
                                ),
                                    )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${employee['email']}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "SFCR",
                                          color: Colors.grey[800]),
                                    ),
                                    Text(
                                      'ID ${employee['id']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "SFCM",
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
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
