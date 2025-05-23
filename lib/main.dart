import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simula la carga de datos
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/surf.gif',
        ), // Reemplaza con la ruta de tu GIF
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherForecast;

  @override
  void initState() {
    super.initState();
    fetchWeatherForecast();
  }

  Future<void> fetchWeatherForecast() async {
    try {
      final data = await WeatherService.getWeatherForecast(
        'Malgrat de Mar, ES',
      );
      setState(() {
        weatherForecast = data;
      });
    } catch (e) {
      print('Error fetching weather forecast: $e');
    }
  }

  String translateWeatherDescription(String description) {
    final Map<String, String> weatherDescriptionTranslations = {
      'clear sky': 'cielo despejado',
      'few clouds': 'pocas nubes',
      'scattered clouds': 'nubes dispersas',
      'broken clouds': 'nubes rotas',
      'shower rain': 'lluvia de chubascos',
      'rain': 'lluvia',
      'thunderstorm': 'tormenta eléctrica',
      'snow': 'nieve',
      'mist': 'niebla',
      'light rain': 'lluvia ligera',
      // Añade más traducciones según sea necesario
    };
    return weatherDescriptionTranslations[description.toLowerCase()] ??
        description;
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  Map<String, List<dynamic>> groupForecastsByDate(List<dynamic> forecasts) {
    Map<String, List<dynamic>> forecastsByDate = {};
    for (var forecast in forecasts) {
      final date = formatDate(forecast['dt_txt']);
      if (!forecastsByDate.containsKey(date)) {
        forecastsByDate[date] = [];
      }
      forecastsByDate[date]!.add(forecast);
    }
    return forecastsByDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'kitesurf en Malgrat de Mar',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/kitesurf.jpeg',
            ), // Reemplaza con la ruta de tu imagen
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            child:
                weatherForecast == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount:
                          groupForecastsByDate(weatherForecast!['list']).length,
                      itemBuilder: (context, index) {
                        final date = groupForecastsByDate(
                          weatherForecast!['list'],
                        ).keys.elementAt(index);
                        final forecasts =
                            groupForecastsByDate(
                              weatherForecast!['list'],
                            )[date];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Fecha: $date',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ...forecasts!.map<Widget>((forecast) {
                              final description =
                                  forecast['weather'][0]['description'];
                              final translatedDescription =
                                  translateWeatherDescription(description);
                              return ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.cloudSun,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Hora: ${forecast['dt_txt'].split(' ')[1]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.temperatureHalf,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Temperatura Aire: ${forecast['main']['temp']}°C',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.water,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Temperatura Agua: ${forecast['main']['sea_temp'] ?? 'N/A'}°C',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.wind,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Viento: ${forecast['wind']['speed']} m/s, ${forecast['wind']['deg']}°, Ráfagas: ${forecast['wind']['gust'] ?? 'N/A'} m/s',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.waveSquare,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Olas: ${forecast['sea']?['wave_height'] ?? 'N/A'} m, Corrientes: ${forecast['sea']?['current'] ?? 'N/A'} kn',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.cloudRain,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Lluvia: ${forecast['rain']?['3h'] ?? '0'} mm, Tormentas: ${forecast['storm']?['probability'] ?? 'N/A'}%',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.sun,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Índice UV: ${forecast['uv_index'] ?? 'N/A'}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.tint,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Mareas: ${forecast['tide']?['height'] ?? 'N/A'} m, Visibilidad: ${forecast['visibility'] ?? 'N/A'} m',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.cloud,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Descripción: $translatedDescription',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
