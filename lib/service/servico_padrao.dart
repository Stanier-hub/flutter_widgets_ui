abstract class SevicePadrao<T> {
  Future<T?> atualizar({
    required T modelo,
    required Map<String, dynamic> dados,
  });
  Future<T> criar({required Map<String, dynamic> dados});

  Future<List<T>> buscar({Map<String, dynamic>? filtros});
}
