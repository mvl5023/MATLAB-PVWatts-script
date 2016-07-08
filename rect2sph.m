function [azi, elev] = rect2sph(x, y, z)
%Converts a vector from rectangular to spherical coords
%   vIn = (x, y, z) ; vOut = (azimuth, elevation)
azi = atan2( x , y ) * (180/pi);
elev = atan2( sqrt( x^2 + y^2 ), z) * (180/pi);
end