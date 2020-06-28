import 'package:flutter/material.dart';
import 'package:fromyama/utils/requests.dart';
import 'package:fromyama/screens/loading/fyLoading.dart';
import 'package:fromyama/widgets/slideLeft.dart';

class ApproveEmployee extends StatelessWidget {
  final String _token;
  ApproveEmployee(this._token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAuthData('$SERVER_IP/company/employee/all', _token),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return FYLoading();
            default:
              var employees = snapshot.data['employees'];
              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (BuildContext context, int index) {
                  var employeeID = employees[index];
                  return FutureBuilder(
                    future: getAuthData(
                        '$SERVER_IP/company/employee/approved/$employeeID',
                        _token),
                    builder: (context, newSnapshot) {
                      switch (newSnapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return ListTile(
                            title: Text("Loading Employee..."),
                            subtitle: Text("..."),
                            leading: Icon(
                              Icons.cloud_download,
                              color: Colors.yellow,
                              size: 40.0,
                            ),
                          );
                        default:
                          return ListTile(
                            title: Text(newSnapshot.data['email']),
                            subtitle: Text(employeeID),
                            leading: newSnapshot.data['is_approved']
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 40.0,
                                  )
                                : Icon(
                                    Icons.add_circle,
                                    color: Colors.orange,
                                    size: 40.0,
                                  ),
                            onTap: newSnapshot.data['is_approved']
                                ? () => {}
                                : () async {
                                    var _ = await postAuthData(
                                        '$SERVER_IP/company/employee/approve/$employeeID',
                                        {},
                                        _token);
                                    Navigator.pushReplacement(
                                      context,
                                      SlideLeft(
                                        exitPage: ApproveEmployee(_token),
                                        enterPage: ApproveEmployee(_token),
                                      ),
                                    );
                                  },
                          );
                          break;
                      }
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}
