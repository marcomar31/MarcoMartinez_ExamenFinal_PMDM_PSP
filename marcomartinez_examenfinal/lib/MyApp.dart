import 'package:flutter/material.dart';
import 'package:marcomartinez_examenfinal/Main/ActividadView.dart';
import 'package:marcomartinez_examenfinal/Main/BoredApiView.dart';
import 'package:marcomartinez_examenfinal/Main/CreaActividadView.dart';
import 'package:marcomartinez_examenfinal/Main/MapaView.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/CreaPerfilView.dart';
import 'package:marcomartinez_examenfinal/OnBoarding/OnBoarding.dart';

import 'Main/ConfiguracionView.dart';
import 'Main/HomeView.dart';
import 'Main/PerfilView.dart';
import 'OnBoarding/LoginView.dart';
import 'OnBoarding/RegisterView.dart';
import 'Singleton/PlatformAdmin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialApp materialApp = const MaterialApp();
    if(PlatformAdmin.isAndroidPlatform() || PlatformAdmin.isIOSPlatform()) {
      materialApp = MaterialApp(title: "Examen Marco 2Ev (Móvil)",
        routes: {
          '/onboarding_view': (context) => OnBoarding(),
          '/login_view': (context) => const LoginView(),
          '/register_view': (context) => RegisterView(),
          '/creaperfil_view': (context) => const CreaPerfilView(),
          '/home_view': (context) => const HomeView(),
          '/boredapi_view': (context) => BoredApiView(),
          '/configuracion_view': (context) => const ConfiguracionView(),
          '/creaactividad_view': (context) => const CreaActividadView(),
          '/perfil_view': (context) => const PerfilView(),
          '/actividad_view': (context) => const ActividadView(),
          '/mapa_view': (context) => const MapaView(),
        },
        initialRoute: '/onboarding_view',
        debugShowCheckedModeBanner: false,
      );
    } else if (PlatformAdmin.isWebPlatform()) {
      materialApp = MaterialApp(title: "Examen Marco 2Ev (Web)",
        routes: {
          '/onboarding_view': (context) => OnBoarding(),
          '/login_view': (context) => const LoginView(),
          '/register_view': (context) => RegisterView(),
          '/creaperfil_view': (context) => const CreaPerfilView(),
          '/home_view': (context) => const HomeView(),
          '/boredapi_view': (context) => BoredApiView(),
          '/configuracion_view': (context) => const ConfiguracionView(),
          '/creaactividad_view': (context) => const CreaActividadView(),
          '/perfil_view': (context) => const PerfilView(),
          '/actividad_view': (context) => const ActividadView(),
        },
        initialRoute: '/onboarding_view',
        debugShowCheckedModeBanner: false,
      );
    }

    return materialApp;
  }
  
}