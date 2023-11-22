import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/model/weather_model/weather_model.dart';
import 'package:weather_app/view/core/constants.dart';
import 'package:weather_app/view/forecast/widgets/forecast_inherited_widget.dart';
import 'package:weather_app/view/forecast/widgets/forecast_widget.dart';

class ForecastPage extends StatelessWidget {
  // final List<ListDatas> forecastList;
  const ForecastPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ListDatas> forecastList =
        ForecastInheritedWidget.of(context)!.forecastList;
    List<ListDatas> dailyForecastList = [];
    final WeatherController weatherCtrl = Get.put(WeatherController());

    int index = 0;
    String _checkDate = forecastList[index]
        .dtTxt!
        .substring(0, forecastList[0].dtTxt!.indexOf(' ') + 1);
    while (index < forecastList.length) {
      if (forecastList[index]
                  .dtTxt!
                  .substring(0, forecastList[0].dtTxt!.indexOf(' ') + 1) !=
              _checkDate ||
          index == 0) {
        dailyForecastList.add(forecastList[index]);
      }
      _checkDate = forecastList[index]
          .dtTxt!
          .substring(0, forecastList[0].dtTxt!.indexOf(' ') + 1);
      index = index + 1;
    }
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
        //   'Current Forecastings',
        //   style: TextStyle(color: Colors.black),
        // ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: dailyForecastList.length,
          itemBuilder: (context, index) {
            String weatherDate = dailyForecastList[index]
                .dtTxt!
                .substring(0, dailyForecastList[0].dtTxt!.indexOf(' ') + 1);
            return ForecastWidget(
              index: index,
              weatherDate: weatherDate,
              dailyForecastList: dailyForecastList,
            );
          }),
    );
  }
}
