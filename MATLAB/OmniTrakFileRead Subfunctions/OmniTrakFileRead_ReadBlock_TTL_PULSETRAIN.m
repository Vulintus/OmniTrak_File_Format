function data = OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2048
%		DEFINITION:		TTL_PULSETRAIN
%		DESCRIPTION:	Timestamped event for a TTL pulse output, with channel number, voltage, and duration.

data = OmniTrakFileRead_Check_Field_Name(data,'ttl');                       %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the TTL_PULSETRAIN data block version.

i = length(data.ttl) + 1;                                                   %Increment the TTL pulse index.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1 (implemented 2025-02-10).        
        data.ttl(i).datenum = fread(fid,1,'float64');                       %Serial date number.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.
        data.ttl(i).volts = fread(fid,1,'float32')';                        %Output voltage.
        data.ttl(i).pulse_dur = double(fread(fid,1,'uint32'))/1000;         %Pulse duration, in milliseconds.

    case 2                                                                  %Version 2 (implemented 2025-08-25).
        data.ttl(i).datenum = fread(fid,1,'float64');                       %Serial date number.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.
        data.ttl(i).volts = fread(fid,1,'float32')';                        %Output voltage.
        data.ttl(i).pulse_dur = fread(fid,1,'float32');                     %Pulse duration, in seconds.
        data.ttl(i).pulse_ipi = fread(fid,1,'float32');                     %Offset-to-onset inter-pulse interval, in seconds.
        data.ttl(i).pulse_n = fread(fid,1,'uint16');                        %Number of pulses in the pulsetrain.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end