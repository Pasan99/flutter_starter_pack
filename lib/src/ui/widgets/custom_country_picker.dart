import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class CustomCountryPicker extends StatefulWidget {
  Country selectedCountry = Country.LK;

  @override
  State<StatefulWidget> createState() {
    return new _CustomCountryPickerState();
  }
}

class _CustomCountryPickerState extends State<CustomCountryPicker> {
  @override
  Widget build(BuildContext context) {
    return CountryPicker(
      onChanged: (Country country) {
        setState(() {
          widget.selectedCountry = country;
        });
      },
      selectedCountry: widget.selectedCountry,
    );
  }
}