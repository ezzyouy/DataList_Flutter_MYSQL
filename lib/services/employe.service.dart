import 'dart:convert';
import 'package:employees/models/employe.dart';
import 'package:http/http.dart';

class Services{
  static const Root ='http://192.168.1.105:8888/EmployeesDB/employe_action.php';
  static const _CREATE_TABLE_ACTION='CREATE_TABLE';
  static const _GET_ALL_ACTION='GET_ALL';
  static const _ADD_EMP_ACTION='ADD_EMP';
  static const _UPDATE_EMP_ACTION='UPDATE_EMP';
  static const _DELETE_EMP_ACTION='DELETE_EMP';

  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await post(Uri.parse(Root), body: map);
      print('Create Table Response: ${response.statusCode}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        throw  Exception();
      }
    } catch (e) {
      return 'error1';
    }
  }
  static Future<Object> getEmployees()async{
    try{
      var map=Map<String, dynamic>();
      map['action']=_GET_ALL_ACTION;
      final response=await post(Uri.parse(Root),body: map);
      print('GetEmployees Response : ${response.body}');
      if (200 == response.statusCode) {
        List<Employe> list=parseResponse(response.body);
        return list;
      }else{
        return List<Employe>.empty();
      }
    }catch(e){
      return List<Employe>.empty();

    }
  }

  static List<Employe> parseResponse(String body) {
    final parsed=json.decode(body).cast<Map<String,dynamic>>();
    return parsed.map<Employe>((json)=>Employe.fromJson(json)).toList();
  }

  static Future<Object> addEmployees( String firstName, String lastName)async{
    try{
      var map=Map<String, dynamic>();
      map['action']=_ADD_EMP_ACTION;
      map['first_name']=firstName;
      map['last_name']=lastName;
      final response=await post(Uri.parse(Root),body: map);
      print('addEmployees Response : ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      }else {
        return 'error';
      }
    }catch(e){
      return 'error';

    }
  }

  static Future<Object> updateEmployees(String emp_id, String firstName, String lastName)async{
    try{
      var map=Map<String, dynamic>();
      map['action']=_UPDATE_EMP_ACTION;
      map['emp_id']=emp_id;
      map['first_name']=firstName;
      map['last_name']=lastName;
      final response=await post(Uri.parse(Root),body: map);
      print('updateEmployees Response : ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      }else {
        return 'error';
      }
    }catch(e){
      return 'error';

    }
  }

  static Future<Object> deleteEmployees(String emp_id)async{
    try{
      var map=Map<String, dynamic>();
      map['action']=_DELETE_EMP_ACTION;
      map['emp_id']=emp_id;
      final response=await post(Uri.parse(Root),body: map);
      print('deleteEmployees Response : ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      }else {
        return 'error';
      }
    }catch(e){
      return 'error';

    }
  }
}