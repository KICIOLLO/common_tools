function surfergriddata_main(str_open,easting_min,easting_max,northing_min,northing_max,spasigrid_e,spasigrid_n,method)
% Just like griddata but uses surfer instead. Default kringing
%
% Usage:
% surfergriddata_main()
% 
% str_open: 
%    the filename of the original data
%    the results would be saved include gridded three-column .dat file and .grd file

% easting_min/easting_max :
%    the minimum and maximum of the coordinates in the west-east direction

% northing_min/northing_max
%    the minimum and maximum of the coordinates in the south-north direction

% spasigrid_e/spasigrid_n
%    the spacing of the grid in the west-east direction and in the south-north direction

% methods:
%   InverseDistance, Kriging(default), MinCurvature, NaturalNeighbor
%   NearestNeighbor, RadialBasis, Regression, Shepards, Triangulation
%
%
% Shida Sun 2018-11-28 13:55:11


str_save = [str_open(1:length(str_open)-4) '_gridded.dat'];
str_save_grd = [str_save(1:length(str_save)-4) '.grd'];

% =====================      Processing      =================================

data=load(str_open); 
Easting  =data(:,1);  % x
Northing =data(:,2);  % y
zvalue   =data(:,3);  % z

ti_e = easting_min :spasigrid_e:easting_max; 
ti_n = northing_min:spasigrid_n:northing_max; 

[EI,NI]=meshgrid(ti_e,ti_n); 
[Ei, Ni, Zi]=surfergriddata(Easting,Northing,zvalue,EI,NI,method);

% =====================    Saving result *.dat   =============================

fid_save = fopen(str_save, 'w');
for ii = 1:length(Ei)
	for jj = 1:length(Ni)
		fprintf(fid_save, '%12.8f %12.8f %12.8f\r\n', Ei(ii), Ni(jj), Zi(jj,ii));
	end
end

fclose(fid_save);

% =====================    Saving result *.grd   =============================


fid_save_grd = fopen(str_save_grd, 'w');
fprintf(fid_save_grd, '%s\r\n','DSAA');
fprintf(fid_save_grd, '%d %d\r\n',length(Ei),length(Ni));
fprintf(fid_save_grd, '%12.8f %12.8f\r\n',easting_min,easting_max);
fprintf(fid_save_grd, '%12.8f %12.8f\r\n',northing_min,northing_max);
fprintf(fid_save_grd, '%12.8f %12.8f\r\n',min(min(Zi)),max(max(Zi)));

for jj = 1:length(Ni)
	for ii = 1:length(Ei)
		fprintf(fid_save_grd, '%12.8f ',Zi(jj,ii));
		if rem(ii,10) == 0
			fprintf(fid_save_grd, '\r\n');
		end
	end
	fprintf(fid_save_grd, '\r\n');
end
fclose(fid_save_grd);
% // X=randn(100,1);Y=randn(100,1);
% // [Xi,Yi,Zi]=surfergriddata(X,Y,peaks(X,Y));
% // surf(Xi,Yi,Zi)