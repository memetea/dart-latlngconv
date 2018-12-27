latlngconv

A Flutter package to convert latitude and longitude between [WGS84, GCJ-02, BD-09](https://en.wikipedia.org/wiki/Restrictions_on_geographic_data_in_China), [Web Mercator](https://en.wikipedia.org/wiki/Web_Mercator_projection)


- 有偏移需要修正的地图： 百度地图、高德地图、搜狗地图、搜搜地图、谷歌地图（国内服务器）
- 不需要修正的地图： 天地图、谷歌地球、谷歌卫星地图（国外服务器）、必应卫星地图和OpenStreetMap地图等


## Basic usage

```
//convert wgs84 to gcj02
LatLng wgs = new LatLng(31.1695941, 121.3926092);
LatLng gcj = LatLngConvert(wgs, LatLngType.WGS84, LatLngType.GCJ02);

//convert gcj02 back to wgs84
LatLng wgs2 = LatLngConvert(gcj, LatLngType.GCJ02, LatLngType.WGS84);

//they are expect to nearly equal
// wgs == wgs2
```


## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/memetea/latlngconv/issues).

## License

    Copyright 2015 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
    either express or implied. See the License for the specific language
    governing permissions and limitations under the License.
