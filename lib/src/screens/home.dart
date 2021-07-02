import 'package:exchangerate/config/app_config.dart';
import 'package:exchangerate/config/provider/centralbank_provider.dart';
import 'package:exchangerate/config/provider/check_connection.dart';
import 'package:exchangerate/src/globalwidgets/loading.dart';
import 'package:exchangerate/src/globalwidgets/toastmessage.dart';
import 'package:exchangerate/src/widgets/currencyrate.dart';
import 'package:exchangerate/src/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool noconnection = false;
  bool isLoading = false;
  Map? rates;
  int intdate = 1558432747;
  List? currencyList;
  List? rateList;
  List? nameList;
  @override
  void initState() {
    super.initState();
    checkconnection();
  }

  checkconnection() async {
    Provider.of<CheckConnectionProvider>(context, listen: false)
        .checkConnection()
        .then((value) {
      if (value > 0) {
        setState(() {
          noconnection = false;
        });
        centralBank();
        centralBankName();
      } else {
        setState(() {
          noconnection = true;
        });
        ToastMessage.toast(false, Message.failconnection);
      }
    });
  }

  centralBank() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<CentralBankProvider>(context, listen: false)
        .centralBankData()
        .then((value) {
      setState(() {
        isLoading = false;
      });
      rates = value['rates'];
      var key = rates?.keys;
      currencyList = key?.toList();
      var values = rates?.values;
      rateList = values?.toList();
      intdate = int.parse(value['timestamp']);
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast(false, error.toString());
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast(false, error.toString());
    });
  }

  centralBankName() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<CentralBankProvider>(context, listen: false)
        .centralBankNameData()
        .then((value) {
      setState(() {
        isLoading = false;
      });
      rates = value['currencies'];
      var values = rates?.values;
      nameList = values?.toList();
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast(false, error.toString());
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.toast(false, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectionfail = new Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () {
          checkconnection();
        },
        child: Center(
          child: Image.asset('assets/images/connection.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height),
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Central Bank",
            style: TextStyle(fontSize: 19),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  checkconnection();
                },
                icon: Icon(Icons.refresh_outlined))
          ],
        ),
        body: noconnection
            ? connectionfail
            : isLoading
                ? Loading()
                : Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TitleText(
                            date: intdate,
                          )),
                      Expanded(
                          child: ListView.builder(
                              itemCount: rates?.length,
                              itemBuilder: (BuildContext context, index) {
                                return CurrencyRate(
                                    currency: currencyList?[index].toString(),
                                    rate: rateList?[index].toString(),
                                    name: nameList?[index].toString());
                              }))
                    ],
                  ));
  }
}
