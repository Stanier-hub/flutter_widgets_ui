abstract class SevicePadrao<T> {
  Future<T> criar({required Map<String, dynamic> dados});
  Future<T?> atualizar({
    required T modelo,
    required Map<String, dynamic> dados,
  });
  Future<List<T>> buscar({Map<String, dynamic>? filtros});
  Future<dynamic> excluir({required int id});
}
