import 'dart:convert';
import 'package:covid_tracker/datasource.dart';
import 'package:covid_tracker/pages/countryPage.dart';
import 'package:covid_tracker/panels/infopanel.dart';
import 'package:covid_tracker/panels/mostaffectedcountries.dart';
import 'package:covid_tracker/panels/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldwideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = jsonDecode(response.body);
    });
  }

  List countryData;

  fetchCountryData() async {
    //List arr = [];
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = jsonDecode(response.body);
    });
    //countryData.forEach((data)=>countryData.sort(a,b)=>b.cases-a.cases);
  }

  Future fetchData() async {
    fetchCountryData();
    fetchWorldwideData();
    print('fetchData called');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 TRACKER'),
        actions: [
          IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight),
              onPressed: () {
                print('on pressed called');
                DynamicTheme.of(context).setBrightness(
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
                );
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                color: Colors.orange[100],
                child: Text(
                  DataSource.quote,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: width > 500
                    ? EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0)
                    : const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Worldwide',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: DynamicTheme.of(context).brightness ==
                                    Brightness.light
                                ? primaryBlack
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          'Regional',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : WorldWidePanel(
                      worldData: worldData,
                    ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: width > 500
                    ? EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0)
                    : const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                child: Text(
                  'Most affected Countries',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              countryData == null
                  ? Container()
                  : MostAffectedPanel(
                      countryData: countryData,
                    ),
              SizedBox(
                height: 20.0,
              ),
              InfoPanel(),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'WE ARE TOGETHER IN THE FIGHT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 50.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
