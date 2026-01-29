import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'page_8_menu_editor.dart';

class VendorDashboardScreen extends StatefulWidget {
  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _prevDocCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitchen Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VendorMenuEditor()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', whereIn: ['paid', 'preparing'])
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Text("No active orders"));

          // Logic: Audio Alert
          if (_prevDocCount != null &&
              snapshot.data!.docs.length > _prevDocCount!) {
            _audioPlayer.play(AssetSource('ding.mp3')); // Ensure asset exists
          }
          _prevDocCount = snapshot.data!.docs.length;

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, i) {
              var doc = snapshot.data!.docs[i];
              var data = doc.data() as Map<String, dynamic>;

              // Logic: Color coding by wait time
              DateTime orderTime = (data['timestamp'] as Timestamp).toDate();
              Duration waitTime = DateTime.now().difference(orderTime);
              Color cardColor = waitTime.inMinutes > 10
                  ? Colors.red.shade100
                  : (waitTime.inMinutes > 5
                        ? Colors.yellow.shade100
                        : Colors.white);

              return Card(
                color: cardColor,
                child: ListTile(
                  title: Text(
                    "Order #${doc.id.substring(0, 4)} (${waitTime.inMinutes}m ago)",
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...(data['items'] as List)
                          .map(
                            (item) => Text(
                              "• ${item['name']} [${item['customizations']}]",
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  trailing: ElevatedButton(
                    child: Text("READY"),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('orders')
                          .doc(doc.id)
                          .update({'status': 'ready'});
                    },
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
