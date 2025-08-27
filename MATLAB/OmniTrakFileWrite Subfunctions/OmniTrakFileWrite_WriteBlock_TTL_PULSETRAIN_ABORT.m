function OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN_ABORT(fid, block_code, src, chan, varargin)

%
% OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN_ABORT.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_TTL_PULSETRAIN_ABORT writes the channel, 
%   microcontroller timestamp, and serial date number when a TTL pulsetrain
%   abort is indicated during a behavioral program.
%
%   OFBC block code: 0x0801
%
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%


data_block_version = 1;                                                     %Set the TTL_PULSETRAIN block version.

millis = [];                                                                %Assume by default that no millisecond clock reading is provided.
serial_date = [];                                                           %Assume by default that no datetime or serial date number is provided.
for i = 1:2:length(varargin)                                                %Step through the name/value pairs.
    switch lower(varargin{i})                                               %Switch between the different recognized pairs.
        case 'millis'                                                       %Microcontroller millisecond clock.
            millis = varargin{i+1};                                         %Grab the milliseconds clock reading.
        case 'datetime'                                                     %MATLAB datetime or serial date number timestamp.
            serial_date = varargin{i+1};                                    %Grab the MATLAB timestamp.                       
        otherwise                                                           %For any unrecognized name-value pairs.
            error('ERROR IN %s: Input "%s" is not recognized!',...
                upper(mfilename),varargin{i});                              %Throw an error.
    end
end
if isempty(serial_date)                                                     %If no MATLAB timestamp was provided...
    serial_date = now;                                                      %Grab the current serial date number.
elseif isdatetime(serial_date)                                              %If the MATLAB timestamp is in datetime format.
    serial_date = datenum(serial_date);                                     %Convert it to a serial date number.
end

fwrite(fid, block_code, 'uint16');                                          %OmniTrak file format block code.
fwrite(fid, data_block_version, 'uint8');                                   %Write the TTL_PULSETRAIN block version.
fwrite(fid, src, 'uint8');                                                  %Device "port" number.
fwrite(fid, chan, 'uint8');                                                 %Stimulation channel.

datatype_mask = [   ~isempty(serial_date),...                               %MATLAB serial date timestamp.
                    ~isempty(millis),...                                    %Microcontroller millisecond clock timestamp.
                ];                                                          %Create a bit array to indicate which data types are being written.
datatype_mask = sum(datatype_mask.*2.^(0:length(datatype_mask)-1));         %Convert the bit array to an 8-bit bitmask.
fwrite(fid, datatype_mask, 'uint8');                                        %Write a bitmask to indicate which data types will follow.

%Abort timestamp (serial date number).     
fwrite(fid, serial_date, 'float64');                                        

%Abort timestamp (microcontroller millisecond clock).  
if bitget(datatype_mask,2)
    fwrite(fid, millis, 'uint32');                                          
end

      