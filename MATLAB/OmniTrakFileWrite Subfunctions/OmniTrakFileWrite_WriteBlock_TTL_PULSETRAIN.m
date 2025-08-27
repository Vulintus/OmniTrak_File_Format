function OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN(fid, block_code, src, chan, varargin)

%
% OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_TTL_PULSETRAIN writes the channel, 
%   timestamp, voltage, pulse duration, offset-to-onset inter-pulse 
%   interval, and number of pulses for a TTL pulsetrain when one is sent 
%   during a behavioral program.
%
%   OFBC block code: 0x0800
%
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%   2025-08-25 - Drew Sloan - Created new block version (2) to handle 
%                             pulsetrains in addition to single pulses.
%

data_block_version = 2;                                                     %Set the TTL_PULSETRAIN block version.

millis = [];                                                                %Microcontroller millisecond clock reading.
serial_date = [];                                                           %MATLAB datetime or serial date number.
volts = nan(1,2);                                                           %High- and low-voltage levels.
pulse_dur = [];                                                             %Pulse duration.
pulse_ipi = [];                                                             %Offset-to-onset inter-pulse interval.
pulse_num = [];                                                             
for i = 1:2:length(varargin)                                                %Step through the name/value pairs.
    switch lower(varargin{i})                                               %Switch between the different recognized pairs.
        case 'millis'                                                       %Microcontroller millisecond clock.
            millis = varargin{i+1};
        case 'datetime'                                                     %MATLAB datetime or serial date number timestamp.
            serial_date = varargin{i+1};
        case 'volts'                                                        %High/low voltage levels.
            volts = varargin{i+1};
        case 'pulse_dur'                                                    %Pulse duration, in seconds.
            pulse_dur = varargin{i+1};
        case 'pulse_ipi'                                                    %Inter-pulse interval, in seconds.
            pulse_ipi = varargin{i+1};
        case 'pulse_num'                                                    %Number of pulses in the train.
            pulse_num = varargin{i+1};
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

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Write the TTL_PULSETRAIN block version.

fwrite(fid, src, 'uint8');                                                  %Device "port" number.
fwrite(fid, chan, 'uint8');                                                 %Stimulation channel.

datatype_mask = [   1,...                                                   %MATLAB serial date timestamp.
                    ~isempty(millis),...                                    %Microcontroller millisecond clock timestamp.
                    ~isnan(volts(1)),...                                    %Low voltage value.
                    ~isnan(volts(2)),...                                    %High voltage value.
                    ~isempty(pulse_dur) & ~isnan(pulse_dur),...             %Pulse duration.
                    ~isempty(pulse_ipi) & ~isnan(pulse_ipi),...             %Inter-pulse interval.
                    ~isempty(pulse_num) & ~isnan(pulse_num),...             %Number of pulses in the pulsetrain.
                ];                                                          %Create a bit array to indicate which data types are being written.
datatype_mask = sum(datatype_mask.*2.^(0:length(datatype_mask)-1));         %Convert the bit array to an 8-bit bitmask.
fwrite(fid, datatype_mask, 'uint8');                                        %Write a bitmask to indicate which data types will follow.

%TTL pulse onset timestamp (serial date number).
fwrite(fid, serial_date, 'float64');                                        

%Abort timestamp (microcontroller millisecond clock).  
if bitget(datatype_mask,2)
    fwrite(fid, millis, 'uint32');                                          
end

%Low/high voltage levels.
if bitget(datatype_mask,3)
    fwrite(fid, volts(1), 'float32');
end
if bitget(datatype_mask,4)
    fwrite(fid, volts(2), 'float32');
end

%Pulse duration, in seconds.
if bitget(datatype_mask,5)
    fwrite(fid, pulse_dur, 'float32');
end

%Offset-to-onset interpulse interval, in seconds.
if bitget(datatype_mask,6)
    fwrite(fid, pulse_ipi, 'float32');
end

%Number of pulses in the pulsetrain.
if bitget(datatype_mask,7)
    fwrite(fid, pulse_num, 'uint16');
end                   