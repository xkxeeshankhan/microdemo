import 'package:flutter/material.dart';
import 'package:microdemo/presentation/emloyee/addNewEmployee.dart';
import 'package:microdemo/presentation/emloyee/employeeDetailPage.dart';
import 'package:microdemo/presentation/widget/Loading.dart';
import 'package:microdemo/repository/employee/EmployeeModel.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeEvent.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeStates.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeStream.dart';
import 'package:transparent_image/transparent_image.dart';

///create singleton of employee stream so we can dispatch event from child
///basically its is done thorugh the getit , but for know i'm using this method
class EmployeeStreamSingleton {
  static GetEmployeeStream _instance;

  static GetEmployeeStream get getInstance {
    if (_instance == null) {
      return GetEmployeeStream.init();
    } else
      return _instance;
  }
}

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (_) => AddAndUpdateEmployeePage()))
              .then((val) {
            if (val is EmployeeModel) {
              ///in case of success we will add the employee to the existing list
              EmployeeStreamSingleton.getInstance.dispatch(AddNewEmployee(val));
            }
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text("Employees"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: EmployeeStreamSingleton.getInstance.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Loading());
            }

            var state = snapshot.data;

            if (state is FailedState) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            }

            if (state is LoadingState) {
              return Center(child: Loading());
            }

            if (state is LoadedState) {
              List<EmployeeModel> employees = state.employees;
              return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: employees.length,
                  itemBuilder: (context, index) => EmployeeListView(
                        employee: employees[index],
                      ));
            }

            return Text("State is not Set");
          }),
    );
  }
}

class EmployeeListView extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeListView({Key key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => EmployeeDetailPage(
                      employeeId: employee.id,
                      employeeModel: employee,
                    )))
            .then((val) {
          if (val is EmployeeModel) {
            ///so if the update or delete is successful we perform the respect action on the list
            if (val.isUpdated ?? false) {
              EmployeeStreamSingleton.getInstance
                  .dispatch(UpdateEmployeeEvent(val));
            } else {
              EmployeeStreamSingleton.getInstance
                  .dispatch(DeleteEmployeeEvent(val));
            }
          }
        });
      },
      leading: employee?.profileImage != null && employee.profileImage != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(employee.profileImage),
                fit: BoxFit.cover,
              ),
            )
          : null,
      title: Text(
        employee?.employeeName ?? "",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  "Salary: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(employee?.employeeSalary ?? "0"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  "Age: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(employee?.employeeAge ?? "0"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
