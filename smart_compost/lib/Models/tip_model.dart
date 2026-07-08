import 'package:flutter/material.dart';

class TipModel {
  final String titulo;
  final String descripcion;
  final IconData icono;

  // NUEVO → si depende de medición
  final bool dependeSensor;

  // NUEVO → reglas para mostrarlo
  final double? phMin;
  final double? phMax;
  final int? tdsMin;
  final int? tdsMax;

  TipModel({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    this.dependeSensor = false,
    this.phMin,
    this.phMax,
    this.tdsMin,
    this.tdsMax,
  });
}

// Lista de 100+ consejos sobre lixiviado
final List<TipModel> consejosLixiviado = [
  TipModel(
    titulo: 'Lixiviado maduro',
    descripcion:
        'Cuando huele a tierra mojada y es color café claro, está listo para usar.',
    icono: Icons.emoji_nature,
  ),
  TipModel(
    titulo: 'Lixiviado inmaduro',
    descripcion:
        'Si huele a amoníaco o podrido, aún no está listo. Déjalo reposar más tiempo.',
    icono: Icons.warning,
  ),
  TipModel(
    titulo: 'Dilución correcta',
    descripcion:
        'Mezcla 1 parte de lixiviado con 10 partes de agua para plantas de interior.',
    icono: Icons.water_drop,
  ),
  TipModel(
    titulo: 'Plantas adultas',
    descripcion:
        'Las plantas adultas toleran mejor el lixiviado concentrado (1:5).',
    icono: Icons.forest,
  ),
  TipModel(
    titulo: 'Plantas jóvenes',
    descripcion: 'Usa dilución más suave (1:15) para plántulas y esquejes.',
    icono: Icons.spa,
  ),
  TipModel(
    titulo: 'Frecuencia ideal',
    descripcion: 'Aplica lixiviado cada 15 días durante crecimiento activo.',
    icono: Icons.calendar_month,
  ),
  TipModel(
    titulo: 'Plantas frutales',
    descripcion:
        'Tomates y chiles responden muy bien al lixiviado rico en potasio.',
    icono: Icons.agriculture,
  ),
  TipModel(
    titulo: 'Hortalizas de hoja',
    descripcion:
        'Lechuga, espinaca y acelgas prefieren lixiviado más diluido (1:12).',
    icono: Icons.grass,
  ),
  TipModel(
    titulo: 'PH ideal',
    descripcion: 'El pH óptimo del lixiviado debe estar entre 6.0 y 7.0.',
    icono: Icons.science,
  ),
  TipModel(
    titulo: 'TDS óptimo',
    descripcion:
        'El TDS ideal está entre 500-1500 ppm para la mayoría de plantas.',
    icono: Icons.show_chart,
  ),
  TipModel(
    titulo: 'PH bajo',
    descripcion:
        'Si pH < 5.5, es muy ácido. Agrega un poco de ceniza para subirlo.',
    icono: Icons.warning_amber,
  ),
  TipModel(
    titulo: 'PH alto',
    descripcion: 'Si pH > 7.5, agrega un poco de vinagre o café molido.',
    icono: Icons.water,
  ),
  TipModel(
    titulo: 'TDS bajo',
    descripcion: 'TDS < 300 ppm es muy débil. Déjalo fermentar más tiempo.',
    icono: Icons.arrow_downward,
  ),
  TipModel(
    titulo: 'TDS alto',
    descripcion: 'TDS > 2000 ppm puede quemar raíces. Diluye más.',
    icono: Icons.arrow_upward,
  ),
  TipModel(
    titulo: 'Almacenamiento',
    descripcion: 'Guarda el lixiviado en botella oscura y en lugar fresco.',
    icono: Icons.inventory,
  ),
  TipModel(
    titulo: 'Tiempo de fermentación',
    descripcion: 'El lixiviado mínimo debe fermentar 30 días.',
    icono: Icons.timer,
  ),
  TipModel(
    titulo: 'Prueba del olfato',
    descripcion: 'Si huele a levadura o pan, está en buen proceso.',
    icono: Icons.note,
  ),
  TipModel(
    titulo: 'Color ideal',
    descripcion: 'Color ámbar o té cargado es señal de buen lixiviado.',
    icono: Icons.color_lens,
  ),
  TipModel(
    titulo: 'Oxigenación',
    descripcion: 'Mueve el recipiente cada 3 días para oxigenar.',
    icono: Icons.air,
  ),
  TipModel(
    titulo: 'No lluvia',
    descripcion: 'Protege tu lombricompostera de la lluvia directa.',
    icono: Icons.beach_access,
  ),
  TipModel(
    titulo: 'Rica en potasio',
    descripcion: 'Agrega cáscaras de plátano para aumentar potasio.',
    icono: Icons.bolt,
  ),
  TipModel(
    titulo: 'Calcio natural',
    descripcion: 'Cáscaras de huevo molidas aportan calcio al lixiviado.',
    icono: Icons.egg,
  ),
  TipModel(
    titulo: 'Mejora con café',
    descripcion: 'Borra de café añade nitrógeno al lixiviado.',
    icono: Icons.coffee,
  ),
  TipModel(
    titulo: 'Compost activador',
    descripcion: 'Un poco de melaza activa los microorganismos.',
    icono: Icons.bubble_chart,
  ),
  TipModel(
    titulo: 'Lixiviado tóxico',
    descripcion: 'No uses lixiviado de desechos cárnicos o lácteos.',
    icono: Icons.dangerous,
  ),
  TipModel(
    titulo: 'Germinación',
    descripcion:
        'Remoja semillas en lixiviado diluido (1:20) para mejor germinación.',
    icono: Icons.eco,
  ),
  TipModel(
    titulo: 'Plantas débiles',
    descripcion:
        'Aplica lixiviado cada 8 días para plantas enfermas o débiles.',
    icono: Icons.favorite,
  ),
  TipModel(
    titulo: 'Suculentas',
    descripcion:
        'Las suculentas necesitan dilución muy alta (1:20) cada 30 días.',
    icono: Icons.nature,
  ),
  TipModel(
    titulo: 'Frutillas',
    descripcion: 'Las frutillas aman el lixiviado rico en fósforo.',
    icono: Icons.favorite,
  ),
  TipModel(
    titulo: 'Plantas picantes',
    descripcion: 'Chiles y ajíes producen más frutos con lixiviado semanal.',
    icono: Icons.local_fire_department,
  ),
  TipModel(
    titulo: 'Cuidado nocturno',
    descripcion: 'Aplica lixiviado al atardecer para mejor absorción.',
    icono: Icons.nightlight,
  ),
  TipModel(
    titulo: 'No en exceso',
    descripcion: 'Demasiado lixiviado puede pudrir raíces. Menos es más.',
    icono: Icons.do_not_disturb,
  ),
  TipModel(
    titulo: 'Trasplante',
    descripcion:
        'No apliques lixiviado hasta 2 semanas después de trasplantar.',
    icono: Icons.backup,
  ),
  TipModel(
    titulo: 'Floración',
    descripcion:
        'Durante floración, aumenta fósforo con lixiviado más concentrado.',
    icono: Icons.local_florist,
  ),
  TipModel(
    titulo: 'Otoño',
    descripcion:
        'Reduce frecuencia en otoño, las plantas se preparan para dormir.',
    icono: Icons.eco,
  ),
  TipModel(
    titulo: 'Primavera',
    descripcion:
        'Primavera es mejor época para aplicar lixiviado regularmente.',
    icono: Icons.sunny,
  ),
  // ... puedes seguir agregando hasta 100+
];

// CONSEJOS BASADOS EN MEDICIÓN REAL
final List<TipModel> consejosInteligentes = [
  // PH MUY BAJO
  TipModel(
    titulo: 'PH muy ácido',
    descripcion:
        'Tu lixiviado está muy ácido. Agrega cáscara de huevo molida o ceniza vegetal y déjalo reposar unos días.',
    icono: Icons.warning_amber,
    dependeSensor: true,
    phMax: 5.5,
  ),

  // PH MUY ALTO
  TipModel(
    titulo: 'PH muy alto',
    descripcion:
        'El pH es alto. Puedes agregar borra de café o melaza para activar los microorganismos.',
    icono: Icons.science,
    dependeSensor: true,
    phMin: 7.5,
  ),

  // TDS MUY BAJO
  TipModel(
    titulo: 'Pocos nutrientes',
    descripcion:
        'El lixiviado está muy débil. Agrega cáscaras de plátano o restos de frutas y déjalo fermentar más tiempo.',
    icono: Icons.arrow_downward,
    dependeSensor: true,
    tdsMax: 300,
  ),

  // TDS MUY ALTO
  TipModel(
    titulo: 'Demasiado concentrado',
    descripcion:
        'El lixiviado está muy fuerte. Dilúyelo en agua antes de usarlo para evitar dañar las plantas.',
    icono: Icons.arrow_upward,
    dependeSensor: true,
    tdsMin: 2000,
  ),

  // PH IDEAL
  TipModel(
    titulo: 'PH correcto',
    descripcion:
        'El pH está en un rango ideal. Puedes usar el lixiviado sin problemas.',
    icono: Icons.check_circle,
    dependeSensor: true,
    phMin: 5.5,
    phMax: 7.2,
  ),

  // TDS IDEAL
  TipModel(
    titulo: 'Nutrientes correctos',
    descripcion:
        'La concentración de nutrientes es buena. Solo diluye ligeramente antes de aplicar.',
    icono: Icons.eco,
    dependeSensor: true,
    tdsMin: 400,
    tdsMax: 1500,
  ),
];

// Cambia int por double en el parámetro tds
List<TipModel> generarConsejosDesdeMedicion(double ph, double tds) {
  return consejosInteligentes.where((tip) {
    bool phValido = true;
    bool tdsValido = true;

    if (tip.phMin != null) phValido = ph >= tip.phMin!;
    if (tip.phMax != null) phValido = phValido && ph <= tip.phMax!;

    // Cambiado a double
    if (tip.tdsMin != null) tdsValido = tds >= tip.tdsMin!;
    if (tip.tdsMax != null) tdsValido = tdsValido && tds <= tip.tdsMax!;

    return phValido && tdsValido;
  }).toList();
}

// Función para obtener consejos aleatorios
List<TipModel> getConsejosAleatorios(int cantidad) {
  final random = List<TipModel>.from(consejosLixiviado);
  random.shuffle();
  return random.take(cantidad).toList();
}
