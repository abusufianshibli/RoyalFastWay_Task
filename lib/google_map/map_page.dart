import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:royal_fastway_task/provider/user_info_provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  var _isLoading = false;
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProfileInfo>(context,listen: false).GetProfileInfo().then((_){setState(() {
      _isLoading=false;
    });});
    setCustomMapPin();
    super.initState();
  }
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'asstes/car.png');
  }
  var name;
  var avater;
  var email;
  @override
  Widget build(BuildContext context) {
    final snap=Provider.of<ProfileInfo>(context).profileinfo;
    _isLoading?Text(""):
    setState(() {
      name=snap.data.firstName + snap.data.lastName;
       avater=snap.data.avatar;
     email=snap.data.email;
    });
    LatLng pinPosition = LatLng(23.7452, 90.4085);
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: pinPosition
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Royal Fastway")),
      ),
      body:GoogleMap(
            myLocationEnabled: true,
            markers: _markers,
            initialCameraPosition: initialLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                _markers.add(
                    Marker(
                        markerId: MarkerId("new"),
                        position: pinPosition,
                        icon: pinLocationIcon,
                        onTap: (){
                          // AwesomeDialog(
                          //     context: context,
                          //     dialogType: DialogType.WARNING,
                          //     headerAnimationLoop: true,
                          //     animType: AnimType.BOTTOMSLIDE,
                          //     title: 'Warning',
                          //     desc:
                          //     'Do you want to Log Out?',
                          //     btnCancelOnPress: () {},
                          //     btnOkOnPress: () {}).show();
                          showDialog(context: context,
                          builder: (context) {
                            return
                            AlertDialog(
                              title: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                                child: ClipOval(child: Image.network(avater,height: 100,width: 100,fit: BoxFit.cover,)),
                              ),
                              content:Container(
                                height: 60,
                                child: Column(
                                children: [
                                  Text(name),
                                  Text(email)
                                ],
                              ),) ,
                              actions: [
                                TextButton(
                                  child: Text('Back'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                          );
                        }
                    )
                );
              });
            },
            trafficEnabled: true,
            rotateGesturesEnabled: true,
          ),
    );
  }
}
