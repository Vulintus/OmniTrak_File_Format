function data = OmniTrakFileRead_ReadBlock_CLOCK_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		22
%		CLOCK_SYNC

data = OmniTrakFileRead_Check_Field_Name(data,'clock','sync');            %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the AMBULATION_XY_THETA data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.    
        i = length(data.clock.sync) + 1;                                    %Increment the clock synchronization index.
        data.clock.sync(i).port = fread(fid,1,'uint8');                     %Grab the port number.
        type_mask = fread(fid,1,'uint8');                                   %Grab the timestamp type bitmask.
        if bitget(type_mask,1)                                              %If a serial date number was saved...
            data.clock.sync(i).datenum = fread(fid,1,'float64');            %Serial date number.
        end
        if bitget(type_mask,2)                                              %If a millisecond clock reading was saved...
            data.clock.sync(i).millis = fread(fid,1,'uint32');              %Millisecond clock reading.
        end
        if bitget(type_mask,3)                                              %If a microsecond clock reading was saved...
            data.clock.sync(i).micros = fread(fid,1,'uint32');              %Microsecond clock reading.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end