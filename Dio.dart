import 'package:dio/dio.dart';

void main() async {
  Dio dio = Dio();
  
  // Adding an interceptor to log requests and responses
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print("Request [${options.method}] to ${options.path}");
      print("Data sent: ${options.data}");
      print("Headers: ${options.headers}");
      return handler.next(options); //continue
    },
    onResponse: (response, handler) {
      print("Response received from ${response.requestOptions.path}");
      print("Status code: ${response.statusCode}");
      print("Data: ${response.data}");
      return handler.next(response); //continue
    },
    onError: (DioError e, handler) {
      print("Error occurred during request to ${e.requestOptions.path}");
      print("Error type: ${e.type}");
      print("Error code: ${e.response?.statusCode}");
      print("Error data: ${e.response?.data}");
      print("Error message: ${e.message}");
      if(e.response != null) {
          // Handle empty data response
          if(e.response!.data == null e.response!.data == '') {
            print("Response data is empty");
          }
      }
      return handler.next(e); //continue
    },
  ));

  // Example of a GET request
  try {
    Response response = await dio.get('https://jsonplaceholder.typicode.com/posts');
    print("Data from GET request: ${response.data}");
  } catch (e) {
    print("Error during GET request: $e");
  }

  // Example of a POST request
  try {
    Response response = await dio.post(
      'https://jsonplaceholder.typicode.com/posts',
      data: {'title': 'New Post', 'body': 'Post body', 'userId': 1},
    );
    print("Data from POST request: ${response.data}");
  } catch (e) {
    print("Error during POST request: $e");
  }
}
