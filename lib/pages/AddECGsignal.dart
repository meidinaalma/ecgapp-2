import 'dart:convert';
import 'dart:io';
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For using PlatformException
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// For performing some operations asynchronously
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_core/core.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/widget/loading.dart';

class AddECGsignal extends StatefulWidget {
  AddECGsignal() : super();

  // final String title = "File Operations";
  @override
  _AddECGsignalPage createState() => _AddECGsignalPage();
}

class _AddECGsignalPage extends State<AddECGsignal> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  //final _scrollController = ScrollController();
  final _isHours = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  Loading _load;
  String fileContents = "";
  List datalistupload = [];
  List Sensordata = [];
  List Menit = [];
  List Detik = [];
  List Jam = [];
  final myController = TextEditingController();
  int _deviceState;
  String sensorValue = "";
  String datasensor = "";
  DateTime sekarang = DateTime.now();
  bool isDisconnecting = false;
  //DateTime tanggalsekarang = DateTime.now();

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;
  var channel = 1;
  var jam;
  var builddatajson;
  var json_de;

  List masukkanList() {
    _load.show();
    var json = jsonDecode(fileContents);
    print(json);
    List<Datalist> datalist = List<Datalist>.from(
        json.map((data) => Datalist.fromJson(data)).toList());
    setState(() {
      datalistupload = datalist;
      json_de = json;
    });
    _load.hide();
    //print(datalistupload);
    return datalist;
  }

  List build_data(String dataa) {
    _load.show();
    List databuild = dataa.split("|");
    int panjangdata = databuild.length - 1;
    int cekgenap = panjangdata % 2;
    if (cekgenap == 0) {
      panjangdata = panjangdata;
    } else {
      panjangdata = panjangdata - 1;
    }
    int j = 0;
    print(databuild);
    for (int i = 0; i < panjangdata; i++) {
      if (i % 2 == 0) {
        j++;
        TimeOfDay _startTime = TimeOfDay(
            hour: int.parse(jam.split(":")[0]),
            minute: int.parse(jam.split(":")[1]));
        int detjam = _startTime.hour * 3600;
        int detmenit = _startTime.minute * 60;
        int jamsek = detjam +
            detmenit +
            int.parse(databuild[i + 1]) -
            int.parse(databuild[1]);
        int _jam = ((jamsek / 3600).toInt()) % 24;

        int _menit = ((jamsek / 60).toInt()) % 60;

        String s_jam, s_menit;
        if (_jam < 10 && _menit > 9) {
          s_jam = "0" + _jam.toString();
          s_menit = _menit.toString();
        } else if (_menit < 10 && _jam > 9) {
          s_menit = "0" + _menit.toString();
          s_jam = _jam.toString();
        } else if ((_jam < 10) && (_menit < 10)) {
          s_jam = "0" + _jam.toString();
          s_menit = "0" + _menit.toString();
        } else {
          s_jam = _jam.toString();
          s_menit = _menit.toString();
        }
        String swaktu = s_jam + ":" + s_menit;
        builddatajson = {
          "menit":
              (((int.parse(databuild[i + 1]) - int.parse(databuild[1])) / 60)
                      .toInt())
                  .toString(),
          "detik":
              ((int.parse(databuild[i + 1]) - int.parse(databuild[1])) % 60)
                  .toString(),
          "data": databuild[i],
          "jam": swaktu.toString(),
          "sample": j.toString() + ": " + swaktu.toString()
        };
        var encode = jsonEncode(builddatajson);
        ecgdata.add(encode);
      }
    }
    _load.hide();
    print(builddatajson);
  }

  String fixingspace(String konten) {
    String jason = "";
    konten.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      if (character == '\n' || character == ' ') {
        character = '';
      }
      jason = jason + character;
      Fluttertoast.showToast(msg: "sedang menyimpan data");
    });
    return jason;
  }

  void getTime() {
    TimeOfDay selectedTime = TimeOfDay.now();
    jam = selectedTime.format(context);
    return jam;
  }

  void kirimData() async {
    DateTime sekarang = DateTime.now();
    print(sekarang.toString());
    String tanggal_ = DateFormat('yyyy-MM-dd').format(sekarang);
    print(tanggal_);

    if (sensorValue != null) {
      _load.show();

      var url = link + "uploadECG.php";

      try {
        Map map = {
          "id_user": id_user.toString(),
          "id_dokter": id_doctor.toString(),
          "data": json_de,
          "tanggal": tanggal_,
          "channel": channel.toString(),
          "waktu_rekaman": (datalistupload[1].jam).toString()
        };
        var body = jsonEncode(map);

        var response = await http.post(url,
            headers: {"Content-Type": "application/json"}, body: body);

        print(response.body);
        Fluttertoast.showToast(msg: "sedang mengirim data");
      } catch (e) {
        print(e);
      }

      _load.hide();
      Fluttertoast.showToast(
          msg: "Berhasil mengirim data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(msg: "tidak ada data masuk");
    }
  }

  // void kirimData() async {
  //   if (sensorValue != null) {
  //     _load.show();
  //     for (int i = 0; i < datalistupload.length; i++) {
  //       var url = link + "uploadECG.php";
  //       var response = await http.post(url, body: {
  //         "id_user": id_user.toString(),
  //         "id_dokter": id_doctor.toString(),
  //         "data": (datalistupload[i].data).toString(),
  //         "waktu": (datalistupload[i].menit).toString(),
  //         "detik": (datalistupload[i].detik).toString(),
  //         "tanggal": sekarang.toString(),
  //         "jam": i.toString() + ": " + (datalistupload[i].jam).toString(),
  //         "channel": channel.toString(),
  //         "waktu_rekaman": (datalistupload[1].jam).toString()
  //       });

  //       print(response.body);
  //       Fluttertoast.showToast(msg: "sedang mengirim data");
  //     }
  //     _load.hide();
  //     Fluttertoast.showToast(
  //         msg: "Berhasil mengirim data",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } else {
  //     Fluttertoast.showToast(msg: "tidak ada data masuk");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
    _stopWatchTimer.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
      print(_devicesList);
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final _key = new GlobalKey<FormState>();
  List<String> ecgdata = [];

  List data = [];
  String menit;
  String detik;
  var waktumenit;
  var waktudetik;
  var json;

  Future<void> bluetoothPopUp() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap a button!
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.fromLTRB(30, 150, 30, 150),
            color: Colors.white,
            child: btapp(context),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _load = Loading(context: context);
    return Scaffold(
        backgroundColor: Constants.lightYellow,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Constants.darkOrange,
          title: const Text('Rekam sinyal ECG',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings_bluetooth,
                  color: Color.fromARGB(999, 243, 233, 210),
                ),
                onPressed: () {
                  bluetoothPopUp();
                }),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                    borderRadius: new BorderRadius.all(Radius.circular(30))),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value,
                              hours: _isHours);
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  displayTime,
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer.minuteTime,
                        initialData: _stopWatchTimer.minuteTime.value,
                        builder: (context, snap) {
                          final value = snap.data;
                          waktumenit = value.toString();
                          return Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          'minute',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer.secondTime,
                        initialData: _stopWatchTimer.secondTime.value,
                        builder: (context, snap) {
                          final value = snap.data % 60;
                          waktudetik = value.toString();
                          return Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          'second',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          value.toString(),
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.orangeAccent,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                ecgdata = [];
                                Menit.isEmpty;
                                Detik.isEmpty;
                                Jam.isEmpty;
                                FileUtils.saveToFile(ecgdata.toString());
                                datasensor = "";
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                                _sendOnMessageToBluetooth();
                              },
                              child: const Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.orangeAccent,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                for (int i = 0; i < 11; i++) {
                                  _sendOffMessageToBluetooth();
                                }

                                //_ambildariBluetooth();

                                //_disconnect();
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                                build_data(datasensor);
                                FileUtils.saveToFile(ecgdata.toString());
                                print(ecgdata.toString());
                              },
                              child: const Text(
                                'Stop and save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.orangeAccent,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.reset);
                              },
                              child: const Text(
                                'Reset',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // RaisedButton(
              //   padding: const EdgeInsets.all(4),
              //   color: Colors.orangeAccent,
              //   shape: const StadiumBorder(),
              //   child: Text(
              //     "Grafik",
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => ChartECGsignal()));
              //   },
              // ),
              RaisedButton(
                  padding: const EdgeInsets.all(4),
                  color: Colors.orangeAccent,
                  shape: const StadiumBorder(),
                  child: Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    FileUtils.readFromFile().then((contents) {
                      setState(() {
                        // contents.runes.forEach((int rune) {
                        //   var character = new String.fromCharCode(rune);
                        //   if (character == '\n' ||
                        //       character == ' ' ||
                        //       character == '\r\n') {
                        //     character = '';
                        //   }
                        //   fileContents = fileContents + character;
                        //   Fluttertoast.showToast(msg: "sedang menyimpan data");
                        // });
                        fileContents = contents;
                        //print(fileContents);
                        masukkanList();
                        kirimData();
                      });
                    });
                    //masukkanList();
                  }),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  padding: const EdgeInsets.all(4),
                  color: Colors.orangeAccent,
                  shape: const StadiumBorder(),
                  child: Text(
                    "Lihat Data",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    print(datasensor);
                    FileUtils.readFromFile().then((contents) {
                      setState(() {
                        fileContents = contents;

                        //masukkanList();
                      });
                    });
                  }),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                    width: 350,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30))),
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Text(fileContents),
                      ],
                    )),
              )
            ],
          ),
        ));
  }

  Widget btapp(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Constants.lightYellow,
        key: _scaffoldKey,
        appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Text("Bluetooth"),
            backgroundColor: Colors.orangeAccent,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: Text(
                  "Refresh",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                splashColor: Colors.deepPurple,
                // onPressed: null,
                onPressed: () async {
                  // So, that when new devices are paired
                  // while the app is running, user can refresh
                  // the paired devices list.
                  await getPairedDevices().then((_) {
                    show('Device list refreshed');
                  });
                },
              ),
            ]),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Text("Enable Bluetooth")),
                          Switch(
                            value: _bluetoothState.isEnabled,
                            onChanged: (bool value) {
                              future() async {
                                if (value) {
                                  await FlutterBluetoothSerial.instance
                                      .requestEnable();
                                } else {
                                  await FlutterBluetoothSerial.instance
                                      .requestDisable();
                                }
                                await getPairedDevices();
                                _isButtonUnavailable = false;

                                if (_connected) {
                                  _disconnect();
                                }
                              }

                              future().then((_) {
                                setState(() {
                                  Navigator.pop(context);
                                  bluetoothPopUp();
                                });
                              });

                              Navigator.pop(context);
                              bluetoothPopUp();
                            },
                          )
                        ],
                      ),
                      Text(
                        "List of paired devices:",
                        textAlign: TextAlign.start,
                      ),
                      DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _devicesList.isNotEmpty ? _device : null,
                      ),
                      RaisedButton(
                        onPressed: _isButtonUnavailable
                            ? null
                            : _connected
                                ? _disconnect
                                : _connect,
                        child: Text(_connected ? 'Disconnect' : 'Connect'),
                      ),
                      RaisedButton(
                          child: Text("Back"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      show('Wait until connected...');
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen((Uint8List data) {
            print('Data incoming: ${ascii.decode(data)}');
            setState(() {
              sensorValue = '${ascii.decode(data)}';
              if (sensorValue != " " && sensorValue != "") {
                //int ecgInt = int.parse(sensorValue);
                datasensor = datasensor + sensorValue;
                //print('datasensor: ${datasensor}');
                // //
                // ecg = sensorValue.toString();
                //
                if (sensorValue.length > 3) {
                  menit = waktumenit;
                  print('menit: ${menit}');
                  Menit.add(menit);
                  detik = waktudetik;
                  Detik.add(detik);
                  getTime();
                  Jam.add(jam.toString());
                }

                // jam = TimeOfDay.now().toString();

                // print(menit);

                //Datalist(data: sensorValue, menit: menit, jam: jam);
                //kirimData();
                //print('${ascii.decode(data)}');

                // ecgdata.add("{" +
                //     '"menit":' +
                //     '"' +
                //     menit +
                //     '"' +
                //     "," +
                //     '"data":' +
                //     '"' +
                //     sensorValue.toString() +
                //     '"' +
                //     "," +
                //     '"jam":' +
                //     '"' +
                //     jam.toString() +
                //     '"' +
                //     "}");

                // json = {"menit": menit, "data": ecgInt.toString(), "jam": jam};
                // var encode = jsonEncode(json);
                // ecgdata.add(encode);

                Fluttertoast.showToast(msg: "merekam data sinyal");
              }
            });
          }).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1"));
    await connection.output.allSent;
    //show('Device Turned On');
    // setState(() {
    //   _deviceState = 1; // device on
    // });
  }

  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0"));
    await connection.output.allSent;
    // show('Device Turned On');
    // setState(() {
    //   _deviceState = 0; // device on
    // });
  }

  void _ambildariBluetooth() async {
    connection.output.add(utf8.encode("2"));
    await connection.output.allSent;
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    // _scaffoldKey.currentState.showSnackBar(
    //   new SnackBar(
    //     content: new Text(
    //       message,
    //     ),
    //     duration: duration,
    //   ),
    // );
  }
}

class FileUtils {
  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    print(path);
    return File('$path/myfile.txt');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "";
    }
  }
}

class Datalist {
  Datalist({this.menit, this.detik, this.data, this.jam});

  final String menit;
  final String detik;
  final String data;
  final String jam;
  factory Datalist.fromJson(Map<String, dynamic> json) {
    return new Datalist(
        menit: json['menit'],
        detik: json['detik'],
        data: json['data'],
        jam: json['jam']);
  }
}
