import 'package:dio/dio.dart';

import '../error/exceptions.dart';

Exception mapDioException(DioException e) {
  if (e.response == null) return const NetworkException();

  final data = e.response!.data;
  final message = data is Map ? data['message'] as String? : null;
  return ServerException(
    message ?? 'Something went wrong',
    statusCode: e.response!.statusCode,
  );
}
