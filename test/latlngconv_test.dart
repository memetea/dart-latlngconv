import 'package:flutter_test/flutter_test.dart';

import 'package:latlngconv/latlngconv.dart';

void main() {
  test('wgs84 and gcj02 convert', () {
    LatLng wgs = new LatLng(31.1695941, 121.3926092);
    //convert wgs84 to gcj02
    LatLng gcj = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.GCJ02);

    //convert gcj02 back to wgs84
    LatLng wgs2 = LatLngConvert(gcj, LatLngType.GCJ02, LatLngType.WGS84);

    expect((wgs.latitude-wgs2.latitude).abs() < 0.000001, true);
    expect((wgs.longitude-wgs2.longitude).abs() < 0.000001, true);
  });


  test('wgs84 and bd09 convert', (){
    LatLng wgs = new LatLng(31.1695941, 121.3926092);

    //convert from wgs to bd09
    LatLng bd09 = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.BD09);
    LatLng wgs2 = LatLngConvert(bd09, LatLngType.BD09, LatLngType.WGS84);
    expect((wgs.latitude-wgs2.latitude).abs() < 0.000001, true);
    expect((wgs.longitude-wgs2.longitude).abs() < 0.000001, true);
  });


  test('gcj02 and bd09 convert', () {
    LatLng wgs = new LatLng(31.1695941, 121.3926092);
    //convert wgs84 to gcj02
    LatLng gcj = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.GCJ02);

    //convert gcj02 bo bd09
    LatLng bd09 = LatLngConvert(gcj, LatLngType.GCJ02, LatLngType.BD09);

    //convert bd09 back to gcj02
    LatLng gcj2 = LatLngConvert(bd09, LatLngType.BD09, LatLngType.GCJ02);

    expect((gcj.latitude-gcj2.latitude).abs() < 0.000001, true);
    expect((gcj.longitude-gcj2.longitude).abs() < 0.000001, true);
  });


  test('wgs84 and web mercator convert', (){
    LatLng wgs = new LatLng(31.1695941, 121.3926092);

    //convert from wgs to bd09
    LatLng mercator = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.WebMercator);
    LatLng wgs2 = LatLngConvert(mercator, LatLngType.WebMercator, LatLngType.WGS84);
    expect((wgs.latitude-wgs2.latitude).abs() < 0.000001, true);
    expect((wgs.longitude-wgs2.longitude).abs() < 0.000001, true);
  });
}
