function y = Distance(lat1,lon1,lat2,lon2)
%          https://www.cnblogs.com/softfair/p/distance_of_two_latitude_and_longitude_points.html
%          <summary>
%          �����ľ���1��γ��1������2��γ��2. ����2����γ��֮��ľ��롣
%          </summary>
%          <param name="lat1">����1</param>
%          <param name="lon1">γ��1</param>
%          <param name="lat2">����2</param>
%          <param name="lon2">γ��2</param>
%          <returns>���루���ǧ�ף�</returns> 
%          ��haversine��ʽ�������������ľ���
            EARTH_RADIUS = 6371;

%           ��γ��ת���ɻ���
            lat1_radian = ConvertDegreesToRadians(lat1);
            lon1_radian = ConvertDegreesToRadians(lon1);
            lat2_radian = ConvertDegreesToRadians(lat2);
            lon2_radian = ConvertDegreesToRadians(lon2);
            
%           ��ֵ
            vLon = abs(lon1_radian - lon2_radian);
            vLat = abs(lat1_radian - lat2_radian);
            
            h = HaverSin(vLat) + cos(lat1) * cos(lat2) * HaverSin(vLon);
            y = real(2 * EARTH_RADIUS * asin(sqrt(h)));


end
