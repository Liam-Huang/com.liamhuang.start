function y = Distance(lat1,lon1,lat2,lon2)
%          https://www.cnblogs.com/softfair/p/distance_of_two_latitude_and_longitude_points.html
%          <summary>
%          给定的经度1，纬度1；经度2，纬度2. 计算2个经纬度之间的距离。
%          </summary>
%          <param name="lat1">经度1</param>
%          <param name="lon1">纬度1</param>
%          <param name="lat2">经度2</param>
%          <param name="lon2">纬度2</param>
%          <returns>距离（公里、千米）</returns> 
%          用haversine公式计算球面两点间的距离
            EARTH_RADIUS = 6371;

%           经纬度转换成弧度
            lat1_radian = ConvertDegreesToRadians(lat1);
            lon1_radian = ConvertDegreesToRadians(lon1);
            lat2_radian = ConvertDegreesToRadians(lat2);
            lon2_radian = ConvertDegreesToRadians(lon2);
            
%           差值
            vLon = abs(lon1_radian - lon2_radian);
            vLat = abs(lat1_radian - lat2_radian);
            
            h = HaverSin(vLat) + cos(lat1) * cos(lat2) * HaverSin(vLon);
            y = real(2 * EARTH_RADIUS * asin(sqrt(h)));


end
