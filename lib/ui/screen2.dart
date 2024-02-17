import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() =>_Screen2State();
}

class _Screen2State extends State<Screen2 > {
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  String _weatherData = '';
  bool _isLoading = false;

  Future<void> _searchWeather(String city, String country) async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = 'ac0797a458f376e58b5fcf709618283f';
    final apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city,$country&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      setState(() {
        _weatherData = 'Temperature: ${decodedData['main']['temp']}°C\nWeather: ${decodedData['weather'][0]['main']}';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherData = 'Failed to fetch weather data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Enter country',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchWeather(_cityController.text, _countryController.text);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _weatherData,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}