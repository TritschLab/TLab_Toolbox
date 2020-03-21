function [WF] = getWFprop(WF, varargin)
%Computation of waveform properties
% 
% Description: This function will compute values for various waveform
%   properties (temporal, shape) based on coordinates for waveform features
%   determined by pre-processing with processWF. 
%
% [WF] = getWFprop(WF, varargin)
%
% INPUT
%   'WF' - structure, pre-processed with processWF
%   varargin
%       {1} 'units' - vector of units to iterate waveform analysis over
%
% OUTPUT
%   WF - structure updated to now include:
%       'WF.peakLatency' = in ms, time between minimum and second maximum. 
%       'WF.halfWidth' = in ms, time width of the spike at half-maximal amplitude of the first maximum. 
%       'WF.amplitude' = in uV, difference between the second maximum and the minimum. 
%       'WF.asymmetry' = ratio of the amplitude of the second maximum to that amplitude of the first maximum.
%       'WF.ratioPkTr' = ratio of peak to trough, between first maximum and minimum
%       'WF.timePkPk'  = in ms, peak-to-peak time between first maximum and second maximum
%
% Created By: Anya Krok, June 2019
% Updated On: March 2020: split getWFprop into two functions: processWFgetWFprop
%

%%
switch nargin
    case 1
        units = [1:length(WF)]; %Will process all units
    case 2
        units = varargin{1}; %Will process only specified units
        if iscolumn(units)
            units = units'; %Make into row vector
        end
end

if ~isfield(WF,'ptX')
    error('No waveform feature x- and y-values present. Must run getWFprop_1 before proceeding.');
end

%% 
peakLatency = zeros(length(WF),1); 
halfWidth   = zeros(length(WF),1);
amplitude   = zeros(length(WF),1); 
asymmetry   = zeros(length(WF),1); 
ratioPkTr   = zeros(length(WF),1); 
timePkPk    = zeros(length(WF),1);

%% 
fprintf('\n Processing waveform properties ... '); 
for x = 1:length(units) 
    n = units(x);  
    
    max_1  = [WF(n).ptX(1), WF(n).ptY(1)]; %Extract values
    min    = [WF(n).ptX(2), WF(n).ptY(2)];
    max_2  = [WF(n).ptX(3), WF(n).ptY(3)];
    half_1 = [WF(n).ptX(4)];  half_2 = [WF(n).ptX(5)];
    
    halfWidth(n) = half_2 - half_1;        % in ms, width of spike at half maximal amplitude
    peakLatency(n) = max_2(1) - min(1);    % in ms, time from max deflection to second max
    amplitude(n) = max_2(2) - min(2);      % in uV, difference between max deflection and second max
    asymmetry(n) = max_2(2)/max_1(2);      % ratio of amplitude of second max and first max
    ratioPkTr(n) = min(2)/(min(2)+max_1(2)); % ratio of peak to trough, between first maximum and minimum
    timePkPk(n)  = max_2(1) - max_1(1);    % in ms, peak-to-peak time between first maximum and second maximum
end

%% 
temp = WF;
if nargin == 2 && isfield(temp,'halfWidth') 
    populate = units; %if already exist, then only merge currently processed units
else 
    populate = 1:length(temp); %if does not exist, then fill completely
end
for n = populate
    temp(n).halfWidth   = halfWidth(n); 
    temp(n).peakLatency = peakLatency(n); 
    temp(n).amplitude   = amplitude(n); 
    temp(n).asymmetry   = asymmetry(n); 
    temp(n).ratioPkTr   = ratioPkTr(n); 
    temp(n).timePkPk    = timePkPk(n); 
end
WF = temp;
fprintf('Finished! \n');
end