import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/providers/user_provider.dart';

class AvailabilityProvider with ChangeNotifier {
  AvailabilityProvider({required this.userProvider});
  final UserProvider userProvider;

  Availability availability = Availability.empty();

  UserModel? user;

  TimeOfDay defaultFrom = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay defaultTo = const TimeOfDay(hour: 18, minute: 0);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    user = userProvider.getCurrentUser();

    if (user!.availability != null) {
      availability = user!.availability!;
      defaultFrom = availability.defaultFrom;
      defaultTo = availability.defaultTo;
    } else {
      final timeZone = await FlutterTimezone.getLocalTimezone();
      availability = Availability(
        defaultFrom: defaultFrom,
        defaultTo: defaultTo,
        timeZone: timeZone,
        days: [],
      );
      userProvider.updateUser(
        model: user!.copyWith(availability: availability),
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}
