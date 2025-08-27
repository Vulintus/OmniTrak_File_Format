function data = OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN(fid,data)

%
% OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_TTL_PULSETRAIN reads in the 
%   "SESSION_PARAMS_JSON" data block from an *.OmniTrak format file. This 
%   block is intended to contain the fields and values of the "params"
%   field from the Vulintus_Behavior_Session_Class of a behavioral program
%   instance. This block is intended to be a failsafe cpaturing all session
%   parameters in case pertinent parameters are omitted from other data
%   blocks.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0800
%		DEFINITION:		TTL_PULSETRAIN
%		DESCRIPTION:	Timestamped event for a single TTL pulse output, 
%                       with channel number, voltage, pulse duration, 
%                       inter-pulse period, and number of pulses.
%
%   UPDATE LOG:
%       2025-02-10 - Drew Sloan - Function first created.
%       2025-08-26 - Drew Sloan - Added handing for the a Version 2 block
%                                 format that includes multi-pulse
%                                 pulsetrain parameters.
%


data = OmniTrakFileRead_Check_Field_Name(data,'ttl');                       %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the TTL_PULSETRAIN data block version.

i = length(data.ttl) + 1;                                                   %Increment the TTL pulse index.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1 (implemented 2025-02-10).        
        data.ttl(i).start.datenum = fread(fid,1,'float64');                 %Serial date number.
        data.ttl(i).src = 0;                                                %Device "port" number is always zero for block version 1.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.
        data.ttl(i).volts = fread(fid,1,'float32')';                        %Output voltage.
        data.ttl(i).pulse_dur = double(fread(fid,1,'uint32'))/1000;         %Pulse duration, in milliseconds.

    case 2                                                                  %Version 2 (implemented 2025-08-25).
        data.ttl(i).src = fread(fid,1,'uint8')';                            %Device "port" number.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.        
        datatype_mask = fread(fid,1,'uint8')';                              %Bitmask indicating included data types.
        if bitget(datatype_mask,1)                                          %Bitmask bit 1.
            data.ttl(i).start.datenum = fread(fid,1,'float64');             %Serial date number.
        end
        if bitget(datatype_mask,2)                                          %Bitmask bit 2.
            data.ttl(i).start.millis = fread(fid,1,'uint32');               %Serial date number.
        end
        data.ttl(i).volts = nan(1,2);                                       %Pre-allocate an array for voltage levels.
        if bitget(datatype_mask,3)                                          %Bitmask bit 3.
            data.ttl(i).volts(1) = fread(fid,1,'float32')';                 %Low voltage level.
        end
        if bitget(datatype_mask,4)                                          %Bitmask bit 4.
            data.ttl(i).volts(1) = fread(fid,1,'float32')';                 %High voltage level.
        end
        if bitget(datatype_mask,5)                                          %Bitmask bit 5.
            data.ttl(i).pulse_dur = fread(fid,1,'float32');                 %Pulse duration, in seconds.
        end
        if bitget(datatype_mask,6)                                          %Bitmask bit 6.
            data.ttl(i).pulse_ipi = fread(fid,1,'float32');                 %Offset-to-onset inter-pulse interval, in seconds.
        end
        if bitget(datatype_mask,7)                                          %Bitmask bit 7.
            data.ttl(i).pulse_n = fread(fid,1,'uint16');                    %Number of pulses in the pulsetrain.
        end      

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end