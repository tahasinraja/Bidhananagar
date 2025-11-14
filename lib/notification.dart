import 'package:bidhannagarpoliceapp/imageviwer.dart';
import 'package:bidhannagarpoliceapp/modelfetch.dart';
import 'package:bidhannagarpoliceapp/serviceapifetch.dart';
import 'package:flutter/material.dart';


class Notificationscreen extends StatelessWidget {
     final Function(bool) onThemeChanged; // 🔹 Dark mode toggle callback
  final bool isDarkMode; 
   const Notificationscreen({super.key,
  
  required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:
          isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
           backgroundColor:
          isDarkMode ? Colors.black : Colors.white,
        title: const Text("Notifications"),
      ),
      body: FutureBuilder<List<NoticeModel>>(
        future: ApiService.fetchNotices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications found"));
          }

          final notices = snapshot.data!;

          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Dept & Topic
                      // Text(
                      //   'Department: ${notice.dept}',
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        'Topic: ${notice.topic}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 🔹 Image 1
                      if (notice.image1.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Imageviwer(Imageview: notice.image1),));
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(notice.image1),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
//  if (notice.image2.isNotEmpty)
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => Imageviwer(Imageview: notice.image2),));
//                           },
//                           child: Container(
//                             height: 150,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 image: NetworkImage(notice.image2),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
                      // 🔹 Description
                      Text(notice.des),
                      const SizedBox(height: 8),

                      // 🔹 Date
                      Text(
                        "Published: ${notice.createdDate}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
