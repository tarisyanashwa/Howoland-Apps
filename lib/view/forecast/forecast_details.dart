import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/view/core/constants.dart';
import 'package:weather_app/view/forecast/widgets/forecast_widget.dart';

class ForecastDetails extends StatelessWidget {
  final int index;
  const ForecastDetails({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherCtrl = Get.put(WeatherController());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 255, 255),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            )),
        title: (weatherCtrl.isError)
            ? const Text('')
            : Text(
                weatherCtrl.weatherData.city!.name.toString(),
                style: TextStyle(color: Colors.black),
              ),
        // title: const Text(
        //   'Forecast Details',
        //   style: whiteTxt20,
        // ),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          ForecastWidget(index: index),
        ],
      ),
    );
  }
}
