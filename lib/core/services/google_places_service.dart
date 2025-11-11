import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import '../models/place_details.dart';
import 'package:http/http.dart' as http;
import '../models/address_location_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iatros_web/core/api/center_api.dart';

class GooglePlacesService extends CenterApi {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  static String? get _apiKey => dotenv.env['GOOGLE_PLACES_API_KEY'];

  /// Obtiene los detalles completos de un lugar usando su place_id
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('GOOGLE_PLACES_API_KEY no está configurada en .env');
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/details/json?place_id=$placeId&key=$_apiKey&language=es&fields=place_id,formatted_address,geometry',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];
          if (result != null) {
            return PlaceDetails.fromJson(result);
          }
        } else {
          throw Exception('Google Places API: ${data['status']}');
        }
      } else {
        throw Exception('Error al obtener detalles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getPlaceDetails: $e');
      rethrow;
    }

    return null;
  }

  /// Busca direcciones usando Google Places API para web
  Future<List<AddressLocationModel>> searchAddressWeb(String search) async {
    try {
      final google = js.context['google'];
      if (google == null ||
          google['maps'] == null ||
          google['maps']['places'] == null) {
        print('Google Places API not loaded, falling back to Firebase');
        return await _fallbackToFirebaseFunction(search);
      }

      // Crear un servicio de autocompletado
      final autocompleteService = js.JsObject(
        js.context['google']['maps']['places']['AutocompleteService'],
      );

      // Crear la solicitud
      final request = js.JsObject.jsify({
        'input': search,
        'types': ['geocode'],
        'language': 'es',
      });

      // Hacer la solicitud de forma asíncrona
      final completer = Completer<List<AddressLocationModel>>();

      autocompleteService.callMethod('getPlacePredictions', [
        request,
        js.allowInterop((predictions, status) {
          if (status == 'OK' && predictions != null) {
            final List<AddressLocationModel> results = [];
            for (int i = 0; i < predictions['length']; i++) {
              final prediction = predictions[i];
              results.add(AddressLocationModel(
                placeId: prediction['place_id'] ?? '',
                description: prediction['description'] ?? '',
                mainText: prediction['structured_formatting']?['main_text'] ?? '',
                secondaryText: prediction['structured_formatting']?['secondary_text'] ?? '',
                lat: null,
                lng: null,
              ));
            }
            completer.complete(results);
          } else {
            print('Google Places API error: $status');
            completer.complete([]);
          }
        })
      ]);

      return await completer.future;
    } catch (e) {
      print('Error in web implementation: $e');
      return await _fallbackToFirebaseFunction(search);
    }
  }

  /// Fallback a Firebase Function cuando Google Places API no está disponible
  Future<List<AddressLocationModel>> _fallbackToFirebaseFunction(String search) async {
    try {
      // Implementar llamada a Firebase Function aquí
      // Por ahora retorna lista vacía
      print('Fallback to Firebase Function for search: $search');
      return [];
    } catch (e) {
      print('Error in Firebase fallback: $e');
      return [];
    }
  }
}
