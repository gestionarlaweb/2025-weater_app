# Weather Forecast App

Una aplicación de pronóstico del tiempo para navegantes en Malgrat de Mar, que proporciona información detallada sobre el viento, el estado del mar, la previsión de tormentas y lluvia, la temperatura del agua y del aire, el índice UV, las mareas y la visibilidad.

## Características

- **Pronóstico del Tiempo:** Obtén el pronóstico del tiempo para los próximos días.
- **Datos del Viento:** Información sobre la intensidad, dirección y ráfagas del viento.
- **Estado del Mar:** Datos sobre las olas y corrientes.
- **Previsión de Tormentas y Lluvia:** Información sobre la probabilidad de tormentas y lluvia.
- **Temperatura del Agua y Aire:** Temperaturas actuales del agua y del aire.
- **Índice UV:** Información sobre el índice UV.
- **Mareas y Visibilidad:** Datos sobre las mareas y la visibilidad.

## Requisitos Previos

- Flutter SDK
- Dart SDK
- Una clave API de OpenWeatherMap

## Configuración

1. **Clonar el Repositorio:**

   ```bash
   git clone https://github.com/tu_usuario/weather_forecast_app.git
   cd weather_forecast_app

2. **Instalar Dependencias:**
   flutter pub get

3. **Configurar la Clave API:**

Abre el archivo lib/weather_service.dart.

Reemplaza 'TU_CLAVE_API' con tu clave API de OpenWeatherMap.

Copiar
static const String apiKey = 'TU_CLAVE_API';