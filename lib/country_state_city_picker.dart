library country_state_city_picker_nona;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'model/select_status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<int> onStateLengthChanged;
  final ValueChanged<int> onCityLengthChanged;
  final VoidCallback? onCountryTap;
  final VoidCallback? onStateTap;
  final VoidCallback? onCityTap;
  final TextStyle? style;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;

  SelectState({
    Key? key,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.onStateChanged,
    required this.onCityLengthChanged,
    required this.onStateLengthChanged,
    this.decoration =
        const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
    this.spacing = 0.0,
    this.style,
    this.dropdownColor,
    this.onCountryTap,
    this.onStateTap,
    this.onCityTap,
  }) : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _citiesOrDepartments = ["Select Reg. City/Department"];
  List<String> _country = ["Select Reg. Country"];
  List<String> _statesOrCities = ["Select Reg. State/City"];

  String _selectedCityOrDepartment =
      "Select Reg. City/Department"; //example city if it's the USA and department for SN
  String _selectedCountry = "Select Reg. Country";
  String _selectedStateOrCity = "Select Reg. State/City";
  var responses;
  int allCountries = 0, allStatesProvinces = 0, allCities = 0;

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        allCountries = countryres.length;
        _country.add(model.emoji! + "    " + model.name!);
      });
    });

    return _country;
  }

  Future getStateOrCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;

    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        allStatesProvinces = name.length;
        this.widget.onStateLengthChanged(allStatesProvinces);
        print("allStates or Cities NO DROPDOWN ${name.length}");
        for (var statename in name) {
          print(statename.toString());

          _statesOrCities.add(statename.toString());
        }
      });
    });

    return _statesOrCities;
  }

  Future getCityOrDepartment() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedStateOrCity);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          allCities = citiesname.length;
          this.widget.onStateLengthChanged(allCities);
          print("allCities/Departments NO DROPDOWN ${allCities}");
          for (var citynames in citiesname) {
            print(citynames.toString());

            _citiesOrDepartments.add(citynames.toString());
          }
        });
      });
    });
    return _citiesOrDepartments;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      _selectedStateOrCity = "Select Reg. State/City";
      _statesOrCities = ["Select Reg. State/City"];
      _selectedCountry = value;
      this.widget.onCountryChanged(value);
      getStateOrCity();
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCityOrDepartment =
          "Select Reg. City/Department"; //shows this after choosing a state
      _citiesOrDepartments = ["Select Reg. City/Department"];
      _selectedStateOrCity = value;
      this.widget.onStateChanged(value);
      getCityOrDepartment();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCityOrDepartment = value;
      this.widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _country.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        //style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            // onTap: ,
            onChanged: (value) => _onSelectedCountry(value!),
            onTap: widget.onCountryTap,
            // onChanged: (value) => _onSelectedCountry(value!),
            value: _selectedCountry,
          )),
        ),
        SizedBox(
          height: widget.spacing,
        ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _statesOrCities.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _onSelectedState(value!),
            onTap: widget.onStateTap,
            value: _selectedStateOrCity,
          )),
        ),
        
        /*SizedBox(
          height: widget.spacing,
        ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _citiesOrDepartments.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _onSelectedCity(value!),
            onTap: widget.onCityTap,
            value: _selectedCityOrDepartment,
          )),
        ),*/
      ],
    );
  }
}
