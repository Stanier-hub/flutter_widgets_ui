import 'dart:convert';
import 'dart:io';
import 'package:flutter_widgets_ui/commons/cores_padrao_ui.dart';
import 'package:flutter_widgets_ui/commons/models/mensagem_erro_request.dart';
import 'package:flutter_widgets_ui/commons/models/model.dart';
import 'package:flutter_widgets_ui/service/servico_padrao.dart';
import 'package:flutter_widgets_ui/commons/widgets/Base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AcaoEspecialCallBack<T> = bool? Function();
typedef BuscarModeloCallBack<T> = T? Function();

typedef ConstruirDadosCallback = Map<String, dynamic> Function();

typedef AoConcluirCallBack = void Function();
typedef OnPodeSalvar = bool Function();

class FormularioGenerico<T extends Model, S extends SevicePadrao>
    extends StatefulWidget {
  final T? modelo;
  final AcaoEspecialCallBack? acaoEspecialCallBack;
  final BuscarModeloCallBack<T>? buscaModelo;
  final S? servico;
  final void Function(T)? onSalvar;
  final List<Widget> campos;
  final String? textoBotao;
  final ConstruirDadosCallback construirDados;
  final AoConcluirCallBack? aoConcluir;
  final OnPodeSalvar? onPodeSalvar;
  final Color? backgroundColor;
  final Color? corTextoBotaoSalvar;

  const FormularioGenerico({
    super.key,
    this.modelo,
    this.acaoEspecialCallBack,
    this.buscaModelo,
    required this.servico,
    this.onSalvar,
    required this.campos,
    this.textoBotao,
    required this.construirDados,
    this.aoConcluir,
    this.onPodeSalvar,
    this.backgroundColor,
    this.corTextoBotaoSalvar,
  });

  @override
  State<FormularioGenerico<T, S>> createState() =>
      _FormularioGenericoState<T, S>();
}

class _FormularioGenericoState<T extends Model, S extends SevicePadrao>
    extends State<FormularioGenerico<T, S>> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Base(
      paddingBase: const EdgeInsets.only(top: 10),
      componente: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...widget.campos.map(
                      (campo) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: campo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return; // Se o formulário não for válido, não prossegue.
                  }

                  final bool podeContinuar =
                      widget.acaoEspecialCallBack?.call() ?? true;
                  if (!podeContinuar) return;

                  final T? modelo = widget.modelo ?? widget.buscaModelo?.call();
                  final S? servico = widget.servico;
                  try {
                    if (servico != null) {
                      if (modelo == null) {
                        final T novoModelo = await servico.criar(
                          dados: widget.construirDados(),
                        );
                        _Mensagem.exibir<T>(
                          context: context,
                          modelo: novoModelo,
                          tipo: 'criada',
                        );
                      } else {
                        final Map<String, dynamic> dados =
                            widget.construirDados();

                        await servico.atualizar(
                          modelo: modelo,
                          dados: dados.isEmpty ? modelo.toJson() : dados,
                        );

                        _Mensagem.exibir<T>(
                          context: context,
                          modelo: modelo,
                          tipo: 'atualizada',
                        );
                      }
                      widget.aoConcluir?.call();
                      return;
                    }

                    if (modelo != null) {
                      widget.onSalvar?.call(modelo);
                    }
                  } on HttpException catch (e) {
                    final MensagemErroRequest erro =
                        MensagemErroRequest.fromJson(jsonDecode(e.message));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(erro.mensagem),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (erro, stackTrace) {
                    if (kDebugMode) {
                      print('Erro genérico: "$erro".');
                      print('Stack trace:\n$stackTrace');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.backgroundColor ?? CoresPadraoUi.ascent,
                ),
                child: Text(
                  widget.textoBotao ?? 'Salvar',
                  style: TextStyle(
                    color:
                        widget.corTextoBotaoSalvar ?? CoresPadraoUi.whiteSmoke,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mensagem {
  static void exibir<T extends Model>({
    required BuildContext context,
    required T? modelo,
    Color cor = Colors.green,
    String? mensagem,
    required String tipo,
  }) {
    late final String texto;
    if (modelo == null) {
      texto = mensagem ?? '';
    } else {
      texto =
          "${modelo.modeloString} ${modelo.modeloString.endsWith('a') ? tipo : tipo.replaceFirst(RegExp(r'.$'), 'o')} com sucesso";
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }
}
