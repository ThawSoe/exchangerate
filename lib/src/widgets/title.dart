import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleText extends StatelessWidget {
  final int? date;
  TitleText({Key? key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Last updated:",
                    style: Theme.of(context).textTheme.headline1),
                Text(
                    DateFormat('dd-MM-yyyy hh:mm a').format(
                        new DateTime.fromMillisecondsSinceEpoch(
                            date ?? 1558432747 * 1000)),
                    style: Theme.of(context).textTheme.headline1)
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("CURRENCY", style: Theme.of(context).textTheme.headline2),
                Text("RATES", style: Theme.of(context).textTheme.headline2)
              ],
            )
          ],
        ),
      ),
    );
  }
}
