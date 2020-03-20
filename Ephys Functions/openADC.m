function [data, ADC_file, fpath] = openADC(varargin) %mouserec,type)
%[data, ADC_file, fpath] = openADC()
%[data, ADC_file, fpath] = openADC(mouserec,type)

switch nargin
    case 2
        mouserec = varargin{1}; type = varargin{2};
        [ADC_file, fpath] = uigetfile(['R:\In Vivo\DATAraw\*.dat'],['Select ADC Binary File: ',mouserec,' - ',type]);
        %fpath = ['R:\In Vivo\DATAkilo\',mouserec,'\'];
        %ADC_file = [mouserec,'_',type,'.dat'];
    case 0
        [ADC_file, fpath] = uigetfile('*.dat','Select ADC Binary File');
end
    fid = fopen(fullfile(fpath,ADC_file));  %file indentifier from selected .dat
    data = fread(fid,'int16');  %read from file identifier (fid), must specify 'int16'
    fclose(fid);
end