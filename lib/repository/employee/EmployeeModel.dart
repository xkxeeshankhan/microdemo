class EmployeeModel {
  String id;
  String employeeName;
  String employeeSalary;
  String employeeAge;
  String profileImage;

  bool isUpdated;

  update(EmployeeModel employeeModel) {
    this.id = employeeModel.id;
    this.employeeName = employeeModel.employeeName;
    this.employeeSalary = employeeModel.employeeSalary;
    this.employeeAge = employeeModel.employeeAge;
  }

  EmployeeModel(
      {this.id,
      this.employeeName,
      this.employeeSalary,
      this.employeeAge,
      this.profileImage});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    employeeName = json['employee_name'];
    employeeSalary = json['employee_salary']?.toString();
    employeeAge = json['employee_age']?.toString();
    profileImage = json['profile_image'];
  }

  EmployeeModel.fromJsonInCaseOfCreate(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id']?.toString();
    employeeName = json['name'];
    employeeSalary = json['salary']?.toString();
    employeeAge = json['age']?.toString();
    profileImage = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_name'] = this.employeeName;
    data['employee_salary'] = this.employeeSalary;
    data['employee_age'] = this.employeeAge;
    data['profile_image'] = this.profileImage;
    return data;
  }

  Map<String, dynamic> toJsonServer() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.employeeName;
    data['salary'] = this.employeeSalary;
    data['age'] = this.employeeAge;
    return data;
  }
}
