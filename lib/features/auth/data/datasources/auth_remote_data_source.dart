import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/register_request_dto.dart';
import '../models/user_response_dto.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://dummyjson.com')
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/users/add')
  Future<UserResponseDto> register(@Body() RegisterRequestDto request);
}
