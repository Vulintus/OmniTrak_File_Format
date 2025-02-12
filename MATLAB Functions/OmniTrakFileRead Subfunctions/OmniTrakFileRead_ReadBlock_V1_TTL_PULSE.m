function data = OmniTrakFileRead_ReadBlock_V1_TTL_PULSE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2048
%		DEFINITION:		TTL_PULSE
%		DESCRIPTION:	Timestamped event for a TTL pulse output, with channel number, voltage, and duration.

data = OmniTrakFileRead_Check_Field_Name(data,'ttl');                       %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the AMBULATION_XY_THETA data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        i = length(data.ttl) + 1;                                           %Increment the TTL pulse index.
        data.ttl(i).datenum = fread(fid,1,'float64');                       %Serial date number.
        data.ttl(i).chan = fread(fid,1,'uint8')';                           %Output channel.
        data.ttl(i).volts = fread(fid,1,'float32')';                        %Output voltage.
        data.ttl(i).dur = fread(fid,1,'uint32');                            %Pulse duration, in milliseconds.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end