% The function mspa provides a MATLAB MEX interface to the Solar
% Position Algoritm reference implementation spa.c for computing
% to high accuracy the angular position of the sun from positions
% on the earth.
%
% Details of the spa function are provided in the National Renewable
% Energy Laboratory Report NREL/TP-560-34302, Solar Position Algoritm
% for Solar Radiation Applications, by Ibrahim Reda and Afshin
% Andreas. The report, spa.c and accompanying files are available from
% the NLER website, www.nler.gov, at the link
% http://www.nrel.gov/midc/spa/
%
% The file spa.c can not be distributed due to its license,
% but can be downloaded from NLER.
%
%
% The argument to mspa should be a matrix of doubles.
% The matrix should have 17 rows and 1 or more columns.
% Each column should contain data as follows:
%
%                                    Min         Max      Unit
% Row  1    year                   -2000   -    6000      year
% Row  2    month                      1   -      12     month
% Row  3    day                        1   -      31       day
% Row  4    hour                       0   -      24      hour
% Row  5    minute                     0   -      59    minute
% Row  6    second                     0   -      59    second
% Row  7    timezone                 -18   -      18
% Row  8    delta_t                -8000   -    8000    second
% Row  9    longitude               -180   -     180   degrees
% Row 10    latitude                 -90   -      90   degrees
% Row 11    elevation           -6500000   -  \infty     metre
% Row 12    pressure                   0   -    5000  millibar
% Row 13    temperature             -273   -    6000   celsius
% Row 14    slope                   -360   -     360    degree
% Row 15    azm_rotation            -360   -     360    degree 
% Row 16    atmos_refract             -5   -       5    degree
% Row 17    function                   0   -       3   integer
%
% The result is a double matrix with 13 rows and as many columns as
% the argument.  Each column holds the results of calling spa.c with
% the corresponding column of the argument matrix.
% The numbers on the rows of each column are
%                        
% Row  1    julian day
% Row  2    l
% Row  3    b
% Row  4    r
% Row  5    h
% Row  6    del_psi
% Row  7    del_epsilon
% Row  8    epsilon
% Row  9    zenith          Angle between a vertical line at the observation point
%                           and a line from the observation point to the (apparent
%                           position) of the sun.
% Row 10    azimuth         Angle between two lines in a horizontal plane through
%                           the observation point. The observation point and a point
%                           to the north of this forms a reference line. Azimuth is
%                           the angle between the reference line and a line between
%                           the observation point and the intersection point between
%                           the plane and a line through the centre of the (apparent
%                           position) of the sun and perpendicular to the horizontal
%                           plane. The angle is positive to the east of north.
% Row 11    incidence
% Row 12    sunrise         local sunrise time (+/- 30 seconds) [fractional hour]
% Row 13    sunset          local sunset time (+/- 30 seconds) [fractional hour]
%
%
% $Id: mspa.m 92 2011-08-23 16:58:08Z abel $
%
% mspa.m is Copyright (c) 2011 Anders Lennartsson
% All rights reserved.
%
% mspa.m is licensed by the Modified BSD License.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the <organization> nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
