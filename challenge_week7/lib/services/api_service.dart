import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/post.dart';

part 'api_service.g.dart';

/// Interface Retrofit Client untuk berkomunikasi dengan REST API JSONPlaceholder.
/// Anotasi @RestApi mendefinisikan Base URL default.
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// GET: Mengambil seluruh daftar post
  /// Endpoint: https://jsonplaceholder.typicode.com/posts
  @GET('/posts')
  Future<List<Post>> getPosts();

  /// GET: Mengambil satu post berdasarkan ID
  /// Endpoint: https://jsonplaceholder.typicode.com/posts/{id}
  @GET('/posts/{id}')
  Future<Post> getPost(@Path('id') int id);

  /// GET with @Query: Mengambil post yang difilter berdasarkan userId
  /// Endpoint: https://jsonplaceholder.typicode.com/posts?userId={userId}
  @GET('/posts')
  Future<List<Post>> getPostsByUserId(@Query('userId') int userId);

  /// POST: Menambahkan data post baru
  /// Endpoint: https://jsonplaceholder.typicode.com/posts
  @POST('/posts')
  Future<Post> createPost(@Body() Post post);

  /// PUT: Memperbarui seluruh data post berdasarkan ID
  /// Endpoint: https://jsonplaceholder.typicode.com/posts/{id}
  @PUT('/posts/{id}')
  Future<Post> updatePost(@Path('id') int id, @Body() Post post);

  /// DELETE: Menghapus post berdasarkan ID
  /// Endpoint: https://jsonplaceholder.typicode.com/posts/{id}
  @DELETE('/posts/{id}')
  Future<void> deletePost(@Path('id') int id);
}