import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  static final Client client = Client()
    ..setEndpoint('https://fra.cloud.appwrite.io/v1')
    ..setProject('688702b00015c3fc54a0');

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);

  // ID de base de datos y colecciones
  static const String databaseId = '688707fa0006ca7a2eb6';
  static const String productosCollectionId = '68870805003317ef0fa6';
  static const String carritoCollectionId = '6887411b001edec52ca5';

  // Función para registrar usuario
  Future<User?> registrarUsuario({
    required String email,
    required String password,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return user;
    } on AppwriteException catch (e) {
      print('Error al registrar usuario: ${e.message}');
      return null;
    }
  }

  // Función para iniciar sesión
  Future<Session?> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final session = await account.createEmailSession(
        email: email,
        password: password,
      );
      return session;
    } on AppwriteException catch (e) {
      print('Error al iniciar sesión: ${e.message}');
      return null;
    }
  }

  // Función para obtener productos
  Future<List<Document>> fetchProductos({String? categoria}) async {
    try {
      final List<String> queries = [];

      if (categoria != null && categoria.trim().isNotEmpty) {
        queries.add(Query.equal('categoria', [categoria]));
      }

      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: productosCollectionId,
        queries: queries,
      );

      return result.documents;
    } on AppwriteException catch (e) {
      print('Error al obtener productos: ${e.message}');
      return [];
    }
  }

  // Agregar producto al carrito
  static Future<void> agregarAlCarrito({
    required String productoId,
    required String nombre,
    required double precio,
    required String imagen,
    required int cantidad,
    required String userId,
  }) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: carritoCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'productoId': productoId,
          'nombre': nombre,
          'precio': precio,
          'imagen': imagen,
          'cantidad': cantidad,
        },
      );
      print('Producto agregado al carrito');
    } on AppwriteException catch (e) {
      print('Error al agregar al carrito: ${e.message}');
    }
  }

  // Obtener productos del carrito del usuario
  Future<List<Document>> obtenerCarrito(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: carritoCollectionId,
        queries: [
          Query.equal('userId', [userId]),
        ],
      );

      return result.documents;
    } on AppwriteException catch (e) {
      print('Error al obtener carrito: ${e.message}');
      return [];
    }
  }

  // Eliminar producto del carrito
  Future<void> eliminarDelCarrito(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: carritoCollectionId,
        documentId: documentId,
      );
      print('Producto eliminado del carrito');
    } on AppwriteException catch (e) {
      print('Error al eliminar del carrito: ${e.message}');
    }
  }

  // Vaciar carrito completo de un usuario
  Future<void> vaciarCarrito(String userId) async {
    try {
      final carritoDocs = await obtenerCarrito(userId);

      for (var doc in carritoDocs) {
        await eliminarDelCarrito(doc.$id);
      }

      print('Carrito vaciado para usuario $userId');
    } on AppwriteException catch (e) {
      print('Error al vaciar carrito: ${e.message}');
    }
  }
}
