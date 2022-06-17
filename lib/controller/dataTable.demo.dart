import 'package:employees/models/employe.dart';
import 'package:employees/services/employe.service.dart';
import 'package:flutter/material.dart';

class DataTableDemo extends StatefulWidget {
  const DataTableDemo({Key? key}) : super(key: key);
  final String title='Flutter Data Table';
  @override
  State<DataTableDemo> createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  late List<Employe> _employees;
  late GlobalKey<ScaffoldState> _sclobalKey;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late Employe _selectemploye;
  late bool _isUpdating;
  late String _titleProgress;
  @override
  void initState() {
    super.initState();
    _employees=[];
    _isUpdating=false;
    _titleProgress=widget.title;
    _sclobalKey=GlobalKey();
    _firstNameController=TextEditingController();
    _lastNameController=TextEditingController();
    _getEmploye();
  }
  _showProgress(String message){
    setState(() {
      _titleProgress=message;
    });
  }
  _showSnackBar(context, message){
    _sclobalKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
  _createTable(){
    _showProgress('Create Table....');
    Services.createTable().then((result) {
      print(result);
      if('success' == result){
        print('ok2');
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
      print('ok3');
    });
  }
  _getEmploye(){
  _showProgress('Loading Employess...');
  Services.getEmployees().then((employees){
    setState(() {
      _employees = employees as List<Employe>;
    });
    _showProgress(widget.title);
    print("Lenght ${(employees as List<Employe>).length}");
  });
  }
  _addEmploye(){
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty){

      print('Empty Fields');
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployees(_firstNameController.text, _lastNameController.text)
    .then((result) {
      if('success' == result){
        _getEmploye();
        _clearValue();
      }

    });
  }
  _updateEmploye(Employe employe){
    setState(() {
      _isUpdating=true;
    });
  _showProgress('Updating Employee..');
  Services.updateEmployees(employe.id, _firstNameController.text, _lastNameController.text)
  .then((result){
    if('success' == result){
      setState(() {
        _isUpdating=false;
      });
      _clearValue();
    }
  });
  }
  _deleteEmploye(Employe employe){
    _showProgress('Deleting Employee...');
    Services.deleteEmployees(employe.id).then((result){
      if('success'== result){
       _getEmploye();
      }

    });
  }

  _clearValue(){
    _firstNameController.text='';
    _lastNameController.text='';
  }

  _showValue(Employe employe){
    _firstNameController.text=employe.firstName;
    _lastNameController.text=employe.lastName;
  }
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text('ID'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
            DataColumn(
                label: Text('Delete'),
            )
          ],
          rows: _employees.map((e) => DataRow(
            cells: [
              DataCell(
                Text(e.id),
                onTap: (){
                  _showValue(e);
                  _selectemploye=e;
                }
              ),
              DataCell(
                Text(e.firstName.toUpperCase()),
                  onTap: (){
                    _showValue(e);
                    _selectemploye=e;
                    setState(() {
                      _isUpdating=true;
                    });
                  }
              ),
              DataCell(
                Text(e.lastName.toUpperCase()),
                  onTap: (){
                    _showValue(e);
                    _selectemploye=e;
                  }
              ),
              DataCell(
                IconButton(
                    icon:Icon(Icons.delete),
                  onPressed: (){
                      _deleteEmploye(e);
                  },
                )
              )
            ]
          )).toList(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sclobalKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: [
          IconButton(
              onPressed: (){
                _createTable();
              },
              icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: (){
                _getEmploye();
              },
              icon: Icon(Icons.refresh)
          )
        ],
      ),
      body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(20),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(hintText: 'Last Name'),
              ),
            ),
            _isUpdating?
            Row(
              children: [
                OutlinedButton(
                    onPressed: (){
                      _updateEmploye(_selectemploye);
                    },
                    child: Text('UPDATE')
                ),
                OutlinedButton(
                    onPressed: (){
                      setState(() {
                        _isUpdating=false;

                      });
                      _clearValue();
                    },
                    child: Text('CANCEL'))
              ],
            )
                :Container(),
            _dataBody(),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addEmploye();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
