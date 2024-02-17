import 'package:flutter/material.dart';
 import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherapp/ui/screen2.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(useInheritedMediaQuery: true,debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87,elevation: 0,
        title: Center(child: Text('Weather App',style: GoogleFonts.aBeeZee(color: Colors.white),)),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Screen2()));
          }, icon: Icon(Icons.search,color: Colors.white,))
        ],
      ),

      body: Container(constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/tree-silhouetted-against-night-sky-with-nebula.jpg"),
            fit: BoxFit.fill,
            ),),
        child: Center(
          child: WeatherWidget(),

        ),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _location = '';
  String _temperature = '';
  String _weatherCondition = '';
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String url =
          'https://api.openweathermap.org/data/2.5/weather?lat=10.93&lon=76.00&appid=ac0797a458f376e58b5fcf709618283f'; // Corrected URL
      http.Response response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _location = '${data['name']}, ${data['sys']['country']}';
        _temperature = '${data['main']['temp']}°C';
        _weatherCondition = data['weather'][0]['main'];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather data';
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _loading
            ? CircularProgressIndicator()
            : Column(
          children: <Widget>[
            SvgPicture.asset(
              "assets/weathericon/day.svg",
              width: 150,
              height: 150,
            ),
            SizedBox(height: 10),
            Text(
              _location,
              style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _temperature,
              style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () => _fetchWeatherData(),
          child: Text('Refresh',style: GoogleFonts.aBeeZee(color: Colors.white),),
        ),
        SizedBox(height: 20),
        Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}