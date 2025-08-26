function data = OmniTrakFileRead_ReadBlock_AMBULATION_XY_THETA(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1024
%		DEFINITION:		AMBULATION_XY_THETA
%		DESCRIPTION:	A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.

data = OmniTrakFileRead_Check_Field_Name(data,'ambulation',...
    {'path_xy','orientation','micros'});                                    %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the AMBULATION_XY_THETA data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        if isempty(data.ambulation.micros)                                  %If this is the first sample...
            data.ambulation.micros = fread(fid,1,'uint32');                 %Microcontroller microsecond clock timestamp.
            data.ambulation.path_xy = fread(fid,2,'float32')';              %x- and y-coordinates, in millimeters.
            data.ambulation.orientation = fread(fid,1,'float32');           %Animal overhead orientation, in degrees.
        else
            i = size(data.ambulation.micros,1) + 1;                         %Grab a new ambulation path sample index.
            data.ambulation.micros(i,1) = fread(fid,1,'uint32');            %Microcontroller microsecond clock timestamp.
            data.ambulation.path_xy(i,1:2) = fread(fid,2,'float32');        %x- and y-coordinates, in millimeters.
            data.ambulation.orientation(i,1) = fread(fid,1,'float32');      %Animal overhead orientation, in degrees.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end