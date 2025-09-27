import 'package:flutter/material.dart';

class HomePageExample extends StatefulWidget {
  const HomePageExample({super.key});

  @override
  State<HomePageExample> createState() => HomePageExampleState();
}

class HomePageExampleState extends State<HomePageExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 16),
              _buildBookings(),
              const SizedBox(height: 20),
              _buildContinueTrip(),
              const SizedBox(height: 20),
              _buildRecommendations(),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER WITH PROFILE & NOTIFICATION
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                "assets/avatar.png",
              ), // replace with your asset
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hello, Winnee",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Explore your best journey with Tripora",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.lock_outline,
                size: 28,
                color: Colors.orange,
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Text(
                  "3",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.shade100,
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          hintText: "Search for places...",
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.orange),
        ),
      ),
    );
  }

  /// DISCOVER TABS
  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text(
          "Discover",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        Text("Inspirations", style: TextStyle(color: Colors.black45)),
        Text("Traveler’s Voice", style: TextStyle(color: Colors.black45)),
      ],
    );
  }

  /// BOOKINGS SECTION
  Widget _buildBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Make Bookings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bookingItem(Icons.flight_takeoff, "Flights"),
            _bookingItem(Icons.hotel, "Stays"),
            _bookingItem(Icons.directions_car, "Car Rental"),
            _bookingItem(Icons.confirmation_number, "Tickets"),
          ],
        ),
      ],
    );
  }

  Widget _bookingItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          radius: 28,
          child: Icon(icon, color: Colors.black87, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  /// CONTINUE TRIP SECTION
  Widget _buildContinueTrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Continue Edit Your Trip",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "View All",
              style: TextStyle(color: Colors.black45, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.asset(
                  "assets/melaka.jpg", // replace with your asset
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "13/8/2025 – 14/8/2025",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Melaka 2 days family trip",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Melacca, Malaysia",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// RECOMMENDATIONS
  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get Recommendations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _recommendChip(Icons.restaurant, "Restaurant"),
            const SizedBox(width: 10),
            _recommendChip(Icons.museum, "Museum"),
            const SizedBox(width: 10),
            _recommendChip(Icons.temple_buddhist, "Attraction"),
          ],
        ),
      ],
    );
  }

  Widget _recommendChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black87),
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  /// BOTTOM NAVIGATION
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black45,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
