clc;
clear all;

% ============================================================================
% =====================    Input parameters    ===============================
% ============================================================================
str_open = 'result_deltaTZa.dat';
str_save = 'result_deltaTZa_gridded_new.dat';

easting_min  = 77;
easting_max  = 97;
northing_min = 40;
northing_max = 50;

spasigrid_e = 0.1; 
spasigrid_n = 0.1;
method = 'MinCurvature';
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

str_save_grd = [str_save(1:length(str_save)-4) '.grd'];
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