import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:previsao_tempo/telas/tela_cidade.dart';
import 'package:previsao_tempo/transacoes/pega_clima.dart';

import 'package:previsao_tempo/util/util.dart' as util;

class Climinha extends StatefulWidget {
  @override
  _CliminhaState createState() => _CliminhaState();
}

class _CliminhaState extends State<Climinha> {
  String _cidadeIncerida;
  String _humidade;
  String _minGrau;
  String _maxGrau;

  Future _abriNovaTela(BuildContext context) async {
    Map resultado = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new MudarCidade();
    }));
    setState(() {
      if (resultado != null && resultado.containsKey('cidade')) {
        _cidadeIncerida = resultado['cidade'];
        debugPrint("Cidade $_cidadeIncerida");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Climinha Top",
        ),
        backgroundColor: Colors.indigoAccent[400],
        actions: [
          IconButton(
              icon: Icon(Icons.menu), onPressed: () => _abriNovaTela(context))
        ],
      ),

      /**
       * FOTOS NO PLANO DE FUNDO,
       *
       * @Stack - renderiza os elementos uma acima do outro
       *
       * @fit - Elemento da imagem, para estender as partes verticais da imagem;
       * */
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/umbrella.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit
                  .fill, // fill, estende apenas a parte superior e inferior
            ),
          ),
          /**
           * Mensagem top direito
           *
           * @Row - usado para poder ultilizar o 'mainAxisAlignment'
           * */
          Container(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${_cidadeIncerida == null ? util.minhaCidade : _cidadeIncerida}",
                    style: styleCidade(),
                  )
                ],
              )),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/light_rain.png'),
          ),
          atualizarTempoWidget(_cidadeIncerida)
        ],
      ),
    );
  }

  /**
   * Metodo para atualizar o tempo consumido de uma API
   * @return um Widget FutureBuilder
   *
   * @FutureBuilder - pois ela da suporte ao Future
   *
   * */
  Widget atualizarTempoWidget(String cidade) {
    return FutureBuilder(
        //chama a função q retornara o Future
        future:
            pegaClima(util.appId, cidade == null ? util.minhaCidade : cidade),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            //Se tiver dados
            Map conteudo = snapshot.data;

            _humidade = conteudo['main']['humidity'].toString();
            _minGrau = conteudo['main']['temp_min'].toString();
            _maxGrau = conteudo['main']['temp_max'].toString();

            return Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      conteudo['main']['temp'].toString() + "ºC",
                      style: tempStyle(),
                    ),
                    subtitle: ListTile(
                      title: Text(
                        "Humidade: ${_humidade}\n"
                        "Min: ${_minGrau} C\n"
                        "Max: ${_maxGrau} C ",
                        style: extraTemp(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              child: Text('Falhou!'),
            );
          }
        });
  }

  TextStyle extraTemp() {
    return TextStyle(
        color: Colors.white70, fontStyle: FontStyle.normal, fontSize: 19.0);
  }

  TextStyle styleCidade() {
    return TextStyle(
        color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
  }

  TextStyle tempStyle() {
    return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 49.9,
        fontStyle: FontStyle.normal);
  }
}
