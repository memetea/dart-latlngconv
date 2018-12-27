import 'package:flutter_test/flutter_test.dart';

import 'package:latlngconv/latlngconv.dart';

void main() {
  test('wgs and gcj convert', () {
    //convert wgs84 to gcj02
    LatLng wgs = new LatLng(31.1695941, 121.3926092);
    LatLng gcj = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.GCJ02);

    //convert gcj02 back to wgs84
    LatLng wgs2 = LatLngConvert(gcj, LatLngType.GCJ02, LatLngType.WGS84);

    expect((wgs.latitude-wgs2.latitude).abs() < 0.000001, true);
    expect((wgs.longitude-wgs2.longitude).abs() < 0.000001, true);
  });
}
