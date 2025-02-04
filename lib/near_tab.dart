import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(NearbyGaragesApp());
}

class NearbyGaragesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        hintColor: Colors.cyan,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      home: NearbyGaragesPage(),
    );
  }
}

class NearbyGaragesPage extends StatefulWidget {
  @override
  _NearbyGaragesPageState createState() => _NearbyGaragesPageState();
}

class _NearbyGaragesPageState extends State<NearbyGaragesPage> {
  double _selectedDistance = 10; // Default distance filter (10 km)
  double _selectedRating = 0; // Default rating filter
  String _sortBy = 'distance';
  String _currentLocation = 'Your Location'; // Placeholder for location
  String _currentTime = DateFormat('HH:mm a').format(DateTime.now());
  String _currentDay = DateFormat('EEEE').format(DateTime.now());

  // Mock garage data here
  List<Map<String, dynamic>> garageList = [
    {
      'name': 'Garage A',
      'address': '123 Main St, Cityville',
      'rating': 4.5,
      'services': 'Oil Change, Tire Repair',
      'image': 'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      'latitude': 37.7749,
      'longitude': -122.4194,
      'partsAvailability': ['Tires', 'Brakes', 'Batteries'],
      'openingHours': '8:00 AM - 6:00 PM',
      'gallery': [
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      ]
    },
    {
      'name': 'Garage B',
      'address': '456 Oak Ave, Townsville',
      'rating': 3.8,
      'services': 'Brake Services, Battery Replacement',
      'image': 'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      'latitude': 37.7849,
      'longitude': -122.4294,
      'partsAvailability': ['Brakes', 'Suspension'],
      'openingHours': '9:00 AM - 7:00 PM',
      'gallery': [
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      ]
    },
    {
      'name': 'Garage C',
      'address': '789 Pine Rd, Villageburg',
      'rating': 4.7,
      'services': 'Engine Repair, Car Wash',
      'image': 'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      'latitude': 37.7949,
      'longitude': -122.4394,
      'partsAvailability': ['Engines', 'Filters'],
      'openingHours': '7:00 AM - 5:00 PM',
      'gallery': [
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
        'https://www.shutterstock.com/image-vector/vector-cartoon-illustration-garage-interior-600nw-1069655507.jpg',
      ]
    },
  ];
  void _showGarageDetails(Map<String, dynamic> garage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(garage['image'], height: 250, fit: BoxFit.cover),
                      SizedBox(height: 16),
                      Text(
                        garage['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Address: ${garage['address']}'),
                      SizedBox(height: 8),
                      Text('Opening Hours: ${garage['openingHours']}'),
                      SizedBox(height: 8),
                      Text('Services: ${garage['services']}'),
                      SizedBox(height: 8),
                      Text('Parts Available: ${garage['partsAvailability'].join(", ")}'),
                      SizedBox(height: 16),
                      Text('Gallery:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: garage['gallery']
                            .map<Widget>((url) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(url, width: 50, height: 50),
                        ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        child: Text('Contact Garage'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        child: Text('Rate and Review'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting, time, and location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_currentDay, $_currentTime',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.bell),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Welcome text
            Text(
              'Welcome to',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'Digital Garage',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Select the garage according to your distance and budget.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            // Distance filter buttons wrapped in a Horizontal Scroll View
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDistanceButton(2),
                  SizedBox(width: 2,),
                  _buildDistanceButton(6),
                  SizedBox(width: 2,),
                  _buildDistanceButton(8),
                  SizedBox(width: 2,),
                  _buildDistanceButton(10),
                ],
              ),
            ),


            // Garage list
            Expanded(
              child: ListView.builder(
                itemCount: garageList.length,
                itemBuilder: (context, index) {
                  final garage = garageList[index];
                  final distance = _calculateDistance(
                    garage['latitude'],
                    garage['longitude'],
                  );
                  if (distance <= _selectedDistance) {
                    return GestureDetector(
                      onTap: () => _showGarageDetails(garage),
                      child: Card(
                        elevation: 0.0, // No elevation now
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                garage['image'],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    garage['name'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    garage['address'],
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(FontAwesomeIcons.solidStar, color: Colors.orange, size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        '${garage['rating']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Distance: ${distance.toStringAsFixed(1)} km',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceButton(double distance) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDistance = distance;
        });
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedDistance == distance ? Colors.blueAccent : Colors.grey[200],

        elevation: 0,

      ),
      child: Text(
        '$distance km',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  double _calculateDistance(double lat1, double lon1) {
    return 5.0; // Mocking a fixed 5 km for now
  }
}
