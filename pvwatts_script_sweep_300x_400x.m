% Takes the Excel file generated by the PVWatts online calculator for hourly
% irradiance values and generates new estimated values for a planar solar
% concentrator. Sweeps azimuth and elevation values in order to find 
% annual yield vs. panel orientation.
% This version is for 300x and 400x PMMA arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   INITIAL USER INPUT   %

% Enter filename of Excel output from PVWatts calculator
filename = 'pvwatts_hourly.xlsx';

% Enter system type
% 1 = Standard, 2 = Premium, 3 = Thin Film
type = 2;

% Enter microcell efficiency
pvEff = 0.40;

% Adjust for timezone
timezone = -7;

% Enter year
year = 2016;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ensure that longitudes west of the Prime Meridian are negative
lat = xlsread(filename, 'B4:B4');
lon = xlsread(filename, 'B5:B5') * -1;

% Importing remaining data from spreadsheet
deltaT = 0.041666666 * timezone;
minute = 0;
second = 0;
indexGl = 1.526;
elev = xlsread(filename, 'B6:B6');
time = xlsread(filename, 'A19:C8778');
beamIr = xlsread(filename, 'D19:D8778');
diffIr = xlsread(filename, 'E19:E8778');
diffIrtot = xlsread(filename, 'E8779:E8779');
tempAmb = xlsread(filename, 'F19:F8778');
wind = xlsread(filename, 'G19:G8778');
planeIr = xlsread(filename, 'H19:H8778');
tempCell = xlsread(filename, 'I19:I8778');
outDC = xlsread(filename, 'J19:J8778');
outDCtot = xlsread(filename, 'J8779:J8779');
outAC = xlsread(filename, 'K19:K8778');
outACtot = xlsread(filename, 'K8779:K8779');
sizeWatts = xlsread(filename, 'B7:B7');
%theta = xlsread(filename, 'B10:B10');
%phi = xlsread(filename, 'B11:B11');
systemEff = (100 - xlsread(filename, 'B12:B12')) / 100;
invertEff = xlsread(filename, 'B13:B13') / 100;

dates = zeros(8760, 1);
sunPos = zeros(8760, 2);        %solar azimuth/zenith values from algorithm
sunPosR = zeros(8760, 3);       %solar position vectors in rectangular form
sunPosNewR = zeros(8760, 3);    %post-transform solar position vectors in rectangular form
sunPosNew = zeros(8760, 2);     %post-transform solar position vectors in spherical form
incidence = zeros(8760, 1);     %angle of incidence of the sun with respect to panel normal
incidence2 = zeros(8760, 1);
delIn = zeros(8760, 1);
sumIn = zeros(8760, 1);
transmittance = zeros(8760, 1);
planeIr2 = zeros(8760, 1);
plane300x = zeros(8760, 1);
plane400x = zeros(8760, 1);
eff300x = zeros(8760, 1);
eff400x = zeros(8760, 1);
powerTot300x = zeros(91, 46);
powerTot400x = zeros(91, 46);

if type == 1
    sizePanel = 6.67 * sizeWatts;
    panelEff = 0.15;
elseif type == 2
    sizePanel = 5.25 * sizeWatts;
    panelEff = 0.19;
elseif type == 3
    sizePanel = 6.67 * sizeWatts;
    panelEff = 0.1;
end

% Arrays to interpolate from
p300x = [0 10 20 30 45 60 70 72.5 75 77.5 80 82.5 84;
        .969 .957 .928 .907 .874 .860 .817 .752 .656 .494 .382 .171 .03];

p400x = [0 10 20 30 40 50 60 62.5 65 67.5 70 72.5;
        .956 .952 .952 .936 .879 .868 .836 .736 .495 .355 .151 .0473];

for phi = 90:2:270
    for theta = 0:2:90
        % Generate transform matrix from rotation matrices about X and Z
        Rx = [ 1 ,       0     ,      0     ;
             0 , cosd(theta) , sind(theta);
             0 , -sind(theta), cosd(theta)];
   
        Rz = [ cosd(phi) , sind(phi) ,    0 ;
             -sind(phi) , cosd(phi) ,    0 ;
                    0   ,       0   ,    1  ];
       
        transform = Rx * Rz;
        
        for k = 1:8760
            dates(k) = datenum([year, time(k,1), time(k,2), time(k, 3), minute, second]) - deltaT;
            [sunPos(k,1), sunPos(k,2)] = SolarAzEl(dates(k), lat, lon, elev);
            [sunPosR(k,1), sunPosR(k,2), sunPosR(k,3)] = sph2rect(sunPos(k,1), sunPos(k,2));
            sunPosNewR(k,:) = (transform * (sunPosR(k,:)'))';
            [sunPosNew(k,1), sunPosNew(k,2)] = rect2sph(sunPosNewR(k,1), sunPosNewR(k,2), sunPosNewR(k,3));

            % Correcting elevation angle 
            if sunPos(k,2) < 0
                sunPosNew(k,2) = (-1) * sunPosNew(k,2);
            end  

            % Correcting azimuth angle
            if (sunPos(k,1) > 180) && (sunPosNew(k,1) < 0)
                sunPosNew(k,1) = sunPosNew(k,1) + 360;
            elseif (sunPos(k,1) <180 ) && (sunPosNew(k,1) < 0)
                sunPosNew(k,1) = sunPosNew(k,1) + 180;
            elseif (sunPos(k,1) > 180) && (sunPosNew(k,1) > 0)
                sunPosNew(k,1) = sunPosNew(k,1) + 180;
            end       

            incidence(k) = acosd(sind(90-sunPos(k,2))*cosd(phi - sunPos(k,1))*sind(theta) + cosd(90 - sunPos(k,2))*cosd(theta));  

            if incidence(k) < 90
                incidence2(k) = asind((1/indexGl) * sind(incidence(k)));
                delIn(k) = incidence2(k) - incidence(k);
                sumIn(k) = incidence2(k) + incidence(k);
                transmittance(k) = 1 - 0.5*((sind(delIn(k))^2)/(sind(sumIn(k))^2) + (tand(delIn(k))^2)/(tand(sumIn(k))^2));
            else
                incidence2(k) = 180;
                transmittance(k) = 0;
            end

        %   Re-calculating plane of array incidence using the angle of incidence
        %   values generated in this script
            if incidence(k,1) > 90
               planeIr2(k) = 0;
            else
               planeIr2(k) = (beamIr(k) * cosd(incidence(k))) + ((180 - theta)/180) * diffIr(k);
            end

        end

        % Generating efficiency values for BK7 and PMMA based on incidence angle
        eff300x = interp1(p300x(1,:), p300x(2,:), incidence(:), 'spline', 0);
        eff400x = interp1(p400x(1,:), p400x(2,:), incidence(:), 'spline', 0);

        % Calculating PoA irradiance for BK7 and PMMA optics
        plane300x = beamIr .* cosd(incidence(:));
        plane400x = plane300x;

        % Calculating DC power for BK7 and PMMA optics
        power300x = (systemEff * pvEff) .*eff300x .* plane300x; 
        power400x = (systemEff * pvEff) .*eff400x .* plane400x;
        powerTot300x((phi-90)/2 + 1, (theta/2) + 1) = sizePanel * sum(power300x);
        powerTot400x((phi-90)/2 + 1, (theta/2) + 1) = sizePanel * sum(power400x);    
    end
end

xlswrite('300x_sweep1_power.xlsx', powerTot300x)
xlswrite('400x_sweep1_power.xlsx', powerTot400x)
