% This MATLAB script analemma.m computes (among other things) the
% apparent angular position of the sun at an observation point on
% the earth, for the same time of the day for a whole year. Then it
% plots these angular positions and one can observe the approximate
% figure eight that is produced for most positions on the earth.
%
% The script uses the function spa.c through the MATLAB MEX interface mspa.
%
% $Id: analemma.m 90 2011-08-23 16:48:16Z abel $
%
% analemma.m is Copyright (c) 2011 Anders Lennartsson
% All rights reserved.
%
% analemma.m is licensed by the Modified BSD License.
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
%
lat=59.123456789;
lon=17.987654321;
v=[2011 0 0 12 0 0 2 67 lon lat 40 1000 11 30 -10 0.5667 3]';
% jan
v1=v*ones(1,31);
v1(2,:)=1;
v1(3,:)=1:31;
% feb
v2=v*ones(1,28);
v2(2,:)=2;
v2(3,:)=1:28;
% mar
v3=v*ones(1,31);
v3(2,:)=3;
v3(3,:)=1:31;
% apr
v4=v*ones(1,30);
v4(2,:)=4;
v4(3,:)=1:30;
% may
v5=v*ones(1,31);
v5(2,:)=5;
v5(3,:)=1:31;
% jun
v6=v*ones(1,30);
v6(2,:)=6;
v6(3,:)=1:30;
% jul
v7=v*ones(1,31);
v7(2,:)=7;
v7(3,:)=1:31;
% aug
v8=v*ones(1,31);
v8(2,:)=8;
v8(3,:)=1:31;
% sep
v9=v*ones(1,30);
v9(2,:)=9;
v9(3,:)=1:30;
% oct
v10=v*ones(1,31);
v10(2,:)=10;
v10(3,:)=1:31;
% nov
v11=v*ones(1,30);
v11(2,:)=11;
v11(3,:)=1:30;
% dec
v12=v*ones(1,31);
v12(2,:)=12;
v12(3,:)=1:31;
% all year
vv=[v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12];
x=mspa(vv);
plot(x(10,:),90-x(9,:))
axis([floor(min(x(10,:))) ceil(max(x(10,:))) floor(min(90-x(9,:))) ceil(max(90-x(9,:)))])
title('Analemma for noon each day')
xlabel('Longitude')
ylabel('Solar height')
