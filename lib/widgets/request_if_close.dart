import 'package:flutter/material.dart';

class RequestIfClose extends StatefulWidget {
  const RequestIfClose({super.key});

  @override
  State<RequestIfClose> createState() => _RequestIfCloseState();
}

class _RequestIfCloseState extends State<RequestIfClose> {
  @override
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
              "Desea Cerrar la Bitacora",
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

            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context,"SI");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SI",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context,"NO");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red
                  ),
                ),
              ],
            ),

            SizedBox(height: 4,)

          ],
        ),
      ),
    );

  }
}
