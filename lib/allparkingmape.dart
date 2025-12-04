import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AllParkingMap extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  //final List<Map<String, dynamic>> locations;

  const AllParkingMap({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<AllParkingMap> createState() => _AllParkingMapState();
}

class _AllParkingMapState extends State<AllParkingMap> {
  TextEditingController searchController = TextEditingController();
  // list fetch
  List<dynamic> parkinglist = [];
  List<dynamic> filteredList = [];
  Future<void> parkingarefetch() async {
    final fetchurl = Uri.parse(
      'https://bnpcdeveloper.co.in/bnpolice/app/parking_fetch.php',
    );
    try {
      final responce = await http.get(fetchurl);
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        if (data['status'].toLowerCase() == 'success') {
          setState(() {
            parkinglist = data['data'];
            filteredList = List.from(parkinglist);
          });
          print('responce:$responce.body');
          print('parkinglist;$parkinglist.length');
        } else {
          print('Failed:$responce.statusCode');
        }
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  void searching(String query) {
  final result= parkinglist.where((item){
    final area= item['parking_area'].toString().toLowerCase();
    final municipality=item['municipality'].toString().toLowerCase();
    final input=query.toLowerCase();
    return area.contains(input)||municipality.contains(input);

  }).toList();
  setState(() {
    filteredList=result;
  });
  }

  void openmape(double lat, double long) async {
    final openurl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$long',
    );
    if (await canLaunchUrl(openurl)) {
      await launchUrl(openurl);
    } else {
      print('can not open map');
    }
  }
   

  @override
  void initState() {
    super.initState();
    parkingarefetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Theme.of(context).brightness == Brightness.dark
    ? Colors.black
    : const Color(0xFFe9e4de),
      appBar: AppBar(title: Text("All Parking Area"),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
    ? Colors.black
    : const Color(0xFFe9e4de),
      ),
      body: 
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
          hintText: "Search parking...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
              ),
              onChanged: searching,   // 👈 call search function
            ),
          
          ),
          
           Expanded(child: 
                parkinglist.isEmpty
                    ? Center(child: CircularProgressIndicator(),)
                    : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final list = filteredList[index];
                        
                        return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            // Top row: Icon + Municipality + Parking Area
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on, color: Colors.red),
              title: Text(
                list['municipality'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                list['parking_area'],
                style: TextStyle(fontSize: 16),
              ),
              onTap: () => openmape(
                double.parse(list['lat']),
                double.parse(list['lon']),
              ),
            ),
          
          //  Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Parking Details', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
              
              // ),
            ],
          ),
          SizedBox(height: 10,),
            // Parking rates
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text("Vehicle Type",style: TextStyle(fontWeight: FontWeight.bold),),
//     Text("Capacity",style: TextStyle(fontWeight: FontWeight.bold),),
//     Text("Available",style: TextStyle(fontWeight: FontWeight.bold),),
//   ],
// ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
                
            //     Text("2-Wheeler",
            //         style: TextStyle(fontSize: 15)),
            //          Text("${list['rate_2w']}",
            //         style: TextStyle(fontSize: 15)),
            //        // SizedBox(width: 30,),
            //         Padding(
            //           padding: const EdgeInsets.only(right: 25),
            //           child: Text('${list['arate_2w']}'),
            //         ),
            //   ],
            // ),
            // SizedBox(height: 6),
          
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("4-Wheeler",
            //         style: TextStyle(fontSize: 15)),
            //          Text("${list['rate_4w']}",
            //         style: TextStyle(fontSize: 15)),
            //        // SizedBox(width: 30,),
            //         Padding(
            //           padding: const EdgeInsets.only(right: 25),
            //           child: Text('${list['arate_4w']}'),
            //         ),
            //   ],
            // ),
            SizedBox(height: 6),
          
            // Text("🚚 Truck :${list['rate_truck']}",
            //     style: TextStyle(fontSize: 15)),
            // SizedBox(height: 12),
          
            // Coordinates
            // Text("📍 Latitude: ${list['lat']}"),
            // Text("📍 Longitude: ${list['lon']}"),
          ],
              ),
            ),
          );
          
                      },
                    )
                    ),
          
      
        ],
      ),
    );
  }
}
