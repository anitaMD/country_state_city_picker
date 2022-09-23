import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country State and City Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? countryValue;
  String? stateValue;
  String? cityValue;
  int totalStates = 0, totalCities = 0;

  void displayMsg(msg) {
    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State and City Picker'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 600,
          child: Column(
            children: [
              SizedBox(height: 30.0),
              SelectState(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0))),
                    contentPadding: EdgeInsets.all(5.0)),
                spacing: 25.0,
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                  print("SELECTED COUNTRY: $countryValue");
                },
                onCountryTap: () => displayMsg('You\'ve tapped on countries!'),
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                  print("SELECTED STATE: $stateValue");
                },
                onStateTap: () => displayMsg('You\'ve tapped on states!'),
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                  print("SELECTED city: $cityValue");
                },
                onCityTap: () => displayMsg('You\'ve tapped on cities!'),
                onCityLengthChanged: (int value) {
                  setState(() {
                    totalCities = value;
                    print("TOTAL CITIES OR DEPARTMENT: $totalCities");
                  });
                },
                onStateLengthChanged: (int value) {
                  setState(() {
                    totalStates = value;
                    print("TOTAL STATES/REGIONSORCITY: $totalStates");
                  });
                },
              ),
              // InkWell(
              //     onTap: () {
              //       print('country selected is $countryValue');
              //       print('country selected is $stateValue');
              //       print('country selected is $cityValue');
              //     },
              //     child: Text(' Check'))
            ],
          )),
    );
  }
}
