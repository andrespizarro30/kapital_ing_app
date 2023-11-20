import 'package:flutter/material.dart';



class RequestCameraOrGallery extends StatefulWidget {
  const RequestCameraOrGallery({super.key});

  @override
  State<RequestCameraOrGallery> createState() => _RequestCameraOrGalleryState();
}

class _RequestCameraOrGalleryState extends State<RequestCameraOrGallery> {
  @override

  String photoSource = "Galeria";


  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Text(
              "Seleccionar Fuente de Imágenes",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16
              ),
            ),
            const SizedBox(height: 20,),
            Divider(
              thickness: 4,
              color: Colors.grey,
            ),
            const SizedBox(height: 16,),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio(
                    value: "Camara",
                    groupValue: photoSource,
                    onChanged: (source){
                      setState(() {
                        photoSource = source!;
                      });
                    }),
                Text(
                  "Cámara",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                  ),
                ),
                Radio(
                    value: "Galeria",
                    groupValue: photoSource,
                    onChanged: (source){
                      setState(() {
                        photoSource = source!;
                      });
                    }),
                Text(
                  "Galería",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context,photoSource);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Aceptar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 28,
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green
                ),
              ),
            ),

            SizedBox(height: 4,)
          ],
        ),
      ),
    );

  }
}
