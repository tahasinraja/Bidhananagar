import 'package:bidhannagarpoliceapp/allparkingmape.dart';
import 'package:bidhannagarpoliceapp/webvieparking.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class pagrkingpage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const pagrkingpage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<pagrkingpage> createState() => _pagrkingpageState();
}

class _pagrkingpageState extends State<pagrkingpage> {
  List<Map<String, dynamic>> parkingLocations = [
    {
      "title": "AMRI Hospital",
      "lat": 22.7433834055496,
      "lng": 88.4920297018341,
    },
    {
      "title": "Charnock City",
      "lat": 22.5676917255324,
      "lng": 88.4114767032126,
    },
    {
      "title": "Calcutta Heart Clinic",
      "lat": 22.5754592278629,
      "lng": 88.4183257099593,
    },
    {
      "title": "EC-28 to Bidhannagar College",
      "lat": 22.5853949774144,
      "lng": 88.4050647890156,
    },
    {
      "title": "Prosaan Bhavan",
      "lat": 22.5886429489971,
      "lng": 88.4097716522885,
    },
    {"title": "DD-8 Hospital", "lat": 22.591208483193, "lng": 88.4110483834131},
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking zone'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
          
              children: [
                Row(
                
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AllParkingMap(locations: parkingLocations),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Icon(Icons.location_on, size: 50),
                          ),
                        ),
                        Text('View Map', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => webviewparkingpage(
                                      onThemeChanged: widget.onThemeChanged,
                                      isDarkMode: widget.isDarkMode,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Image.asset('assets/images/parking-area.png'),
                          ),
                        ),
                        Text('View space', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
        
                // ElevatedButton(
                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder:
                  //           (context) => webviewparkingpage(
                  //             onThemeChanged: widget.onThemeChanged,
                  //             isDarkMode: widget.isDarkMode,
                  //           ),
                  //     ),
                  //   );
                  // },
                //   child: Text('View Parking space'),
                // ),
                SizedBox(height: 10),
        
                // parkingCard(
                //   title:
                //       'AMRI Hospital along with JC-25, in one side, from the opposite of JC-25 to temporary wooden Pole Both, up to Stadium Gate No. 4, excluding Commissionerate Gate.',
                //   lat: 22.7433834055496,
                //   lng: 88.4920297018341,
                //   twoWheeler: true,
                //   fourWheeler: true,
                //   truck: true,
                //   emptySlots: 12,
                //   desc: '24 Hours Parking',
                // ),
                // SizedBox(height: 20),
                // InkWell(
                //   onTap: () => openmape(22.5754592278629, 88.4183257099593),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.green.shade100,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Calcutta Heart Clinic to D.C. Paul Hotel (both side) [HB-36A/2] (Proposed).',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),
                // InkWell(
                //   onTap: () => openmape(22.5853949774144, 88.4050647890156),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.green.shade100,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'EC-28 to Bidhannagar College (both side) DB-16 to DB-27 (Excluding service road of DC Park) (Proposed).',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),
                // InkWell(
                //   onTap: () => openmape(22.5886429489971, 88.4097716522885),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.green.shade100,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Proasaan Bhavan to Central Bank (both side)).',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),
                // InkWell(
                //   onTap: () => openmape(22.591208483193, 88.4110483834131),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.green.shade100,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'DD-8 to back side of Sub-Divisional Hospital (both side).',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),
                // InkWell(
                //   onTap: () => openmape(22.572645, 88.363892),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.green.shade100,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'In front of Aaykatan (Service Road only)',
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget parkingCard({
    required String title,
    required double lat,
    required double lng,
    required bool twoWheeler,
    required bool fourWheeler,
    required bool truck,
    required int emptySlots,
    required String desc,
  }) {
    return InkWell(
      onTap: () => openmape(lat, lng),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            // Description
            Text(
              desc,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 10),

            // Availability row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.two_wheeler,
                      color: twoWheeler ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 4),
                    Text("2W"),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: fourWheeler ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 4),
                    Text("4W"),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.fire_truck,
                      color: truck ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 4),
                    Text("Truck"),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.event_seat, color: Colors.blue),
                    SizedBox(width: 4),
                    Text("Empty: $emptySlots"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
