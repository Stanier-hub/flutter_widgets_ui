
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// InputGenerico
///
/// Um widget personalizado para um campo de entrada de texto.
///
/// [rotulo] O rótulo que será exibido acima do campo de entrada.
///
/// [valorInicial] O valor inicial a ser exibido no campo de entrada.
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
/// [onSubmited] A função a ser chamada quando o campo de entrada é submetido.
///
/// [apenasLeitura] impede teclado de abrir
///
/// [onTap] A função a ser chamada quando o campo de entrada é tocado.
///
/// [onChanged] A função a ser chamada quando o texto do campo de entrada é alterado.
///
/// [desabilitado] Indica se o campo de entrada está desabilitado. O padrão é false.

enum InputTipo { texto, data, competencia, hora, select }

class InputGenerico extends StatefulWidget {
  final InputTipo tipo;
  final String rotulo;
  final String? valorInicial;
  final TextEditingController? controlador;
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
  final Function(String)? onChanged;
  final bool desabilitado;


  const InputGenerico.texto({
    required String rotulo,
    String? valorInicial,
    TextEditingController? controlador,
    bool textoObscuro = false,
    TextInputType tipoTeclado = TextInputType.text,
    Icon? iconePrefixo,
    Icon? iconeSufixo,
    String? mensagemErro,
    ValueNotifier<bool>? condicaoErro,
    bool obrigatorio = false,
    ValueNotifier<bool>? exibirErroObrigatorio,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Function? onSubmited,
    bool apenasLeitura = false,
    Function()? onTap,
    Function(String)? onChanged,
    bool desabilitado = false,
    Key? key,
  }) : this(
    tipo: InputTipo.texto,
    rotulo: rotulo,
    valorInicial: valorInicial,
    controlador: controlador,
    textoObscuro: textoObscuro,
    tipoTeclado: tipoTeclado,
    iconePrefixo: iconePrefixo,
    iconeSufixo: iconeSufixo,
    mensagemErro: mensagemErro,
    condicaoErro: condicaoErro,
    obrigatorio: obrigatorio,
    exibirErroObrigatorio: exibirErroObrigatorio,
    validator: validator,
    focusNode: focusNode,
    nextFocus: nextFocus,
    onSubmited: onSubmited,
    apenasLeitura: apenasLeitura,
    onTap: onTap,
    onChanged: onChanged,
    desabilitado: desabilitado,
    key: key,
  );

  const InputGenerico.data({
    required String rotulo,
    String? valorInicial,
    TextEditingController? controlador,
    Icon? iconePrefixo,
    Icon? iconeSufixo,
    String? mensagemErro,
    ValueNotifier<bool>? condicaoErro,
    bool obrigatorio = false,
    ValueNotifier<bool>? exibirErroObrigatorio,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Function? onSubmited,
    Function()? onTap,
    Function(String)? onChanged,
    bool desabilitado = false,
    Key? key,
  }) : this(
    tipo: InputTipo.data,
    rotulo: rotulo,
    valorInicial: valorInicial,
    controlador: controlador,
    textoObscuro: false,
    tipoTeclado: TextInputType.datetime,
    iconePrefixo: iconePrefixo,
    iconeSufixo: iconeSufixo,
    mensagemErro: mensagemErro,
    condicaoErro: condicaoErro,
    obrigatorio: obrigatorio,
    exibirErroObrigatorio: exibirErroObrigatorio,
    validator: validator,
    focusNode: focusNode,
    nextFocus: nextFocus,
    onSubmited: onSubmited,
    apenasLeitura: true,
    onTap: onTap,
    onChanged: onChanged,
    desabilitado: desabilitado,
    key: key,
  );

  const InputGenerico.competencia({
    required String rotulo,
    String? valorInicial,
    TextEditingController? controlador,
    Icon? iconePrefixo,
    Icon? iconeSufixo,
    String? mensagemErro,
    ValueNotifier<bool>? condicaoErro,
    bool obrigatorio = false,
    ValueNotifier<bool>? exibirErroObrigatorio,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Function? onSubmited,
    Function()? onTap,
    Function(String)? onChanged,
    bool desabilitado = false,
    Key? key,
  }) : this(
    tipo: InputTipo.competencia,
    rotulo: rotulo,
    valorInicial: valorInicial,
    controlador: controlador,
    textoObscuro: false,
    tipoTeclado: TextInputType.datetime,
    iconePrefixo: iconePrefixo,
    iconeSufixo: iconeSufixo,
    mensagemErro: mensagemErro,
    condicaoErro: condicaoErro,
    obrigatorio: obrigatorio,
    exibirErroObrigatorio: exibirErroObrigatorio,
    validator: validator,
    focusNode: focusNode,
    nextFocus: nextFocus,
    onSubmited: onSubmited,
    apenasLeitura: true,
    onTap: onTap,
    onChanged: onChanged,
    desabilitado: desabilitado,
    key: key,
  );

  const InputGenerico.hora({
    required String rotulo,
    String? valorInicial,
    TextEditingController? controlador,
    Icon? iconePrefixo,
    Icon? iconeSufixo,
    String? mensagemErro,
    ValueNotifier<bool>? condicaoErro,
    bool obrigatorio = false,
    ValueNotifier<bool>? exibirErroObrigatorio,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Function? onSubmited,
    Function()? onTap,
    Function(String)? onChanged,
    bool desabilitado = false,
    Key? key,
  }) : this(
    tipo: InputTipo.hora,
    rotulo: rotulo,
    valorInicial: valorInicial,
    controlador: controlador,
    textoObscuro: false,
    tipoTeclado: TextInputType.datetime,
    iconePrefixo: iconePrefixo,
    iconeSufixo: iconeSufixo,
    mensagemErro: mensagemErro,
    condicaoErro: condicaoErro,
    obrigatorio: obrigatorio,
    exibirErroObrigatorio: exibirErroObrigatorio,
    validator: validator,
    focusNode: focusNode,
    nextFocus: nextFocus,
    onSubmited: onSubmited,
    apenasLeitura: true,
    onTap: onTap,
    onChanged: onChanged,
    desabilitado: desabilitado,
    key: key,
  );

  // Para select, pode ser expandido para receber lista de opções
  const InputGenerico.select({
    required String rotulo,
    String? valorInicial,
    TextEditingController? controlador,
    Icon? iconePrefixo,
    Icon? iconeSufixo,
    String? mensagemErro,
    ValueNotifier<bool>? condicaoErro,
    bool obrigatorio = false,
    ValueNotifier<bool>? exibirErroObrigatorio,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Function? onSubmited,
    Function()? onTap,
    Function(String)? onChanged,
    bool desabilitado = false,
    List<String>? opcoes,
    Key? key,
  }) : this(
    tipo: InputTipo.select,
    rotulo: rotulo,
    valorInicial: valorInicial,
    controlador: controlador,
    textoObscuro: false,
    tipoTeclado: TextInputType.text,
    iconePrefixo: iconePrefixo,
    iconeSufixo: iconeSufixo,
    mensagemErro: mensagemErro,
    condicaoErro: condicaoErro,
    obrigatorio: obrigatorio,
    exibirErroObrigatorio: exibirErroObrigatorio,
    validator: validator,
    focusNode: focusNode,
    nextFocus: nextFocus,
    onSubmited: onSubmited,
    apenasLeitura: true,
    onTap: onTap,
    onChanged: onChanged,
    desabilitado: desabilitado,
    key: key,
    opcoes: opcoes,
  );

  // Construtor base privado
  const InputGenerico({
    required this.tipo,
    required this.rotulo,
    this.valorInicial,
    this.controlador,
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
    this.onChanged,
    this.desabilitado = false,
    this.opcoes,
    Key? key,
  }) : super(key: key);

  final List<String>? opcoes;

  @override
  _InputGenericoState createState() => _InputGenericoState();
}

class _InputGenericoState extends State<InputGenerico> {
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
    widget.controlador?.removeListener(() {});
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
    switch (widget.tipo) {
      case InputTipo.data:
        return _buildDataField(context);
      case InputTipo.competencia:
        return _buildCompetenciaField(context);
      case InputTipo.hora:
        return _buildHoraField(context);
      case InputTipo.select:
        return _buildSelectField(context);
      case InputTipo.texto:
      default:
        return _buildTextField(context);
    }
  }

  Widget _buildTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.desabilitado,
          key: widget.key,
          initialValue: widget.valorInicial,
          controller: widget.controlador,
          obscureText: _textoObscuro,
          keyboardType: widget.tipoTeclado,
          focusNode: widget.focusNode,
          readOnly: widget.apenasLeitura,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon: widget.textoObscuro
                ? IconButton(
                    icon: Icon(_textoObscuro ? Icons.visibility : Icons.visibility_off),
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
            if (widget.condicaoErro != null && widget.condicaoErro!.value == false && widget.mensagemErro != null) {
              return widget.mensagemErro;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDataField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.desabilitado,
          key: widget.key,
          controller: widget.controlador,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon: widget.iconeSufixo,
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              String formatted = DateFormat('dd/MM/yyyy').format(picked);
              widget.controlador?.text = formatted;
              widget.onChanged?.call(formatted);
            }
          },
          validator: (value) {
            if (widget.obrigatorio && (value == null || value.isEmpty)) {
              return 'Este campo é obrigatório';
            }
            if (widget.validator != null) {
              return widget.validator?.call(value);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCompetenciaField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.desabilitado,
          key: widget.key,
          controller: widget.controlador,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon: widget.iconeSufixo,
          ),
          onTap: () async {
            final now = DateTime.now();
            int? selectedYear = now.year;
            int? selectedMonth = now.month;
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Selecione competência'),
                  content: Row(
                    children: [
                      DropdownButton<int>(
                        value: selectedMonth,
                        items: List.generate(12, (i) => i + 1)
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m.toString().padLeft(2, '0')),
                                ))
                            .toList(),
                        onChanged: (m) {
                          selectedMonth = m;
                          setState(() {});
                        },
                      ),
                      SizedBox(width: 16),
                      DropdownButton<int>(
                        value: selectedYear,
                        items: List.generate(30, (i) => now.year - 15 + i)
                            .map((y) => DropdownMenuItem(
                                  value: y,
                                  child: Text(y.toString()),
                                ))
                            .toList(),
                        onChanged: (y) {
                          selectedYear = y;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedMonth != null && selectedYear != null) {
                          String competencia = '${selectedMonth.toString().padLeft(2, '0')}/${selectedYear.toString()}';
                          widget.controlador?.text = competencia;
                          widget.onChanged?.call(competencia);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          validator: (value) {
            if (widget.obrigatorio && (value == null || value.isEmpty)) {
              return 'Este campo é obrigatório';
            }
            if (widget.validator != null) {
              return widget.validator?.call(value);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHoraField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.desabilitado,
          key: widget.key,
          controller: widget.controlador,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon: widget.iconeSufixo,
          ),
          onTap: () async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              String formatted = picked.format(context);
              widget.controlador?.text = formatted;
              widget.onChanged?.call(formatted);
            }
          },
          validator: (value) {
            if (widget.obrigatorio && (value == null || value.isEmpty)) {
              return 'Este campo é obrigatório';
            }
            if (widget.validator != null) {
              return widget.validator?.call(value);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSelectField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: widget.valorInicial,
          items: widget.opcoes?.map((op) => DropdownMenuItem(
            value: op,
            child: Text(op),
          )).toList(),
          onChanged: widget.desabilitado ? null : (v) {
            widget.controlador?.text = v ?? '';
            widget.onChanged?.call(v ?? '');
          },
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            border: const OutlineInputBorder(),
            prefixIcon: widget.iconePrefixo,
            suffixIcon: widget.iconeSufixo,
          ),
          validator: (value) {
            if (widget.obrigatorio && (value == null || value.isEmpty)) {
              return 'Este campo é obrigatório';
            }
            if (widget.validator != null) {
              return widget.validator?.call(value);
            }
            return null;
          },
        ),
      ],
    );
  }
}
