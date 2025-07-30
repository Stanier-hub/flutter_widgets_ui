abstract class SevicePadrao<T> {
  Future<T> criar({required Map<String, dynamic> dados}) async {
    throw UnimplementedError();
  }

  Future<T?> atualizar({
    required T modelo,
    required Map<String, dynamic> dados,
  }) async {
    throw UnimplementedError();
  }

  Future<List<T>> buscar({Map<String, dynamic>? filtros}) async {
    throw UnimplementedError();
  }

  Future<void> excluir({required T modelo}) async {
    throw UnimplementedError();
  }

  Future<T?> buscarPorId({required String id}) async {
    throw UnimplementedError();
  }

  Future<void> baixar({Map<String, dynamic>? filtros}) async {
    throw UnimplementedError();
  }
}
