import 'package:flutter/material.dart';
import 'package:microdemo/presentation/emoloyee/addNewEmployee.dart';
import 'package:microdemo/presentation/widget/ErrorMessage.dart';
import 'package:microdemo/presentation/widget/Loading.dart';
import 'package:microdemo/repository/core/StringError.dart';
import 'package:microdemo/repository/employee/EmployeeModel.dart';
import 'package:microdemo/repository/employee/employeeRepo.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeEvent.dart';
import 'package:transparent_image/transparent_image.dart';

class EmployeeDetailPage extends StatefulWidget {
  final String employeeId;

  ///Passing this bcz we cannt get data from the detail api call
  final EmployeeModel employeeModel;

  const EmployeeDetailPage({Key key, this.employeeId, this.employeeModel})
      : super(key: key);

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  bool loading = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: EmployeeRepo().getEmployeeDetail(widget.employeeId),
        builder: (_, snapshot) {
          Widget body = Container();
          EmployeeModel employee;

          if (!snapshot.hasData) {
            if (snapshot.hasError)
              body = Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    snapshot.error,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buttonRow(context),
                ],
              ));
            else
              body = Center(child: Loading());
          } else {
            employee = snapshot.data;
            body = Center(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: FadeInImage(
                        width: 200,
                        height: 200,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(employee.profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    employee?.employeeName ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Salary: ${employee?.employeeSalary ?? "0"}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Age: ${employee?.employeeAge ?? "0"}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buttonRow(context),
                ],
              )),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(employee?.employeeName ?? ""),
                centerTitle: true,
              ),
              body: body);
        });
  }

  _buttonRow(BuildContext context) {
    return Column(
      children: <Widget>[
        ErrorMessage(
          errorMessage: errorMessage,
        ),
        SizedBox(
          height: 10,
        ),
        loading
            ? Center(
                child: Loading(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      updateEmployee();
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    onPressed: deleteEmployee,
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  updateEmployee() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AddAndUpdateEmployeePage(
              employeeModel: widget.employeeModel,
            )));
  }

  deleteEmployee() async {
    setState(() {
      errorMessage = null;
      loading = false;
    });
    var response = await EmployeeRepo().deleteEmployee(widget.employeeModel);

    if (response is StringError) {
      setState(() {
        errorMessage = response.errorMessage;
        loading = false;
      });
    } else {
      ///Pop two times so we can move back to the home page
      Navigator.of(context).pop(widget.employeeModel);
    }
  }
}
