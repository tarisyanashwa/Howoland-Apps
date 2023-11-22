import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/view/core/constants.dart';
import 'package:weather_app/view/forecast/forecast_page.dart';
import 'package:weather_app/view/forecast/widgets/forecast_inherited_widget.dart';
import 'package:weather_app/view/home/widgets/bottom_forecast.dart';
import 'package:weather_app/view/home/widgets/home_top_illustration.dart';
import 'package:weather_app/view/home/widgets/loading_widget.dart';
import 'package:weather_app/view/home/widgets/wind_humidity.dart';
import 'package:weather_app/view/search/search.dart';

class HomePage extends StatelessWidget {
  final Position? usrLocation;
  final String? place;
  HomePage({Key? key, this.usrLocation, this.place}) : super(key: key);

  var climate = 'morning'.obs;

  final WeatherController weatherControl = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // if (usrLocation != null) {
    //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //     await weatherCtrl.getWeatherData(userLocation: usrLocation);
    //   });
    // } else {
    //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //     await weatherCtrl.getWeatherData(savedPlace: place);
    //   });
    // }
    return GetBuilder<WeatherController>(
      init: WeatherController(),
      builder: (weatherCtrl) {
        var weatherTime;
        if (!weatherCtrl.isLoading) {
          final weatherDateTime = weatherCtrl.weatherData.list![0].dtTxt;
          weatherTime = int.parse(weatherDateTime!.substring(
              weatherDateTime.indexOf(' ') + 1,
              weatherDateTime.indexOf(' ') + 3));
        }
        return Container(
          decoration: BoxDecoration(
            color: blackColor,
            image: !weatherCtrl.isLoading
                ? DecorationImage(
                    opacity: 0.8,
                    image: AssetImage((weatherTime <= 13)
                        ? 'assets/whiteBackground.jpg'
                        : (weatherTime < 18)
                            ? 'assets/alwinClouds.jpeg'
                            : 'assets/alwinNight.jpeg'),
                    fit: BoxFit.cover)
                : null,
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                // Color.fromARGB(255, 0, 55, 101),
                // Color.fromARGB(255, 82, 168, 238),
                // Color.fromARGB(255, 123, 188, 241),
                // Color.fromARGB(255, 108, 124, 214),
                // Color.fromARGB(255, 103, 79, 225),
                // Color.fromARGB(255, 98, 72, 232),
                // Color.fromARGB(255, 83, 55, 218),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: (weatherCtrl.isLoading)
                  ? Shimmer.fromColors(
                      highlightColor: blueClr100!,
                      baseColor: blueClr300!,
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )
                  : (weatherCtrl.isError)
                      ? const Text('')
                      : Text(
                          weatherCtrl.weatherData.city!.name.toString(),
                          style: blackTxt,
                        ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(SearchPage());
                    },
                    icon: const Icon(
                      Icons.search,
                      color: blackColor,
                      size: 30,
                    )),
                sbWidth10,
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                return await weatherCtrl.getWeatherData(
                    savedPlace: weatherCtrl.weatherData.city!.name.toString());
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Center(
                      child: (weatherCtrl.isLoading)
                          ? const LoadingEffect()
                          : (weatherCtrl.isError)
                              ? const Text('')
                              : Builder(
                                  builder: (context) {
                                    final weatherDetail =
                                        weatherCtrl.weatherData.list![0];
                                    final String climateDescription =
                                        weatherDetail.weather![0].description
                                            .toString();
                                    final String climate = weatherDetail
                                        .weather![0].main
                                        .toString();
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(
                                                255, 39, 68, 114),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              sbHeight30,
                                              Text(
                                                '${weatherDetail.main!.temp!.floor()}°C',
                                                style: TextStyle(
                                                  fontSize: 72,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                climate,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              sbHeight30,
                                              HomeTopIllustration(
                                                  screenSize: screenSize,
                                                  climateDescription:
                                                      climateDescription,
                                                  climate: climate),
                                              sbHeight10,
                                              WindAndHumidityContainer(
                                                humidity: weatherDetail
                                                    .main!.humidity
                                                    .toString(),
                                                windSpeed: weatherDetail
                                                    .wind!.speed
                                                    .toString(),
                                              ),
                                              sbHeight30,
                                            ],
                                          ),
                                        ),
                                        sbHeight30,
                                        ForecastInheritedWidget(
                                          forecastList:
                                              weatherCtrl.weatherData.list!,
                                          child: const BottomForecastScroll(),
                                        ),
                                        sbHeight20,
                                        // const Text('Today',
                                        //     style: whiteTxt18),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => ForecastInheritedWidget(
                                                    forecastList: weatherCtrl
                                                        .weatherData.list!,
                                                    child: const ForecastPage(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0), // Sesuaikan nilai sesuai kebutuhan
                                                  border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 212, 218, 227),
                                                      width: 2.0),
                                                  color: Color.fromARGB(
                                                      255,
                                                      212,
                                                      218,
                                                      227), // Warna dan ketebalan border sesuai keinginan
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '5 next days',
                                                    style: blackTxt,
                                                  ),
                                                ),
                                              ),
                                              // child: const Text(
                                              //   '5 next days',
                                              //   style: blackTxt,
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
