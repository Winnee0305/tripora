import 'package:flutter/material.dart';
import '../models/trip.dart';

class CreateTripViewModel extends ChangeNotifier {
  Trip trip = Trip();
  DateTime focusedDay = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  void setTripName(String name) {
    trip.name = name;
    notifyListeners();
  }

  void setDestination(String destination) {
    trip.destination = destination;
    notifyListeners();
  }

  void setTravelStyle(String style) {
    trip.travelStyle = style;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    trip.start = start;
    trip.end = end;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    notifyListeners();
  }

  void setTravelPartner(String partner) {
    trip.travelPartner = partner;
    notifyListeners();
  }

  void setNumTravellers(int num) {
    trip.numTravellers = num;
    notifyListeners();
  }
}
