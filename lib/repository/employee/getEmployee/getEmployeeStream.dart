import 'dart:async';

import 'package:dio/dio.dart';
import 'package:microdemo/repository/core/api_url.dart';
import 'package:microdemo/repository/core/checkInternetConnection.dart';
import 'package:microdemo/repository/employee/EmployeeModel.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeEvent.dart';
import 'package:microdemo/repository/employee/getEmployee/getEmployeeStates.dart';

class GetEmployeeStream {
  StreamController<GetEmployeeStates> _streamController =
      StreamController<GetEmployeeStates>();

  GetEmployeeStream.init() {
    print("Init");
    dispatch(GetInitialData());
  }

  GetEmployeeStream._();

  List<EmployeeModel> _employees = [];

  Stream<GetEmployeeStates> get stream => _streamController.stream;

  dispatch(EmployeeEvents events) {
    if (events is GetInitialData || events is ReloadData)
      _fetchedDataFromServer();
    else if (events is AddNewEmployee) {
      _streamController.add(LoadingState());
      _employees.add(events.employeeModel);
      _streamController.add(LoadedState(_employees));
    } else if (events is UpdateEmployeeEvent) {
      _streamController.add(LoadingState());

      _employees
          .firstWhere((emp) => emp.id == events.employeeModel.id)
          .update(events.employeeModel);
      _streamController.add(LoadedState(_employees));
    } else if (events is DeleteEmployeeEvent) {
      _streamController.add(LoadingState());
      _employees.removeWhere((emp) => emp.id == events.employeeModel.id);
      _streamController.add(LoadedState(_employees));
    }
  }

  _fetchedDataFromServer() async {
    print("FetchedDataFromServer");
    _streamController.add(LoadingState());

    ///Getting data from server

    if (!(await CheckInternetConnection().checkConnection())) {
      _streamController.add(FailedState("No Internet Connection"));
      return;
    }

    var response = await Dio().get(GET_EMPLOYEES);
    print("********$response");
    if (response is Response) {
      if (response.statusCode == 200) {
        _employees = [];
        response.data['data'].forEach((json) {
          _employees.add(EmployeeModel.fromJson(json));
        });
        _streamController.add(LoadedState(_employees));
      }
    } else {
      _streamController.add(FailedState(response.toString()));
    }
  }
}
