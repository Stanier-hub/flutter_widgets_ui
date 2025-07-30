import 'package:flutter/material.dart';

/// InputDefault
///
/// Um widget personalizado para um campo de entrada de texto.
///
/// [rotulo] O rótulo que será exibido acima do campo de entrada.
///
/// [controlador] O controlador que gerencia o texto exibido no campo de entrada.
///
/// [textoObscuro] Indica se o texto deve ser obscurecido (por exemplo, para senhas). O padrão é false.
///
/// [tipoTeclado] O tipo de teclado a ser exibido ao focar no campo de entrada. O padrão é TextInputType.text.
///
/// [iconePrefixo] Um ícone opcional a ser exibido no início do campo de entrada.
///
/// [iconeSufixo] Um ícone opcional a ser exibido no final do campo de entrada.
///
/// [mensagemErro] A mensagem de erro que será exibida abaixo do campo de entrada caso a condição não seja satisfeita.
///
/// [condicaoErro] A condição que será passada via ValueNotifier para determinar se a mensagem de erro deve ser exibida.
///
/// [obrigatorio] Indica se o campo é obrigatório. O padrão é false.
///
/// [validator] A função de validação personalizada que pode ser usada para validar o campo de entrada.
/// 
/// [focusNode] O nó de foco associado ao campo de entrada.
/// 
/// [nextFocus] O nó de foco para o próximo campo a ser focado após a submissão.
///
/// [onSubmited] Função chamada ao submeter o campo. Avança para o próximo campo caso [nextFocus] não seja nulo ou executa ação personalizada.
///
/// [apenasLeitura] impede teclado de abrir
class InputDefault extends StatefulWidget {
  /// Rótulo exibido acima do campo de entrada.
  final String rotulo;

  /// Controlador responsável pelo texto do campo de entrada.
  final TextEditingController controlador;

  /// Define se o texto do campo será exibido de forma obscura (ex: senha).
  final bool textoObscuro;

  /// Tipo de teclado a ser exibido ao focar no campo.
  final TextInputType tipoTeclado;

  /// Ícone exibido como prefixo dentro do campo de entrada.
  final Icon? iconePrefixo;

  /// Ícone exibido como sufixo dentro do campo de entrada.
  final Icon? iconeSufixo;

  /// Mensagem de erro personalizada a ser exibida.
  final String? mensagemErro;

  /// Notificador para controlar a condição de erro do campo.
  final ValueNotifier<bool>? condicaoErro;

  /// Indica se o campo é obrigatório.
  final bool obrigatorio;

  /// Notificador para exibir erro de obrigatoriedade.
  final ValueNotifier<bool>? exibirErroObrigatorio;

  /// Função de validação personalizada para o campo.
  final String? Function(String?)? validator;

  /// Nó de foco associado ao campo de entrada.
  final FocusNode? focusNode;

  /// Nó de foco do próximo campo a ser focado após submissão.
  final FocusNode? nextFocus;

  /// Função chamada ao submeter o campo. Avança para o próximo campo caso [nextFocus] não seja nulo ou executa ação personalizada.
  final Function? onSubmited;

  /// Define se o campo será apenas leitura.
  final bool apenasLeitura;

  /// Função chamada ao tocar no campo.
  final Function()? onTap;

  const InputDefault({
    required this.rotulo,
    required this.controlador,
    this.textoObscuro = false,
    this.tipoTeclado = TextInputType.text,
    this.iconePrefixo,
    this.iconeSufixo,
    this.mensagemErro,
    this.condicaoErro,
    this.obrigatorio = false,
    this.exibirErroObrigatorio,
    this.validator,
    this.focusNode,
    this.nextFocus,
    this.onSubmited,
    this.apenasLeitura = false,
    this.onTap,
    super.key,
  });

  @override
  _InputDefaultState createState() => _InputDefaultState();
}

class _InputDefaultState extends State<InputDefault> {
  late bool _textoObscuro;

  @override
  void initState() {
    super.initState();
    _textoObscuro = widget.textoObscuro;

    // widget.controlador.addListener(() {
    //   campoVazio.value = widget.controlador.text.isEmpty;
    // });
  }

  void _toggleTextoObscuro() {
    setState(() {
      _textoObscuro = !_textoObscuro;
    });
  }

  @override
  void dispose() {
    widget.controlador.removeListener(() {});
    super.dispose();
  }

  void _onSubmittedField() {
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
    widget.onSubmited?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controlador,
          obscureText: _textoObscuro,
          keyboardType: widget.tipoTeclado,
          focusNode: widget.focusNode,
          readOnly: widget.apenasLeitura,
          onTap: widget.onTap,
          decoration: InputDecoration(
            labelText: widget.rotulo,
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon:
                widget.textoObscuro
                    ? IconButton(
                      icon: Icon(
                        _textoObscuro ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _toggleTextoObscuro,
                    )
                    : widget.iconeSufixo,
          ),
          onFieldSubmitted: (_) {
            _onSubmittedField();
          },
          validator: (value) {
            if (widget.obrigatorio && (value == null || value.isEmpty)) {
              return 'Este campo é obrigatório';
            }
            if (widget.validator != null) {
              return widget.validator?.call(value);
            }
            if (widget.condicaoErro != null &&
                widget.condicaoErro!.value == false &&
                widget.mensagemErro != null) {
              return widget.mensagemErro;
            }
            return null;
          },
        ),
      ],
    );
  }
}
