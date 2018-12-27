/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library latlngconv;

import 'dart:core';
import 'dart:math' as Math;
import 'package:latlong/latlong.dart';

export 'package:latlong/latlong.dart';


const PI = 3.14159265358979324;
const X_PI = PI * 3000.0 / 180.0;


//defines the (latitude, longitude) encode types
enum LatLngType {
  WGS84,
  WebMercator,
  GCJ02,
  BD09,
}

LatLng delta(lat, lon) {
    // Krasovsky 1940  
    //  
    // a = 6378245.0, 1/f = 298.3  
    // b = a * (1 - f)  
    // ee = (a^2 - b^2) / a^2;  
    var a = 6378245.0; //  a: 卫星椭球坐标投影到平面地图坐标系的投影因子。  
    var ee = 0.00669342162296594323; //  ee: 椭球的偏心率。  
    var dLat = transformLat(lon - 105.0, lat - 35.0);
    var dLon = transformLon(lon - 105.0, lat - 35.0);
    var radLat = lat / 180.0 * PI;
    var magic = Math.sin(radLat);
    magic = 1 - ee * magic * magic;
    var sqrtMagic = Math.sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * PI);
    return LatLng(dLat, dLon);
}

double transformLat (double x, double y) {
    var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(x.abs());
    ret += (20.0 * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(y * PI) + 40.0 * Math.sin(y / 3.0 * PI)) * 2.0 / 3.0;
    ret += (160.0 * Math.sin(y / 12.0 * PI) + 320 * Math.sin(y * PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon (double x, double y) {
    var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(x.abs());
    ret += (20.0 * Math.sin(6.0 * x * PI) + 20.0 * Math.sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(x * PI) + 40.0 * Math.sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * Math.sin(x / 12.0 * PI) + 300.0 * Math.sin(x / 30.0 * PI)) * 2.0 / 3.0;
    return ret;
}

///Tell [point] is out of china
bool OutofChina(LatLng point) {
  if (point.longitude < 72.004 || point.longitude > 137.8347)
      return true;
  if (point.latitude < 0.8293 || point.latitude > 55.8271)
      return true;
  return false;
}

///Convert latlng[src] from [fromType] to [toType]
LatLng LatLngConvert(LatLng src, LatLngType fromType, LatLngType toType) {
  if (fromType == LatLngType.WGS84 && toType == LatLngType.GCJ02) {
    return _from_WGS84_to_GCJ02(src);
  } else if (fromType == LatLngType.GCJ02 && toType == LatLngType.WGS84) {
    return _from_GCJ02_to_WGS84_precise(src);
  } else if (fromType == LatLngType.GCJ02 && toType == LatLngType.BD09) {
    return _from_GCJ02_to_BD09(src);
  } else if (fromType == LatLngType.WebMercator && toType == LatLngType.WGS84) {
    return _from_WebMercator_to_WGS84(src);
  } else if (fromType == LatLngType.WGS84 && toType == LatLngType.WebMercator) {
    return _from_WGS84_to_WebMercator(src);
  }
}

LatLng _from_WGS84_to_GCJ02(LatLng src) {
  var d = delta(src.latitude, src.longitude);
  return LatLng( src.latitude + d.latitude, src.longitude + d.longitude );
}

//quick version to convert GCJ02 to WGS84
// LatLng _from_GCJ02_to_WGS84_quick(LatLng src) {
//   var d = delta(src.latitude, src.longitude);
//   return LatLng(src.latitude - d.latitude, src.longitude - d.longitude );
// }

//precise version to convert GCJ02 to WGS84 using binary search
LatLng _from_GCJ02_to_WGS84_precise(LatLng src) {
  var initDelta = 0.01;
  var threshold = 0.000000001;
  var dLat = initDelta, dLon = initDelta;
  var mLat = src.latitude - dLat, mLon = src.longitude - dLon;
  var pLat = src.latitude + dLat, pLon = src.longitude + dLon;
  var wgsLat, wgsLon, i = 0;
  while (true) {
      wgsLat = (mLat + pLat) / 2;
      wgsLon = (mLon + pLon) / 2;
      var tmp = _from_WGS84_to_GCJ02(LatLng(wgsLat, wgsLon));
      dLat = tmp.latitude - src.latitude;
      dLon = tmp.longitude - src.longitude;
      if (dLat.abs() < threshold && dLon.abs() < threshold)
          break;

      if (dLat > 0) pLat = wgsLat; else mLat = wgsLat;
      if (dLon > 0) pLon = wgsLon; else mLon = wgsLon;

      if (++i > 10000) break;
  }
  return LatLng(wgsLat, wgsLon);
}

LatLng _from_GCJ02_to_BD09(LatLng src) {
  var x = src.latitude, y = src.longitude;
  var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * X_PI);
  var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * X_PI);
  return LatLng(z * Math.cos(theta) + 0.0065, z * Math.sin(theta) + 0.006);
}

LatLng _from_BD09_to_GCJ02(LatLng src) {
  var x = src.longitude - 0.0065, y = src.latitude - 0.006;
  var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * X_PI);
  var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * X_PI);
  return LatLng(z * Math.cos(theta), z * Math.sin(theta));
}

LatLng _from_WebMercator_to_WGS84(LatLng src) {
  var x = src.longitude * 20037508.34 / 180.0;
  var y = Math.log(Math.tan((90.0 + src.latitude) * PI / 360.0)) / (PI / 180.0);
  y = y * 20037508.34 / 180.0;
  return LatLng(y, x);
}

LatLng _from_WGS84_to_WebMercator(LatLng src) {
  var x = src.longitude / 20037508.34 * 180.0;
  var y = src.latitude / 20037508.34 * 180.0;
  y = 180 / PI * (2 * Math.atan(Math.exp(y * PI / 180.0)) - PI / 2);
  return LatLng(y, x);
}