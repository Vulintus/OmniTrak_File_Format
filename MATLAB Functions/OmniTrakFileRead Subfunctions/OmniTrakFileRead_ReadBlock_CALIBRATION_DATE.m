function data =  OmniTrakFileRead_ReadBlock_CALIBRATION_DATE(fid,data)

%
% OmniTrakFileRead_ReadBlock_CALIBRATION_DATE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OmniTrakFileRead_ReadBlock_CALIBRATION_DATE reads in the 
%   "CALIBRATION_DATE" data block from an *.OmniTrak format file. This 
%   block is intended to contain the most recent calibration date/time for 
%   a connected module, recorded as a serial date number, as well as the 
%   module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x089C
%		DEFINITION:		CALIBRATION_DATE
%		DESCRIPTION:	Most recent calibration date/time, for the specified module index.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',...
    {'port','calibration_date'});                                           %Call the subfunction to check for existing fieldnames.         

port_i = fread(fid,1,'uint8');                                              %Read in the port index.
existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first module...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded module.
    if ~any(i)                                                              %If the port index doesn't match any existing modules...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

serial_date = fread(fid,1,'float64');                                       %Grab the serial date number.
data.device(i).calibration_date = ...
    datetime(serial_date,'ConvertFrom','datenum');                          %Add the calibration date as a datetime class.
data.device(i).port = port_i;                                               %Add the port index.