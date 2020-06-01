import 'package:flutter/material.dart';
import 'package:microdemo/presentation/widget/ErrorMessage.dart';
import 'package:microdemo/presentation/widget/Loading.dart';
import 'package:microdemo/repository/core/StringError.dart';
import 'package:microdemo/repository/employee/EmployeeModel.dart';
import 'package:microdemo/repository/employee/employeeRepo.dart';

class AddAndUpdateEmployeePage extends StatefulWidget {
  ///in case of update we will have the employee model value
  final EmployeeModel employeeModel;

  const AddAndUpdateEmployeePage({Key key, this.employeeModel}) : super(key: key);

  @override
  _AddAndUpdateEmployeePageState createState() => _AddAndUpdateEmployeePageState();
}

class _AddAndUpdateEmployeePageState extends State<AddAndUpdateEmployeePage> {
  bool loading = false;
  String errorMessage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    if (widget.employeeModel != null) {
      _nameController.text = widget.employeeModel.employeeName;
      _ageController.text = widget.employeeModel.employeeAge;
      _salaryController.text = widget.employeeModel.employeeSalary;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Employee"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    validator: (val) {
                      if (val.isEmpty) return "Name is Required*";
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _ageController,
                    validator: (val) {
                      if (val.isEmpty) return "Age is Required*";
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    decoration: InputDecoration(
                      labelText: "Age",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _salaryController,
                    validator: (val) {
                      if (val.isEmpty) return "Salary is Required*";
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    decoration: InputDecoration(labelText: "Salary"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ErrorMessage(errorMessage: errorMessage),
                  SizedBox(
                    height: 10,
                  ),
                  loading
                      ? Center(
                          child: Loading(),
                        )
                      : FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (widget.employeeModel == null)
                                _addRecord();
                              else
                                _updateRecord();
                            }
                          },
                          child: Text(
                            widget.employeeModel == null ? "Add" : "Update",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _addRecord() async {
    setState(() {
      loading = true;
    });

    EmployeeModel employeeModel = EmployeeModel(
      employeeAge: _ageController.text,
      employeeName: _nameController.text,
      employeeSalary: _salaryController.text,
    );

    var response = await EmployeeRepo().createEmployee(employeeModel);

    if (response is StringError) {
      setState(() {
        errorMessage = response.errorMessage;
        loading = false;
      });
    } else {
      ///in this case the response will be the employee model
      Navigator.of(context).pop(response);
    }
  }

  _updateRecord() async {
    EmployeeModel employeeModel = EmployeeModel(
      id: widget.employeeModel.id,
      employeeAge: _ageController.text,
      employeeName: _nameController.text,
      employeeSalary: _salaryController.text,
    );

    var response = await EmployeeRepo().updateEmployee(employeeModel);

    if (response is StringError) {
      setState(() {
        errorMessage = response.errorMessage;
        loading = false;
      });
    } else {
      ///Pop two times so we can move back to the home page
      Navigator.of(context).pop(employeeModel..isUpdated = true);
      Navigator.of(context).pop(employeeModel..isUpdated = true);
    }
  }
}
