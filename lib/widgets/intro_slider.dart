import 'package:buscador_produtos/view/detail_store.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroSliderWidget extends StatelessWidget {
  dynamic user;
  IntroSliderWidget(this.user);
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: _getSlides(),
      isScrollable: false,
      nameDoneBtn: 'Entendi!',
      nameNextBtn: 'Próximo',
      namePrevBtn: 'Anterior',
      isShowSkipBtn: false,
      
      isShowPrevBtn: true,
      onDonePress: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DetailStore(true, user)));
      },
    );
  }

  List<Slide> _getSlides() {
    List<Slide> slides = new List();
    slides.add(
      new Slide(
        title: "Anuncie seus Produtos",
        description:
            " - Coloque seus melhores produtos para chamar a atenção do cliente, quanto mais produtos você colocar melhor." +
                "\n\n - Veja as solicitações de reservas de produtos." +
                "\n\n - Preencha as fotos e detalhes do produto da forma mais detalhada possível",
        backgroundColor: Colors.red[800],
      ),
    );
    slides.add(
      new Slide(
        title: "Dados da sua loja",
        description:
            "Antes de você receber clientes, você precisa preencher os detalhes da sua loja, " +
                "como fotos do local, endereço, email e telefone, só a partir disso sua loja começará a aparecer para as outras pessoas.",
        backgroundColor: Colors.blue[800],
      ),
    );

    return slides;
  }
}
