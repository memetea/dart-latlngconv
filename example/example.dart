import "package:latlngconv/latlngconv.dart";


void main() {
    //location from gps provider inside china. 
    LatLng wgs = new LatLng(31.1695941, 121.3926092);

    //check if the location is out of china(this method gives a rectangle check. but the actual )
    bool isThisPointOutOfChina = OutofChina(wgs);

    //convert wgs84 to gcj02
    LatLng gcj = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.GCJ02);

    //convert from gcj02 to bd09. (the bd09 could be used by baidumap)
    LatLng bd09 = LatLngConvert(gcj, LatLngType.GCJ02, LatLngType.BD09);

    //convert from wgs to bd09
    LatLng bd09_2 = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.BD09);

    //convert from wgs84 to webmercator
    LatLng mercator = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.WebMercator);
}