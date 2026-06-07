import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Widget de localisation GPS avec mini-carte Google Maps.
class LocalisationWidget extends StatefulWidget {
  const LocalisationWidget({super.key, required this.onLocationSelected});
  final void Function(double lat, double lng, String adresse)
  onLocationSelected;
  @override
  State<LocalisationWidget> createState() => _LocalisationWidgetState();
}

class _LocalisationWidgetState extends State<LocalisationWidget> {
  double? _lat, _lng;
  String? _adresse;
  bool _loading = false;

  Future<void> _fetchLocation() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return;
    }
    if (perm == LocationPermission.deniedForever) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Localisation refusée définitivement.')),
        );
      return;
    }
    setState(() => _loading = true);
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      String addr = 'Adresse inconnue';
      if (marks.isNotEmpty) {
        final pm = marks.first;
        addr = [
          pm.locality,
          pm.country,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
      }
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _adresse = addr;
        _loading = false;
      });
      widget.onLocationSelected(_lat!, _lng!, _adresse!);
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localisation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_lat != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_lat!, _lng!),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('pos'),
                        position: LatLng(_lat!, _lng!),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _adresse ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchLocation,
                    child: const Text('Actualiser'),
                  ),
                ],
              ),
            ],
          )
        else
          OutlinedButton.icon(
            onPressed: _fetchLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Obtenir ma localisation'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
      ],
    );
  }
}
