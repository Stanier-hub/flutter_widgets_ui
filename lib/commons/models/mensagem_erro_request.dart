class MensagemErroRequest {
  final String mensagem;
  final int codigo;

  MensagemErroRequest({required this.mensagem, required this.codigo});

  factory MensagemErroRequest.fromJson(Map<String, dynamic> json) {
    return MensagemErroRequest(
      mensagem: json['mensagem'],
      codigo: json['codigo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensagem': mensagem,
      'codigo': codigo,
    };
  }

  @override
  String toString() {
    return 'MensagemErroRequest{mensagem: $mensagem, codigo: $codigo}';
  }
}
