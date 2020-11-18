import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MostAffectedPanel extends StatelessWidget {
  final List countryData;
  MostAffectedPanel({this.countryData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.orange[100],
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: [
                Image.network(
                  countryData[index]['countryInfo']['flag'],
                  height: 25,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  countryData[index]['country'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Total cases: ' +
                      NumberFormat.compact()
                          .format(countryData[index]['cases'])
                          .toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}
