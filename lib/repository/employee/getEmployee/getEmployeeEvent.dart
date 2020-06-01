import 'package:microdemo/repository/employee/EmployeeModel.dart';

class EmployeeEvents {}

class GetInitialData extends EmployeeEvents {}
class AddNewEmployee extends EmployeeEvents {
  final EmployeeModel employeeModel;

  AddNewEmployee(this.employeeModel);
}
class UpdateEmployeeEvent extends EmployeeEvents {
  final EmployeeModel employeeModel;

  UpdateEmployeeEvent(this.employeeModel);
}
class DeleteEmployeeEvent extends EmployeeEvents {
  final EmployeeModel employeeModel;

  DeleteEmployeeEvent(this.employeeModel);
}

class ReloadData extends EmployeeEvents {}
