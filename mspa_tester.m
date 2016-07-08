% This function mspa_tester.m runs a test on the function spa.c
% and its MEX-interface mspa. It is the same test as spa_tester.c
% included with spa.c.
%
% $Id: mspa_tester.m 76 2011-08-10 20:49:17Z abel $
%
% mspa_tester.m is Copyright (c) 2011 Anders Lennartsson
% All rights reserved.
%
% mspa_tester.m is licensed by the Modified BSD License.
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
arguments= [ 2003;
10;
17;
12;
30;
30;
-7.0;
67;
-105.1786;
39.742476;
1830.14;
820;
11;
30;
-10;
0.5667;
3]
% Calling the spa.c function
results=mspa(arguments)
% Computing the sunrise in hours, minutes and seconds, from the information computed by spa.c
sr=results(12);
srhour=fix(sr);
srmin=(sr-srhour)*60;
srminf=fix(srmin);
srsec=(srmin-srminf)*60;
sr=['Sunrise: ',num2str(srhour),':',num2str(srminf),':',num2str(fix(srsec))]
% Computing the sunset in hours, minutes and seconds, from the information computed by spa.c
ss=results(13);
sshour=fix(ss);
ssmin=(ss-sshour)*60;
ssminf=fix(ssmin);
sssec=(ssmin-ssminf)*60;
ss=['Sunset: ',num2str(sshour),':',num2str(ssminf),':',num2str(fix(sssec))]
% Comparing results with correct answer
correct_output=[ 2452930.312847 ;
2.401826e+01 ;
-1.011219e-04;
0.996542;
11.105902;
-3.998404e-03;
1.666568e-03;
23.440465;
50.111622;
194.340241;
25.187000;
6+(12+43/60)/60;
17+(20+19/60)/60];
difference=results-correct_output
