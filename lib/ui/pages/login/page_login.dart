import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/ui/pages/custom/page_custom.dart';
import 'package:novo_ponto_alfa/ui/pages/login/ctrl_login.dart';
import 'package:novo_ponto_alfa/ui/pages/login/page_view/page_view_botoes.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoYPosition;
  late Animation<double> _buttonsOpacity;
  late CtrlLogin ctrlLogin;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoYPosition = Tween<double>(begin: -50, end: -300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _buttonsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
        _controller.forward();
      });
    });

    ctrlLogin = CtrlLogin();
    // ctrlLogin.inicializar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    PageController pageController = PageController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageCustom(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: PageViewBotoes(
                pageController: pageController,
                ctrlLogin: ctrlLogin,
              ),
            ),
            _addVersao(),
          ],
        ),
      ),
    );
  }

  Widget _addVersao() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "IMEI: 123456789",
          style: context.textTheme.titleMedium,
        ), Text(
          "Versao: 4.0.0",
          style: context.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _addLogo(double screenHeight) {
    return Image.asset(
      "assets/img/clock-logo.png",
      height: 100,
    );
  }
}
