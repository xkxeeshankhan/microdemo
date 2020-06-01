import 'package:dio/dio.dart';
import 'package:microdemo/repository/core/StringError.dart';
import 'package:microdemo/repository/core/api_url.dart';
import 'package:microdemo/repository/core/checkInternetConnection.dart';
import 'package:microdemo/repository/employee/EmployeeModel.dart';

class EmployeeRepo {
  Future getEmployeeDetail(String employeeId) async {
    print("GET EMPLOYEE DETAILS $employeeId");
    if (!(await CheckInternetConnection().checkConnection())) {
      return Future.error("No Internet Connection");
    }

    print("Here ${GET_EMPLOYEE_DETAIL + employeeId}");
    var response = await Dio().get(
      GET_EMPLOYEE_DETAIL + employeeId,
      options: Options(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-type': 'application/json;charset=utf-8',
        },
        receiveTimeout: 15000,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    print(response?.extra);
    print(response?.request?.data);
    print(response?.request?.extra);
    print(response?.request?.headers);

//    print(response?.request.);
    print("********$response");
    if (response is Response) {
      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data['data']);
      } else {
        if (response.data is Map)
          return Future.error(
              "${response.data['message']}\nThe apis save cookie in case of browser,"
              " due to which this apis gives error on the first call on all"
              " kinds of mediumm, but in case of browser and other api tools"
              " they have mechanism to store cookies internally but flutter "
              "plugin doesn't allow us to get cookies from api so we dont have "
              "any way to call this api, for demonstration if you clear the browser"
              " cookies every time you make the call you will get the same error");
        else
          return Future.error("Server Error");
      }
    } else {
      return Future.error(response.toString());
    }
  }

  Future createEmployee(EmployeeModel employee) async {
    print("Create EMPLOYEE DETAILS ");
    if (!(await CheckInternetConnection().checkConnection())) {
      return Future.error("No Internet Connection");
    }

    print("Here");
    var response = await Dio().post(
      POST_EMPLOYEE,
      data: employee.toJsonServer(),
      options: Options(
        receiveTimeout: 15000,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    print("********$response");
    if (response is Response) {
      if (response.statusCode == 200) {
        return EmployeeModel.fromJsonInCaseOfCreate(response.data['data']);
      } else {
        if (response.data is Map)
          return StringError(response.data['message']);
        else
          return StringError("Server Error");
      }
    } else {
      return StringError(response.toString());
    }
  }

  Future updateEmployee(EmployeeModel employee) async {
    print("Update EMPLOYEE DETAILS ${employee.id}");
    if (!(await CheckInternetConnection().checkConnection())) {
      return Future.error("No Internet Connection");
    }

    print("Here");
    var response = await Dio().put(
      PUT_EMPLOYEE + employee.id,
      data: employee.toJsonServer(),
      options: Options(
        receiveTimeout: 15000,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    print("********$response");
    if (response is Response) {
      if (response.statusCode == 200) {
        return EmployeeModel.fromJsonInCaseOfCreate(response.data['data'])
          ..isUpdated = true;
      } else {
        if (response.data is Map)
          return StringError(response.data['message']);
        else
          return StringError("Server Error");
      }
    } else {
      return StringError(response.toString());
    }
  }

  Future deleteEmployee(EmployeeModel employee) async {
    print("Delete EMPLOYEE DETAILS ${employee.id}");
    if (!(await CheckInternetConnection().checkConnection())) {
      return Future.error("No Internet Connection");
    }

    print("Here");
    var response = await Dio().delete(
      DELETE_EMPLOYEE + employee.id,
      data: employee.toJsonServer(),
      options: Options(
        receiveTimeout: 15000,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    print("********$response");
    if (response is Response) {
      if (response.statusCode == 200) {
        if (response.data['status'] == "success")
          return "success";
        else
          return StringError(response.data['message']);
      } else {
        if (response.data is Map)
          return StringError(response.data['message']);
        else
          return StringError("Server Error");
      }
    } else {
      return StringError(response.toString());
    }
  }
}
