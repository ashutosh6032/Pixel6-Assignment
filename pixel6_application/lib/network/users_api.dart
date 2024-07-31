import 'package:dio/dio.dart';
import 'package:pixel6_application/Models/employee_model.dart';

Future<Employee> employeeApi({int limit = 10, int skip = 0, String? country, String? gender}) async {
  final dio = Dio();
  try {
    
    Map<String, dynamic> queryParameters = {
      'limit': limit,
      'skip': skip,
    };

    String url = 'https://dummyjson.com/users';

    
    if ((country != null && country.isNotEmpty) || (gender != null && gender.isNotEmpty)) {
      url = 'https://dummyjson.com/users/filter';

     
      if (country != null && country.isNotEmpty) {
        queryParameters['key'] = 'address.country';
        queryParameters['value'] = country;
      }

      if (gender != null && gender.isNotEmpty) {
        queryParameters['key'] = 'gender';
        queryParameters['value'] = gender;
      }
    }

    final Response response = await dio.get(url, queryParameters: queryParameters);

    if (response.statusCode == 200) {
      //print('Response data: ${response.data}');
      return Employee.fromJson(response.data);
    } else {
      //print('Error: ${response.statusCode}');
    }
  } catch (e) {
    //print('Exception: $e');
  }
  return Employee();
}