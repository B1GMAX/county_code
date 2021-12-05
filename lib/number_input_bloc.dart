import 'dart:convert';
import 'package:county_code/country_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class NumberInputBloc {
  NumberInputBloc() {
    _determinePosition();
    _getCountryData();
    numberController.addListener(() {
      _buttonChange();
    });
    inputTextController.addListener(() {
      countriesStreamController.add(countryInformation
          .where((element) =>
              element.countryName
                  .toLowerCase()
                  .startsWith(inputTextController.text.toLowerCase()) ||
              element.shortNumber
                  .toLowerCase()
                  .startsWith(inputTextController.text.toLowerCase()))
          .toList());
    });
  }

  late final String _currentAddress;

  final BehaviorSubject<bool> textStreamController = BehaviorSubject();

  Stream<bool> get textStream => textStreamController.stream;

  final BehaviorSubject<List<CountryInformation>> countriesStreamController =
      BehaviorSubject();

  Stream<List<CountryInformation>> get countriesStream =>
      countriesStreamController.stream;

  final BehaviorSubject<CountryInformation> takeCountryStreamController =
      BehaviorSubject();

  Stream<CountryInformation> get takeCountryStream =>
      takeCountryStreamController.stream;

  Sink<CountryInformation> get takeCountrySink =>
      takeCountryStreamController.sink;

  final TextEditingController numberController =
      MaskedTextController(mask: '(000)000-0000');

  final TextEditingController inputTextController = TextEditingController();

  final List<CountryInformation> countryInformation = [];

  void _buttonChange() {
    textStreamController.add(numberController.text.length < 13);
  }

  void _getCountryData() async {
    final response = await get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final List json = jsonDecode(responseBody);
      for (int i = 0; i < json.length; i++) {
        final Map<String, dynamic> map = json[i];
        final Map<String, dynamic> name = map['name'];
        final String countryName = name['common'];
        final Map<String, dynamic> idd = map['idd'] ?? '';
        final String startNumber = idd['root'] ?? '';
        final List listOfNumber = idd['suffixes'] ?? [];
        final String secondNumber =
            listOfNumber.isNotEmpty ? listOfNumber[0] : '';
        final Map<String, dynamic> flags = map['flags'];
        final String countryFlag = flags['png'] ?? '';
        countryInformation.add(CountryInformation(
          countryFlag: countryFlag,
          countryName: countryName,
          shortNumber: startNumber + secondNumber,
        ));
      }
    }
    countriesStreamController.add(countryInformation);
  }

  void _determinePosition() async {
    final bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');
    final Placemark place = placemarks[0];
    _currentAddress = place.country.toString();
    takeCountryStreamController.add(countryInformation
        .where((element) => element.countryName == _currentAddress)
        .toList()
        .first);
  }

  void dispose() {
    numberController.clear();
    inputTextController.clear();
    textStreamController.close();
    countriesStreamController.close();
  }
}
