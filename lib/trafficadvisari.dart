import 'package:flutter/material.dart';

class trafficadvisary extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;
  const trafficadvisary({super.key,
  
  required this.onThemeChanged,
  required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:isDarkMode ? Colors.black : Color(0xFFe9e4de),
      appBar: AppBar(
        title: const Text("Traffic Advisory"),
        backgroundColor:isDarkMode ? Colors.black : Color(0xFFe9e4de),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guidelines for Pedestrians",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              """1. Always walk on the footpath.
2. If there’s no footpath, walk on the edge of the road facing oncoming traffic.
3. Use zebra crossings to cross the road.
4. Never run while crossing — you may slip and fall.
5. Cross roads only at marked crosswalks.
6. Before crossing, watch out for vehicles turning at intersections.
7. If crossing between parked vehicles or objects taller than you - stop and ensure you’re visible to drivers before stepping onto the road.
8. Look left–right–left before crossing. Proceed only when it’s safe.
9. Avoid crossing road where drivers may not be able to see you.
10. Always hold hands of children while crossing the road.""",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "পথচারী নিরাপত্তা বিধি",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              """১. সবসময় ফুটপাথে হাঁটুন।
২. ফুটপাত না থাকলে, রাস্তায় যানবাহনের মুখোমুখি দিক ধরে হাঁটুন।
৩. রাস্তা পার হতে জেব্রা ক্রসিং ব্যবহার করুন।
৪. কখনো দৌড়ে রাস্তা পার হবেন না — পা পিছলে পড়ে যেতে পারেন।
৫. শুধুমাত্র চিহ্নিত ক্রসওয়াক দিয়ে রাস্তা পার হোন।
৬. রাস্তা পার হওয়ার আগে মোড় ঘুরে আসা গাড়ির দিকে খেয়াল রাখুন।
৭. গাড়ি পার্ক করা থাকলে বা বড় কোনো বস্তু আড়ালে থাকলে, আগে থামুন এবং গাড়ির চালকের কাছে দৃশ্যমান হয়ে তারপর রাস্তা পার হোন।
৮. রাস্তা পার হওয়ার আগে বাঁ–ডান–বাঁ দিকে তাকান। শুধুমাত্র নিরাপদ হলে পার হোন।
৯. যেখানে চালকেরা আপনাকে দেখতে পাবে না, সেখানে রাস্তা পার হবেন না।
১০. রাস্তা পার হওয়ার সময় শিশুদের হাত শক্ত করে ধরুন।""",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 30),
            Text(
              "Road & Bus Safety Guidelines for Students",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              """While boarding the bus/Pool Car
1. Do not board or get off the bus until it has come to a complete stop.
2. Do not hurry, wait till the bus stops.
3. Enter the bus in single file line.
4. Hold handrails and enter.
5. Ensure that your bag or clothes don't get stuck anywhere.
6. Go straight to your seat.

While traveling in bus:
7. Be seated properly and face forward.
8. Do not put any part of your body outside the bus.
9. Do not travel on footboard.
10. Keep the aisle clear.
11. Do not make much noise and distract driver.
12. Follow the instruction of driver and conductor.

While alighting from the bus:
13. Do not be in a hurry, wait till the bus stops.
14. Use handrails to get off the bus.
15. Exit from the front door of the bus.
16. Be visible to the driver while alighting.
17. Do not crawl under the bus to pick up lost things.
18. Never move behind the bus, the blind spot of driver.
19. Do not stand or travel on the footboard.""",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "ছাত্রছাত্রীদের জন্য সড়ক ও বাস নিরাপত্তা নির্দেশিকা",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              """বাস/পুল গাড়িতে ওঠার সময়:
১. বাসটি সম্পূর্ণ থেমে না আসা পর্যন্ত বাসে উঠবেন না বা নামবেন না।
২. তাড়াহুড়ো করবেন না, বাস থামানো পর্যন্ত অপেক্ষা করুন।
৩. একক লাইনে বাসে প্রবেশ করুন।
৪. হ্যান্ড্রেল ধরে প্রবেশ করুন।
৫. নিশ্চিত করুন যে আপনার ব্যাগ বা কাপড় কোথাও আটকে না যায়।
৬. সোজা আপনার আসনে যান।

বাসে ভ্রমণের সময়:
৭. সঠিকভাবে বসুন এবং সামনের দিকে মুখ করুন।
৮. আপনার শরীরের কোনও অংশ বাসের বাইরে রাখবেন না।
৯. পায়ের পাতার উপর ভ্রমণ করবেন না।
১০. করিডোর পরিষ্কার রাখুন।
১১. বেশি শব্দ করবেন না এবং ড্রাইভারকে বিভ্রান্ত করবেন না।
১২. ড্রাইভার এবং কন্ডাক্টরের নির্দেশ অনুসরণ করুন।

বাস থেকে নামার সময়:
১৩. তাড়াহুড়ো করবেন না, বাস থামানো পর্যন্ত অপেক্ষা করুন।
১৪. বাস থেকে নামার জন্য হ্যান্ড্রেল ব্যবহার করুন।
১৫. বাসের সামনের দরজা দিয়ে বেরিয়ে আসুন।
১৬. নামার সময় ড্রাইভার যেন তাকে দেখতে পান।
১৭. হারানো জিনিসপত্র তুলতে বাসের নিচে হামাগুড়ি দেবেন না।
১৮. বাসের পিছনে কখনও যাবেন না, ড্রাইভার আপনাকে দেখতে পাবে না।
১৯. ফুটবোর্ড দাঁড়িয়ে থাকবেন না বা ভ্রমণ করবেন না।""",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
