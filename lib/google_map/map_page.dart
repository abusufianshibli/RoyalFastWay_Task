import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:royal_fastway_task/provider/user_info_provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BitmapDescriptor pinLocationIcon;
  StreamSubscription _subscription;
  Marker markers;
  Circle circle;
  Location _loactionAddress=Location();
  var _isLoading = false;
   GoogleMapController _controller;
  var name;
  var avater;
  var email;

   Future<Uint8List>getMarker()async{
     ByteData byteData=await DefaultAssetBundle.of(context).load("asstes/car.png");
     return byteData.buffer.asUint8List();
   }
   void presentLocation(LocationData localData,Uint8List image)async{
     LatLng latLng=LatLng(localData.latitude, localData.longitude);
     this.setState(() {
       markers=Marker(
           markerId:MarkerId("myLocation"),
         position: latLng,
         rotation: localData.heading,
         draggable: false,
         zIndex: 2,
         flat: true,
         anchor: Offset(0.5,0.5),
         icon: BitmapDescriptor.fromBytes(image),
           onTap: (){
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
       );
       circle=Circle(
         circleId: CircleId("myCar"),
         radius: localData.accuracy,
         zIndex: 1,
         strokeColor: Colors.white10,
         center: latLng,
         fillColor: Colors.white,
       );
     });
   }
  CameraPosition initialLocation = CameraPosition(
      zoom: 16,
      bearing: 30,
      target: LatLng(23.7451, 90.4085)
  );
void getLocation() async{
try{
  Uint8List image= await getMarker();
  var location =await _loactionAddress.getLocation();
  presentLocation(location,image);
  if(_subscription!=null){
    _subscription.cancel();
  }
  _subscription=_loactionAddress.onLocationChanged.listen((localData){
  if(_controller!=null){
  _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(

  target: LatLng(localData.latitude, localData.longitude),
  bearing: 180,
  tilt: 0,
  zoom: 15,
  )));
  presentLocation(localData, image);
  }
  });
}
on PlatformException catch(e){

}

}

  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProfileInfo>(context,listen: false).GetProfileInfo().then((_){setState(() {
      _isLoading=false;
    });});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final snap=Provider.of<ProfileInfo>(context).profileinfo;
    _isLoading?Text(""):
    setState(() {
      name=snap.data.firstName + snap.data.lastName;
       avater=snap.data.avatar;
     email=snap.data.email;
    });
    // LatLng pinPosition = LatLng(23.7451, 90.4085);
    // CameraPosition initialLocation = CameraPosition(
    //     zoom: 16,
    //     bearing: 30,
    //     target: pinPosition
    // );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Royal Fastway")),
      ),
      body:GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialLocation,
        markers: Set.of((markers!=null)?[markers]:[]),
        circles: Set.of((circle!=null)?[circle]:[]),
        onMapCreated: (GoogleMapController contoller){
          _controller=contoller;
        },
          ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right:40.0,bottom:40 ),
        child: FloatingActionButton(
          child: Icon(Icons.location_searching_sharp),
          onPressed: (){
            getLocation();
          },
        ),
      ),
    );
  }
}
