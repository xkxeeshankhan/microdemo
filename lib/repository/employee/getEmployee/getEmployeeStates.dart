import 'package:microdemo/repository/employee/EmployeeModel.dart';

class GetEmployeeStates {}

class LoadingState extends GetEmployeeStates {}

class FailedState extends GetEmployeeStates {
  final String errorMessage;

  FailedState(this.errorMessage);
}

class LoadedState extends GetEmployeeStates {
  final List<EmployeeModel> employees;

  LoadedState(this.employees);
}
