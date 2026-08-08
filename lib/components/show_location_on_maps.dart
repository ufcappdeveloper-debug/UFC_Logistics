import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_delivery_app/components/custom_snackbar.dart';

Future<void> showLocationOnMaps(
    BuildContext context, double latitude, double longitude) async {
  // Fetch installed map apps
  final availableMaps = await MapLauncher.installedMaps;

  if (availableMaps.isEmpty) {
    // Handle case where no map apps are installed
    if (!context.mounted) return;
    CustomSnackbar.show(context, 'No map apps installed on your device.');
    return;
  }

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                "Open with",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...availableMaps.map(
                        (e) {
                          final index = availableMaps.indexOf(e);
                          return InkWell(
                            onTap: () {
                              availableMaps[index].showMarker(
                                coords: Coords(
                                  latitude ?? 0.0,
                                  longitude ?? 0.0,
                                ),
                                // title: (context.locale.languageCode == "en"
                                //         ? station.nameEn
                                //         : context.locale.languageCode == "ar"
                                //         ? station.nameAr
                                //         : station.nameUr)
                                //     .toString(),
                                title: 'Your Location',
                              );
                              Navigator.of(ctx).pop();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.asset(
                                  e.icon,
                                ),
                              ),
                              title: Text(e.mapName),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
