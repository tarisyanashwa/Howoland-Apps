import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/model/weather_model/weather_model.dart';
import 'package:weather_app/view/core/constants.dart';
import 'package:weather_app/view/forecast/widgets/forecast_inherited_widget.dart';

import '../../home/widgets/home_top_illustration.dart';

class ForecastWidget extends StatelessWidget {
  final String? weatherDate;
  final List<ListDatas>? dailyForecastList;
  final int index;

  const ForecastWidget({
    Key? key,
    required this.index,
    this.weatherDate,
    this.dailyForecastList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListDatas forecastList;
    if (dailyForecastList != null) {
      forecastList = dailyForecastList![index];
    } else {
      forecastList = ForecastInheritedWidget.of(context)!.forecastList[index];
    }

    // Get the time of weather
    String weatherTime = forecastList.dtTxt!.substring(
        forecastList.dtTxt!.indexOf(' ') + 1, forecastList.dtTxt!.length);
    final time = weatherTime.substring(0, 5);

    final WeatherController weatherCtrl = Get.put(WeatherController());
    final weatherDetail = weatherCtrl.weatherData.list![0];
    final String climateDescription =
        weatherDetail.weather![0].description.toString();
    final String climate = weatherDetail.weather![0].main.toString();

// Get the Daily Forecast List

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 39, 68, 114),
          // gradient: const LinearGradient(colors: [
          //   Color.fromARGB(255, 82, 168, 238),
          //   Color.fromARGB(255, 82, 168, 238),
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Row(
          children: [
            Column(
              children: [
                HomeTopIllustration(
                    screenSize: Size(200, 200),
                    climateDescription: climateDescription,
                    climate: climate),
                Text(
                  '${forecastList.main!.temp}°C',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            sbWidth10,
            weatherDate != null
                ? Text(
                    weatherDate!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    time,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
            const Divider(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            // sbHeight10,
            // sbHeight20,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            // Column(
            //   children: [
            //     Text('${forecastList.main!.humidity}', style: blackTxt),
            //     const Text(
            //       'Humidity',
            //       style: blackTxt,
            //     )
            //   ],
            // ),
            // sbHeight10,
            // Column(
            //   children: [
            //     Text('${forecastList.main!.temp}°C', style: blackTxt),
            //     sbHeight10,
            //     Text(
            //       forecastList.weather![0].main.toString(),
            //       style: blackTxt,
            //     ),
            //   ],
            // ),
            // Column(
            //   children: [
            //     Text(
            //       '${forecastList.wind!.speed} m/s',
            //       style: whiteTxt20,
            //     ),
            //     const Text(
            //       'Wind',
            //       style: whiteTxt18,
            //     )
            //   ],
            // ),
            // ],
            // ),
            sbHeight20
          ],
        ),
      ),
    );
  }
}
