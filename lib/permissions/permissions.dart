import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void requestPositionPermission() async {

  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

}

void requestStoragePermission() async{

  final permissionStatus =await Permission.storage.status;

  if(permissionStatus.isDenied){
    await Permission.storage.request();

    if(permissionStatus.isDenied){
      await openAppSettings();
    }
  }else if(permissionStatus.isPermanentlyDenied){
    await Permission.storage.request();

    if(permissionStatus.isDenied){
      await openAppSettings();
    }
  }

}

void requestStoragePermission2() async{

  final permissionStatus =await Permission.photos.status;

  if(permissionStatus.isDenied){
    await Permission.photos.request();

    if(permissionStatus.isDenied){
      //await openAppSettings();
    }
  }else if(permissionStatus.isPermanentlyDenied){
    await Permission.photos.request();

    if(permissionStatus.isDenied){
      //await openAppSettings();
    }
  }

}