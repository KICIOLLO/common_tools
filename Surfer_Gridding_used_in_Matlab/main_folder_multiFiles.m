clc;
clear all;

% ============================================================================
% =====================    Input parameters    ===============================
% ============================================================================
str_dir = 'D:\starcug\windows\Desktop\surfergriddata';
data_type = 'dat';

easting_min  = 77;
easting_max  = 97;
northing_min = 40;
northing_max = 50;

spasigrid_e = 0.1; 
spasigrid_n = 0.1;
method = 'MinCurvature';

% ===============    Processing and results saving    ========================

dirs = dir([str_dir filesep '*.' data_type]);

dircell=struct2cell(dirs);

filenames = dircell(1,:);

filenum = length(filenames);

for i = 1:filenum
	str_open = filenames{i};
	surfergriddata_main(str_open,easting_min,easting_max,northing_min,northing_max,spasigrid_e,spasigrid_n,method);
end



