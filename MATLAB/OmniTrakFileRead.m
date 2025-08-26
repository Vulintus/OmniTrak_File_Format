function data = OmniTrakFileRead(file,varargin)

%Collated: 08/14/2025, 22:39:50


%
% OmniTrakFileRead.m
% 
%   copyright 2018, Vulintus, Inc.
%
%   OMNITRAKFILEREAD reads in behavioral data from Vulintus' *.OmniTrak
%   file format and returns data organized in the fields of the output
%   "data" structure.
%
%   OMNITRAKFILEREAD_BETA is a beta-testing version of the OmniTrakFileRead
%   function. Use "Deploy_OmniTrakFileRead.m" to generate release versions
%   of OmniTrakFileRead from OmniTrakFileRead_Beta.
%
%   UPDATE LOG:
%   2018-02-22 - Drew Sloan - Function first created.
%   2020-01-29 - Drew Sloan - Block code routing separated into a
%                             programmatically generated switch-case 
%                             subfunction, with separate subfunctions for 
%                             each block code. Coinciding updates were made
%                             to "Update_OmniTrak_Libraries.m" to collate 
%                             all new subfunctions into a release-version 
%                             OmniTrakFileRead.m.
%   2022-03-16 - Drew Sloan - Added an option input argument that
%                             terminates the file read after the header 
%                             information (subject, device type, and 
%                             session start time) is read.
%   2025-02-14 - Drew Sloan - Converted the switch-case statements in the
%                             ReadBlock routing function into a dictionary.
%


verbose = false;                                                            %Default to non-verbose output.
header_only = false;                                                        %Default to reading the entire file, not just the header.
show_waitbar = false;                                                       %Default to not showing a waitbar.
for i = 1:numel(varargin)                                                   %Step through each optional input argument.
    switch lower(varargin{i})                                               %Switch between the recognized input arguments.
        case 'header'                                                       %Just read the header.
            header_only = true;                                             %Set the header only flag to 1.
        case 'verbose'                                                      %Request verbose output.
            verbose = true;                                                 %Set the verbose flag to 1.
        case 'waitbar'                                                      %Request a waitbar.
            show_waitbar = true;                                            %Set the waitbar flag to 1.
    end
end

if ~exist(file,'file') == 2                                                 %If the file doesn't exist...
    error('ERROR IN %s: The specified file doesn''t exist!\n\t%s',...
        upper(mfilename), file);                                            %Throw an error.
end

[~, shortfile, ext] = fileparts(file);                                      %Grab the filename minus the path.
data = struct('file',[]);                                                   %Create a data structure.
data.file.name = [shortfile ext];                                           %Save the filename.

fid = fopen(file,'r');                                                      %Open the input file for read access.
fseek(fid,0,'eof');                                                         %Fast forward to the end of the file.
file_size = ftell(fid);                                                     %Read in the number of bytes in the file.
fseek(fid,0,'bof');                                                         %Rewind to the beginning of the file.

block = fread(fid,1,'uint16');                                              %Read in the first data block code.
if isempty(block) || block ~= hex2dec('ABCD')                               %If the first block isn't the expected OmniTrak file identifier...
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN %s: The specified file doesn''t start with the '...
        '*.OmniTrak 0xABCD identifier code!\n\t%s'],...
        upper(mfilename), file);                                            %Throw an error.
end

block = fread(fid,1,'uint16');                                              %Read in the second data block code.
if isempty(block) || block ~= 1                                             %If the second data block code isn't the format version.
    fclose(fid);                                                            %Close the input file.
    error(['ERROR IN %s: The specified file doesn''t specify an '...
        '*.OmniTrak file version!\n\t%s'], upper(mfilename), file);         %Throw an error.
end
data.file.version = fread(fid,1,'uint16');                                  %Save the file version.

block_read = OmniTrakFileRead_ReadBlock_Dictionary(fid);                    %Load the block read function dictionary.

waitbar_closed = false;                                                     %Create a flag to indicate when the waitbar is closed.
if show_waitbar                                                             %If we're showing a progress waitbar.
    waitbar_str = sprintf('Reading: %s%s',shortfile,ext);                   %Create a string for the waitbar.
    waitbar = big_waitbar('title','OmniTrakFileRead Progress',...
        'string',waitbar_str,...
        'value',ftell(fid)/file_size);                                      %Create a waitbar figure.
end

try                                                                         %Attempt to read in the file.
    
    while ~feof(fid) && ~waitbar_closed                                     %Loop until the end of the file. 
        
        block = fread(fid,1,'uint16');                                      %Read in the next data block code.
        if isempty(block)                                                   %If there was no new block code to read.
            continue                                                        %Skip the rest of the loop.
        end
        
        if verbose && isKey(block_read, block)                              %If verbose output is enabled and this block is recognized...
            fprintf(1,'b%1.0f\t>>\t0x%s: %s\n',...
                ftell(fid)-2,...
                dec2hex(block,4),...
                block_read(block).def_name);                                %Print the block location in the file.
        end
        
        if isKey(block_read, block)                                         %If this block is recognized...
            data = block_read(block).fcn(data);                             %Call the subfunction to read the block.
        else                                                                %Otherwise, if the block isn't recognized...
            fseek(fid,-2,'cof');                                            %Rewind 2 bytes.
            data.unrecognized_block = [];                                   %Create an unrecognized block field.
            data.unrecognized_block.pos = ftell(fid);                       %Save the file position.
            data.unrecognized_block.code = block;                           %Save the data block code.
            fprintf(1,'b%1.0f\t>>\t0x%s: UNRECOGNIZED BLOCK CODE!\n',...
                ftell(fid),...
                dec2hex(block,4));                                          %Print the block location in the file.
            fclose(fid);                                                    %Close the file.
            return                                                          %Skip execution of the rest of the function.
        end
        
        if header_only                                                      %If we're only reading the header.
            if isnt_empty_field(data,'subject','name') && ...
                    isnt_empty_field(data,'file','start') && ...
                    isnt_empty_field(data,'device','type')                  %If all the header fields are read in...
                fclose(fid);                                                %Close the file.
                return                                                      %Skip execution of the rest of the function.
            end
                    
        end

        if show_waitbar                                                     %If we're showing the waitbar...
            if waitbar.isclosed()                                           %If the user closed the waitbar figure...
                waitbar_closed = true;                                      %Set the waitbar closed flag to 1.
            else                                                            %If the waitbar hasn't been closed...
                waitbar.value(ftell(fid)/file_size);                        %Update the waitbar value.
                waitbar.string(sprintf('%s (%1.0f/%1.0f)',waitbar_str,...
                    ftell(fid),file_size));                                 %Update the waitbar text.
            end
        end

    end

catch err                                                                   %If an error occured...
    
    fprintf(1,'\n');                                                        %Print a carriage return.
    cprintf(-[1,0.5,0],'* FILE READ ERROR IN OMNITRAKFILEREAD:');           %Print a warning message.
    [path,filename,ext] = fileparts(file);                                  %Break the filename into parts.     
    cprintf([1,0.5,0],'\n\n\tFILE: %s%s\n', filename, ext);                 %Print the filename.
    if ~isempty(path)                                                       %If the path is included in the filename...
        cprintf([1,0.5,0],'\tPATH: %s\n', path);                            %Print the path.
    end
    cprintf([1,0.5,0],'\n\tERROR: %s (%s)\n', err.message, err.identifier); %Print the error message.
    for i = numel(err.stack):-1:1                                           %Step through each level of the error stack.
        cprintf([1,0.5,0],repmat('\t',1,(numel(err.stack)-i) + 2));         %Print tabs according to the program level.
        cprintf([1,0.5,0],'%s ', err.stack(i).name);                        %Print the offending function name.
        cprintf([1,0.5,0],['<a href="matlab:opentoline(''%s'','...
            '%1.0f)">(line %1.0f)</a>\n'], err.stack(i).file,...
            err.stack(i).line, err.stack(i).line);                          %Print a link to the offending line of code.
    end
    fprintf(1,'\n');                                                        %Print a carriage return.
    
end

fclose(fid);                                                                %Close the input file.

if show_waitbar && ~waitbar.isclosed()                                      %If we're showing the waitbar and it's not yet closed....
    waitbar.close();                                                        %Close the waitbar.
end


function S = OmniTrakFileRead_Check_Field_Name(S,varargin)

%
%OmniTrakFileRead_Check_Field_Name.m - Vulintus, Inc.
%
%   OMNITRAKFILEREAD_CHECK_FIELD_NAME checks to see if the specified field
%   already exist in the data structure being generated by OmniTrakFileRead 
%   and creates the fields if they don't already exist. It is a recursive
%   function that calls itself until it gets to the end of all the
%   fieldnames and branchaes specified by the user.
%   
%   UPDATE LOG:
%   01/28/2021 - Drew Sloan - Function first implemented.
%   03/15/2022 - Drew Sloan - Rewritten to be recursive to allow for a 
%       variable number of new fields and subfields to be added.
%
%Notes for future updates:
%   The setfield function can handle non-scalar inputs, so it can be used
%   to create multiple field branches at a time, like this:
%
%       new_fields = {'field1','field2',field3',...}
%       setfield(data,new_fields{:},[]);
%
%   However, the isfield function does not handle non-scalar inputs, so
%   it's impossible to check if the field exists before creating it. The
%   getfield function handles non-scalar inputs, but it throws an error
%   when given field names that don't yet exist.
%

if nargin == 1                                                              %If only one input, the data structure, was supplied...
    return                                                                  %Skip execution of the rest of the function.
end

fieldname = varargin{1};                                                    %Grab the first fieldname.
if ~iscell(fieldname)                                                       %If the field name isn't a cell.
    fieldname = {fieldname};                                                %Convert it to a cell array.
end
for i = 1:numel(fieldname)                                                  %Step through each specified field name.       
    if ~isfield(S,fieldname{i})                                             %If the structure doesn't yet have the specified field...
        if numel(varargin) > 1                                              %If this isn't the last branch...
            S(1).(fieldname{i}) = [];                                       %Create the field as an empty value.
        else                                                                %Otherwise, if this is the last branch...
            S(1).(fieldname{i}) = struct([]);                               %Create the field as an empty structure.
        end
    end
    if numel(varargin) > 1                                                  %If there's more subfields to add...
        S(1).(fieldname{i}) = ...
            OmniTrakFileRead_Check_Field_Name(S(1).(fieldname{i}),...
            varargin{2:end});                                               %Recursively call the function to add them.
    end
end


function data =  OmniTrakFileRead_ReadBlock_ADMIN_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_ADMIN_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_ADMIN_NAME reads in the "ADMIN_NAME" data
%   block from an *.OmniTrak format file. This block is intended to contain
%   the test administrator's name, i.e. the name of the human experimenter
%   administering the experiment/program.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x00E0
%		DEFINITION:		ADMIN_NAME
%		DESCRIPTION:	Test administrator's name.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'admin','name');              %Call the subfunction to check for existing fieldnames.         

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
if isempty(data.admin.name)                                                 %If no administrator name is yet set...
    data.admin.name = fread(fid,N,'*char')';                                %Add the name to a cell array of names.
else                                                                        %Otherwise...
    if ~iscell(data.admin.name)                                             %If the name field isn't already a cell array.
        data.admin.name = cellstr(data.admin.name);                         %Convert it to a cell array.
    end
    data.admin.name{end+1} = fread(fid,N,'*char')';                         %Add the name to a cell array of names.
end                       


function data = OmniTrakFileRead_ReadBlock_ALSPT19_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1007
%		ALSPT19_ENABLED

fprintf(1,'Need to finish coding for Block 1007: ALSPT19_ENABLED');


function data = OmniTrakFileRead_ReadBlock_ALSPT19_LIGHT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1600
%		ALSPT19_LIGHT

if ~isfield(data,'amb')                                                     %If the structure doesn't yet have an "amb" field..
    data.amb = [];                                                          %Create the field.
end
i = length(data.amb) + 1;                                                   %Grab a new ambient light reading index.
data.amb(i).src = 'ALSPT19';                                                %Save the source of the ambient light reading.
data.amb(i).id = fread(fid,1,'uint8');                                      %Read in the ambient light sensor index (there may be multiple sensors).
data.amb(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.amb(i).int = fread(fid,1,'uint16');                                    %Save the ambient light reading as an unsigned 16-bit value.


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


function data = OmniTrakFileRead_ReadBlock_AMG8833_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1000
%		AMG8833_ENABLED

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'amg')                                                     %If the structure doesn't yet have an "amg" field..
    data.amg = [];                                                          %Create the field.
    data.amg(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.amg(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.amg,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.amg.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.amg(i).pixels) + 1;                                         %Grab a new reading index.   
data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.amg(i).pixels(j).float = nan(8,8);                                     %Create an 8x8 matrix to hold the pixel values.
for k = 8:-1:1                                                              %Step through the rows of pixels.
    data.amg(i).pixels(j).float(k,:) = fliplr(fread(fid,8,'float32'));      %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1110
%		AMG8833_PIXELS_CONV

fprintf(1,'Need to finish coding for Block 1110: AMG8833_PIXELS_CONV');


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1111
%		AMG8833_PIXELS_FL

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'amg')                                                     %If the structure doesn't yet have an "amg" field..
    data.amg = [];                                                          %Create the field.
    data.amg(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.amg(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.amg,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.amg.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.amg(i).pixels) + 1;                                         %Grab a new reading index.   
data.amg(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.amg(i).pixels(j).float = nan(8,8);                                     %Create an 8x8 matrix to hold the pixel values.
for k = 8:-1:1                                                              %Step through the rows of pixels.
    data.amg(i).pixels(j).float(k,:) = fliplr(fread(fid,8,'float32'));      %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1112
%		AMG8833_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1112: AMG8833_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_CONV(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1100
%		AMG8833_THERM_CONV

fprintf(1,'Need to finish coding for Block 1100: AMG8833_THERM_CONV');


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1101
%		AMG8833_THERM_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'AMG8833';                                               %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the AMG8833 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_AMG8833_THERM_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1102
%		AMG8833_THERM_INT

fprintf(1,'Need to finish coding for Block 1102: AMG8833_THERM_INT');


function data = OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		172
%		BATTERY_CURRENT

data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.current) + 1;                                           %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.


function data = OmniTrakFileRead_ReadBlock_BATTERY_FULL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		173
%		BATTERY_FULL

data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_BATTERY_POWER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		175
%		BATTERY_POWER

data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.


function data = OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		174
%		BATTERY_REMAIN

data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.


function data = OmniTrakFileRead_ReadBlock_BATTERY_SOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		170
%		BATTERY_SOC

data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = fread(fid,1,'uint32');                          %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).percent = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.


function data = OmniTrakFileRead_ReadBlock_BATTERY_SOH(fid,data)

%	OmniTrak File Block Code (OFBC):
%		176
%		BATTERY_SOH

data = OmniTrakFileRead_Check_Field_Name(data,'bat','sof');                 %Call the subfunction to check for existing fieldnames.    
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.


function data = OmniTrakFileRead_ReadBlock_BATTERY_STATUS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		177
%		BATTERY_STATUS

readtime = fread(fid,1,'uint32');                                           %Grab the millisecond clock timestamp for the readings.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','soc');                 %Call the subfunction to check for existing fieldnames.
j = length(data.bat.soc) + 1;                                               %Grab a new reading index.   
data.bat.soc(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soc(j).reading = fread(fid,1,'uint16');                            %Save the state-of-charge reading, in percent.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','cur');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.cur) + 1;                                               %Grab a new reading index.   
data.bat.cur(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.cur(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average current draw, in amps.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','full');                %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.full) + 1;                                              %Grab a new reading index.   
data.bat.full(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.full(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery's full capacity, in amp-hours.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','rem');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.rem) + 1;                                               %Grab a new reading index.   
data.bat.rem(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.rem(j).reading = double(fread(fid,1,'uint16'))/1000;               %Save the battery's remaining capacity, in amp-hours.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','pwr');                 %Call the subfunction to check for existing fieldnames.        
j = length(data.bat.pwr) + 1;                                               %Grab a new reading index.   
data.bat.pwr(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.pwr(j).reading = double(fread(fid,1,'int16'))/1000;                %Save the average power draw, in Watts.
data = OmniTrakFileRead_Check_Field_Name(data,'bat','soh');                 %Call the subfunction to check for existing fieldnames.
j = length(data.bat.soh) + 1;                                               %Grab a new reading index.   
data.bat.soh(j).timestamp = readtime;                                       %Save the millisecond clock timestamp for the reading.
data.bat.soh(j).reading = fread(fid,1,'int16');                             %Save the state-of-health reading, in percent.


function data = OmniTrakFileRead_ReadBlock_BATTERY_VOLTS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		171
%		BATTERY_VOLTS

data = OmniTrakFileRead_Check_Field_Name(data,'bat','volt');                %Call the subfunction to check for existing fieldnames.         
j = length(data.bat.volt) + 1;                                              %Grab a new reading index.   
data.bat.volt(j).timestamp = readtime;                                      %Save the millisecond clock timestamp for the reading.
data.bat.volt(j).reading = double(fread(fid,1,'uint16'))/1000;              %Save the battery voltage, in volts.


function data = OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1120
%		BH1749_RGB

data = OmniTrakFileRead_Check_Field_Name(data,'light');                     %Call the subfunction to check for existing fieldnames.
i = length(data.light) + 1;                                                 %Grab a new ambient light reading index.
data.light(i).src = 'BH1749';                                               %Save the source of the ambient light reading.
data.light(i).id = fread(fid,1,'uint8');                                    %Read in the BME680/688 sensor index (there may be multiple sensors).
data.light(i).timestamp = fread(fid,1,'uint32');                            %Save the microcontroller millisecond clock timestamp for the reading.
data.light(i).rgb = fread(fid,3,'uint16');                                  %Save the primary RGB ADC readings as uint16 values.
data.light(i).nir = fread(fid,1,'uint16');                                  %Save the near-infrared (NIR) ADC reading as a uint16 value.
data.light(i).grn2 = fread(fid,1,'uint16');                                 %Save the secondary Green-2 ADC reading as a uint16 value.


function data = OmniTrakFileRead_ReadBlock_BME280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1002
%		BME280_ENABLED

fprintf(1,'Need to finish coding for Block 1002: BME280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BME280_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1220
%		BME280_HUM_FL

if ~isfield(data,'hum')                                                     %If the structure doesn't yet have a "hum" field..
    data.hum = [];                                                          %Create the field.
end
i = length(data.hum) + 1;                                                   %Grab a new pressure reading index.
data.hum(i).src = 'BME280';                                                 %Save the source of the pressure reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME280 sensor index (there may be multiple sensors).
data.hum(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.hum(i).float = fread(fid,1,'float32');                                 %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME280_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1210
%		BME280_PRES_FL

if ~isfield(data,'pres')                                                    %If the structure doesn't yet have a "pres" field..
    data.pres = [];                                                         %Create the field.
end
i = length(data.pres) + 1;                                                  %Grab a new pressure reading index.
data.pres(i).src = 'BMP280';                                                %Save the source of the pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.pres(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.pres(i).float = fread(fid,1,'float32');                                %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME280_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1200
%		BME280_TEMP_FL

if ~isfield(data,'temp')                                                    %If the structure doesn't yet have a "temp" field..
    data.temp = [];                                                         %Create the field.
end
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BMP280';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1003
%		BME680_ENABLED

fprintf(1,'Need to finish coding for Block 1003: BME680_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1230
%		DEFINITION:		BME680_GAS_FL
%		DESCRIPTION:	The current BME680 gas resistance reading as a converted float32 value, in units of kOhms

data = OmniTrakFileRead_Check_Field_Name(data,'gas');                       %Call the subfunction to check for existing fieldnames.
i = length(data.gas) + 1;                                                   %Grab a new gas resistance reading index.
data.gas(i).src = 'BME68X';                                                 %Save the source of the gas resistance reading.
data.gas(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.gas(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.gas(i).kohms = fread(fid,1,'float32');                                 %Save the gas resistance reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1221
%		DEFINITION:		BME680_HUM_FL
%		DESCRIPTION:	The current BME680 humidity reading as a converted float32 value, in percent (%).

data = OmniTrakFileRead_Check_Field_Name(data,'hum');                       %Call the subfunction to check for existing fieldnames.
i = length(data.hum) + 1;                                                   %Grab a new ambient humidity reading index.
data.hum(i).src = 'BME68X';                                                 %Save the source of the ambient humidity reading.
data.hum(i).id = fread(fid,1,'uint8');                                      %Read in the BME680/688 sensor index (there may be multiple sensors).
data.hum(i).timestamp = fread(fid,1,'uint32');                              %Save the microcontroller millisecond clock timestamp for the reading.
data.hum(i).percent = fread(fid,1,'float32');                               %Save the ambient humidity reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1212
%		BME680_PRES_FL

data = OmniTrakFileRead_Check_Field_Name(data,'pres');                      %Call the subfunction to check for existing fieldnames.
i = length(data.pres) + 1;                                                  %Grab a new ambient pressure reading index.
data.pres(i).src = 'BME68X';                                                %Save the source of the ambient pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.pres(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.pres(i).pascals = fread(fid,1,'float32');                              %Save the ambient pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BME680_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1202
%		BME680_TEMP_FL

data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BME68X';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BME680/688 sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BMP280_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1001
%		BMP280_ENABLED

fprintf(1,'Need to finish coding for Block 1001: BMP280_ENABLED');


function data = OmniTrakFileRead_ReadBlock_BMP280_PRES_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1211
%		BMP280_PRES_FL

if ~isfield(data,'pres')                                                    %If the structure doesn't yet have a "pres" field..
    data.pres = [];                                                         %Create the field.
end
i = length(data.pres) + 1;                                                  %Grab a new pressure reading index.
data.pres(i).src = 'BME280';                                                %Save the source of the pressure reading.
data.pres(i).id = fread(fid,1,'uint8');                                     %Read in the BME280 sensor index (there may be multiple sensors).
data.pres(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.pres(i).float = fread(fid,1,'float32');                                %Save the pressure reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_BMP280_TEMP_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1201
%		BMP280_TEMP_FL

if ~isfield(data,'temp')                                                    %If the structure doesn't yet have a "temp" field..
    data.temp = [];                                                         %Create the field.
end
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'BMP280';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the BMP280 sensor index (there may be multiple sensors).
data.temp(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.temp(i).float = fread(fid,1,'float32');                                %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2200
%		CALIBRATION_BASELINE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).baseline = fread(fid,1,'float32');                      %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2202
%		CALIBRATION_BASELINE_ADJUST

fprintf(1,'Need to finish coding for Block 2202: CALIBRATION_BASELINE_ADJUST');


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


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2201
%		CALIBRATION_SLOPE

data = OmniTrakFileRead_Check_Field_Name(data,'calibration');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.calibration(i).slope = fread(fid,1,'float32');                         %Save the calibration baseline coefficient.


function data = OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE_ADJUST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2203
%		CALIBRATION_SLOPE_ADJUST

fprintf(1,'Need to finish coding for Block 2203: CALIBRATION_SLOPE_ADJUST');


function data =  OmniTrakFileRead_ReadBlock_CAPSENSE_BITMASK(fid,data)

%
% OmniTrakFileRead_ReadBlock_CAPSENSE_BITMASK.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_CAPSENSE_BITMASK reads the values from a
%   "CAPSENSE_BITMASK" data block in a Vulintus *.OmniTrak format file and
%   adds them to a data structure for analysis.
%
%   Data block value:       0x0A10
%   Data block name:        CAPSENSE_BITMASK
%   Data block description: Capacitive sensor status bitmask, typically 
%                           written only when it changes.
%
%   UPDATE LOG:
%   2025-06-05 - Drew Sloan - Function first created.
%


ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'capsense',...
    {'datenum','micros','status','value'});                                 %Call the subfunction to check for existing fieldnames.         
i = size(data.capsense.datenum,1) + 1;                                      %Find the next bitmask index.

if i == 1                                                                   %If this is the first bitmask reading...
    data.capsense.datenum = fread(fid,1,'float64');                         %Save the serial date number timestamp.
    data.capsense.micros = fread(fid,1,'float32');                          %Save the microcontroller microsecond timestamp.
else                                                                        %Otherwise...
    data.capsense.datenum(i,1) = fread(fid,1,'float64');                    %Save the serial date number timestamp.
    data.capsense.micros(i,1) = fread(fid,1,'float32');                     %Save the microcontroller microsecond timestamp.
end

num_sensors = fread(fid,1,'uint8');                                         %Read in the number of sensors.
capsense_mask = fread(fid,1,'uint8');                                       %Read in the sensor status bitmask.
capsense_status = bitget(capsense_mask,1:num_sensors);                      %Grab the status for each nosecapsense.
if i == 1                                                                   %If this is the first nosepoke event...
    data.capsense.status = capsense_status;                                 %Create the status matrix.
else                                                                        %Otherwise...
    data.capsense.status(i,:) = capsense_status;                            %Add the new status to the matrix.
end


function data =  OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE(fid,data)

%
% OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_CAPSENSE_VALUE reads the values from a
%   "CAPSENSE_VALUE" data block in a Vulintus *.OmniTrak format file and
%   adds them to a data structure for analysis.
%
%   Data block value:       0x0A11
%   Data block name:        CAPSENSE_VALUE
%   Data block description: Capacitive sensor reading for one sensor, in 
%                           ADC ticks or clock cycles.
%
%   UPDATE LOG:
%   2025-06-05 - Drew Sloan - Function first created.
%


ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'capsense',...
    {'datenum','micros','status','value'});                                 %Call the subfunction to check for existing fieldnames.         
i = size(data.capsense.datenum,1) + 1;                                      %Find the next bitmask index.

if i == 1                                                                   %If this is the first bitmask reading...
    data.capsense.datenum = fread(fid,1,'float64');                         %Save the serial date number timestamp.
    data.capsense.micros = fread(fid,1,'float32');                          %Save the microcontroller microsecond timestamp.
else                                                                        %Otherwise...
    data.capsense.datenum(i,1) = fread(fid,1,'float64');                    %Save the serial date number timestamp.
    data.capsense.micros(i,1) = fread(fid,1,'float32');                     %Save the microcontroller microsecond timestamp.
end

num_sensors = fread(fid,1,'uint8');                                         %Read in the number of sensors.
capsense_mask = fread(fid,1,'uint8');                                       %Read in the sensor status bitmask.
capsense_status = bitget(capsense_mask,1:num_sensors);                      %Grab the status for each nosecapsense.
if i == 1                                                                   %If this is the first nosepoke event...
    data.capsense.status = capsense_status;                                 %Create the status matrix.
else                                                                        %Otherwise...
    data.capsense.status(i,:) = capsense_status;                            %Add the new status to the matrix.
end

sensor_index = fread(fid,1,'uint8');                                        %Read the sensor index.
sensor_val = fread(fid,1,'uint16');                                         %Read the sensor value.
j = size(data.capsense.value,1) + 1;                                        %Find the next value index.
if j == 1                                                                   %If this is the first value reading...
    data.capsense.status = [sensor_index, sensor_val, i];                   %Create the status matrix.
else                                                                        %Otherwise...
    data.capsense.status(j,:) = [sensor_index, sensor_val, i];              %Add the new status to the matrix.
end


function data = OmniTrakFileRead_ReadBlock_CCS811_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1004
%		CCS811_ENABLED

fprintf(1,'Need to finish coding for Block 1004: CCS811_ENABLED');


function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		6
%		CLOCK_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file','start','datenum');    %Call the subfunction to check for existing fieldnames.    
data.file.start.datenum = fread(fid,1,'float64');                           %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		7
%		CLOCK_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file','stop','datenum');     %Call the subfunction to check for existing fieldnames.
data.file.stop.datenum = fread(fid,1,'float64');                            %Save the file stop 32-bit millisecond clock timestamp.


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


function data = OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_COMPUTER_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_COMPUTER_NAME reads in the "COMPUTER_NAME" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain the computer name set in Windows for the computer running the
%   data collection program, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006A
%		DEFINITION:		COMPUTER_NAME
%		DESCRIPTION:	Windows PC computer name.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','computer');         %Call the subfunction to check for existing fieldnames.

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.computer = fread(fid,N,'*char')';                               %Read in the computer name.


function data = OmniTrakFileRead_ReadBlock_COM_PORT(fid,data)

%
% OmniTrakFileRead_ReadBlock_COM_PORT.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_COM_PORT reads in the "COM_PORT" data block
%   from an *.OmniTrak format file. This block is intended to contain the
%   the USB COM port name for the wired USB connection between the Vulintus
%   system and the computer running the data collection program, written as
%   characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006B
%		DEFINITION:		COM_PORT
%		DESCRIPTION:	The COM port of a computer-connected system.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','com_port');         %Call the subfunction to check for existing fieldnames.

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.com_port = char(fread(fid,N,'uchar')');                         %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	142
%		DEFINITION:		CTRL_FW_DATE
%		DESCRIPTION:	Controller firmware upload date, copied from the macro, written as characters.
%
% str = handles.ctrl.get_firmware_date();                                  
% fwrite(fid,ofbc.CTRL_FW_DATE,'uint16');                       
% fwrite(fid,length(str),'uint8');                                      
% fwrite(fid,str,'uchar');                              

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','upload_time');                                              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
str = char(fread(fid,N,'uchar')');                                          %Read in the characters of the macro.
if numel(str) > 11                                                          %If there's more than 11 characters in the timestamp...    
    N = N - 11;                                                             %Calculate how many extra bytes were read.
    fseek(fid,-N,'cof');                                                    %Rewind the data file back the extra bytes.
    a = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    block_code = 0;                                                         %Create a block code checker.
    while block_code ~= 143 && ~feof(fid)                                   %Loop until we get to the firmware time.
        block_code = fread(fid,1,'uint16');                                 %Read in two bytes as a block code.
        fseek(fid,-1,'cof');                                                %Rewind one byte.
    end
    fseek(fid,-1,'cof');                                                    %Rewind another byte.
    b = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    fprintf(1,'FW_DATE Weirdness: %1.0f extra bytes.\n',b-a);               %Write the number of bytes in between.
end
date_val = datenum(str(1:11));                                              %Convert the date string to a date number.
if ~isempty(data.device.controller.firmware.upload_time)                    %If there's already an upload time listed...
    time_val = rem(data.device.controller.firmware.upload_time);            %Grab the fractional part of the timestamp.
else                                                                        %Otherwise...
    time_val = 0;                                                           %Set the fraction time to zero.
end
data.device.controller.firmware.upload_time = date_val + time_val;          %Save the date with any existing fractional time.


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	141
%		DEFINITION:		CTRL_FW_FILENAME
%		DESCRIPTION:	Controller firmware filename, copied from the macro, written as characters.
%
% fwrite(fid,ofbc.CTRL_FW_FILENAME,'uint16');  
% fwrite(fid,length(str),'uint8');                
% fwrite(fid,str,'uchar');                                   

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','filename');                                                 %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.controller.firmware.filename = char(fread(fid,N,'uchar')');     %Read in the firmware filename.
if ~endsWith(data.device.controller.firmware.filename,'ino')                %If the filename doesn't end in *.ino...
    while ~endsWith(data.device.controller.firmware.filename,'.ino')        %Loop until we find the *.ino extension.
        fseek(fid,-N,'cof');                                                %Rewind the file to the start of the characters.
        N = N + 1;                                                          %Increment the character count.
        data.device.controller.firmware.filename = ...
            char(fread(fid,N,'uchar')');                                    %Read in the firmware filename.
%         fprintf(1,'%s\n',data.device.controller.firmware.filename)
    end
end


function data = OmniTrakFileRead_ReadBlock_CTRL_FW_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	143
%		DEFINITION:		CTRL_FW_TIME
%		DESCRIPTION:	Controller firmware upload time, copied from the macro, written as characters.
%
% str = handles.ctrl.get_firmware_time();
% fwrite(fid,ofbc.CTRL_FW_TIME,'uint16');
% fwrite(fid,length(str),'uint8');
% fwrite(fid,str,'uchar');
%

data = OmniTrakFileRead_Check_Field_Name(data,'device','controller',...
    'firmware','upload_time');                                              %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
str = char(fread(fid,N,'uchar')');                                          %Read in the characters of the macro.
if numel(str) > 8                                                           %If there's more than 11 characters in the timestamp...
    N = N - 8;                                                              %Calculate how many extra bytes were read.
    fseek(fid,-N,'cof');                                                    %Rewind the data file back the extra bytes.
    a = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    block_code = 0;                                                         %Create a block code checker.
    while block_code ~= 110 && ~feof(fid)                                   %Loop until we get to the firmware time.
        block_code = fread(fid,1,'uint16');                                 %Read in two bytes as a block code.
        fseek(fid,-1,'cof');                                                %Rewind one byte.
    end
    fseek(fid,-1,'cof');                                                    %Rewind another byte.
    b = ftell(fid);                                                         %Grab the starting position of the weird chunk.
    fprintf(1,'FW_TIME Weirdness: %1.0f extra bytes.\n',b-a);               %Write the number of bytes in between.
end
time_val = rem(datenum(str(1:8)),1);                                        %Convert the time string to a date number.
if ~isempty(data.device.controller.firmware.upload_time)                    %If there's already an upload time listed...
    date_val = fix(data.device.controller.firmware.upload_time);            %Grab the non-fractional part of the timestamp.
else                                                                        %Otherwise...
    date_val = 0;                                                           %Set the non-fractional time to zero.
end
data.device.controller.firmware.upload_time = date_val + time_val;          %Save the date with any existing fractional time.


function data = OmniTrakFileRead_ReadBlock_DEBUG_SANITY_CHECK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1121
%		DEFINITION:		DEBUG_SANITY_CHECK
%		DESCRIPTION:	A special block acting as a sanity check, only used in cases of debugging

fprintf(1,'Need to finish coding for Block 1121: DEBUG_SANITY_CHECK\n');


function data = OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data)

%
% OmniTrakFileRead_ReadBlock_DEVICE_ALIAS.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_DEVICE_ALIAS reads in the "DEVICE_ALIAS" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain a unique human-readable serial number, typically an
%   adjective + noun combination such as ArdentAardvark or MellowMuskrat,
%   for example, written as characters.
%
%   Note that this data block assumes the device alias is for the primary 
%   device or controller, and assigns a port index of zero. Device aliases 
%   for connected modules should be saved with the "MODULE_VULINTUS_ALIAS"
%   block.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x006C
%		DEFINITION:		DEVICE_ALIAS
%		DESCRIPTION:	Human-readable Adjective + Noun alias/name for the
%                       device, assigned by Vulintus during manufacturing.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',{'alias','port'});   %Call the subfunction to check for existing fieldnames.

port_i = 0;                                                                 %Set the port index.

existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first module...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded module.
    if ~any(i)                                                              %If the port index doesn't match any existing modules...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the device alias.
data.device(i).alias = fread(fid,N,'*char')';                               %Save the 32-bit SAMD chip ID.
data.device(i).port = port_i;                                               %Add the port index.


function data = OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data)

%	OmniTrak File Block Code (OFBC):
%		10
%		DEVICE_FILE_INDEX

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.file_index = fread(fid,1,'uint32');                             %Save the 32-bit integer file index.


function data = OmniTrakFileRead_ReadBlock_DEVICE_RESET_COUNT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		140
%		DEVICE_RESET_COUNT

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.reset_count = fread(fid,1,'uint16');                            %Save the device's reset count for the file.


function data = OmniTrakFileRead_ReadBlock_DOWNLOAD_SYSTEM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		43
%		DOWNLOAD_SYSTEM

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download');      %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.computer = ...
    char(fread(fid,N,'uchar')');                                            %Read in the computer name.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.file_info.download.port = char(fread(fid,N,'uchar')');                 %Read in the port name.


function data = OmniTrakFileRead_ReadBlock_DOWNLOAD_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		42
%		DOWNLOAD_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','download',...
    'time');                                                                %Call the subfunction to check for existing fieldnames.
data.file_info.download.time = fread(fid,1,'float64');                      %Read in the timestamp for the download.


function block_read = OmniTrakFileRead_ReadBlock_Dictionary(fid)

%
% OmniTrakFileRead_ReadBlock_Dictionary.m
%
%	copyright 2025, Vulintus, Inc.
%
%	OmniTrak file data block read subfunction router.
%
%	Library documentation:
%	https://github.com/Vulintus/OmniTrak_File_Format
%
%	This function was programmatically generated: 2025-06-18, 08:38:19 (UTC)
%

block_read = dictionary;


% The version of the file format used.
block_read(1) = struct('def_name', 'FILE_VERSION', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FILE_VERSION(fid,data));

% Value of the SoC millisecond clock at file creation.
block_read(2) = struct('def_name', 'MS_FILE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data));

% Value of the SoC millisecond clock when the file is closed.
block_read(3) = struct('def_name', 'MS_FILE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data));

% A single subject's name.
block_read(4) = struct('def_name', 'SUBJECT_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data));


% Computer clock serial date number at file creation (local time).
block_read(6) = struct('def_name', 'CLOCK_FILE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_FILE_START(fid,data));

% Computer clock serial date number when the file is closed (local time).
block_read(7) = struct('def_name', 'CLOCK_FILE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_FILE_STOP(fid,data));


% The device's current file index.
block_read(10) = struct('def_name', 'DEVICE_FILE_INDEX', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_FILE_INDEX(fid,data));


% A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.
block_read(20) = struct('def_name', 'NTP_SYNC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_NTP_SYNC(fid,data));

% Indicates the an NTP synchonization attempt failed.
block_read(21) = struct('def_name', 'NTP_SYNC_FAIL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_NTP_SYNC_FAIL(fid,data));

% The current serial date number, millisecond clock reading, and/or microsecond clock reading at a single timepoint.
block_read(22) = struct('def_name', 'CLOCK_SYNC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CLOCK_SYNC(fid,data));

% Indicates that the millisecond timer rolled over since the last loop.
block_read(23) = struct('def_name', 'MS_TIMER_ROLLOVER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MS_TIMER_ROLLOVER(fid,data));

% Indicates that the microsecond timer rolled over since the last loop.
block_read(24) = struct('def_name', 'US_TIMER_ROLLOVER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_US_TIMER_ROLLOVER(fid,data));

% Computer clock time zone offset from UTC.
block_read(25) = struct('def_name', 'TIME_ZONE_OFFSET', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET(fid,data));

% Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes
block_read(26) = struct('def_name', 'TIME_ZONE_OFFSET_HHMM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data));


% Current date/time string from the real-time clock.
block_read(30) = struct('def_name', 'RTC_STRING_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_STRING_DEPRECATED(fid,data));

% Current date/time string from the real-time clock.
block_read(31) = struct('def_name', 'RTC_STRING', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_STRING(fid,data));

% Current date/time values from the real-time clock.
block_read(32) = struct('def_name', 'RTC_VALUES', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RTC_VALUES(fid,data));


% The original filename for the data file.
block_read(40) = struct('def_name', 'ORIGINAL_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ORIGINAL_FILENAME(fid,data));

% A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
block_read(41) = struct('def_name', 'RENAMED_FILE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_RENAMED_FILE(fid,data));

% A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
block_read(42) = struct('def_name', 'DOWNLOAD_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DOWNLOAD_TIME(fid,data));

% The computer system name and the COM port used to download the data file form the OmniTrak device.
block_read(43) = struct('def_name', 'DOWNLOAD_SYSTEM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DOWNLOAD_SYSTEM(fid,data));


% Indicates that the file will end in an incomplete block.
block_read(50) = struct('def_name', 'INCOMPLETE_BLOCK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_INCOMPLETE_BLOCK(fid,data));


% Date/time values from a user-set timestamp.
block_read(60) = struct('def_name', 'USER_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_USER_TIME(fid,data));


% Vulintus system ID code (1 = MotoTrak, 2 = OmniTrak, 3 = HabiTrak, 4 = OmniHome, 5 = SensiTrak, 6 = Prototype).
block_read(100) = struct('def_name', 'SYSTEM_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data));

% Vulintus system name.
block_read(101) = struct('def_name', 'SYSTEM_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data));

% Vulintus system hardware version.
block_read(102) = struct('def_name', 'SYSTEM_HW_VER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data));

% System firmware version, written as characters.
block_read(103) = struct('def_name', 'SYSTEM_FW_VER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data));

% System serial number, written as characters.
block_read(104) = struct('def_name', 'SYSTEM_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data));

% Manufacturer name for non-Vulintus systems.
block_read(105) = struct('def_name', 'SYSTEM_MFR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data));

% Windows PC computer name.
block_read(106) = struct('def_name', 'COMPUTER_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_COMPUTER_NAME(fid,data));

% The COM port of a computer-connected system.
block_read(107) = struct('def_name', 'COM_PORT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_COM_PORT(fid,data));

% Human-readable Adjective + Noun alias/name for the device, assigned by Vulintus during manufacturing.
block_read(108) = struct('def_name', 'DEVICE_ALIAS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_ALIAS(fid,data));


% Primary module name, for systems with interchangeable modules.
block_read(110) = struct('def_name', 'PRIMARY_MODULE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PRIMARY_MODULE(fid,data));

% Primary input name, for modules with multiple input signals.
block_read(111) = struct('def_name', 'PRIMARY_INPUT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data));

% The SAMD manufacturer's unique chip identifier.
block_read(112) = struct('def_name', 'SAMD_CHIP_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data));


% The MAC address of the device's ESP8266 module.
block_read(120) = struct('def_name', 'ESP8266_MAC_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_MAC_ADDR(fid,data));

% The local IPv4 address of the device's ESP8266 module.
block_read(121) = struct('def_name', 'ESP8266_IP4_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_IP4_ADDR(fid,data));

% The ESP8266 manufacturer's unique chip identifier
block_read(122) = struct('def_name', 'ESP8266_CHIP_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_CHIP_ID(fid,data));

% The ESP8266 flash chip's unique chip identifier
block_read(123) = struct('def_name', 'ESP8266_FLASH_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data));


% The user's name for the system, i.e. booth number.
block_read(130) = struct('def_name', 'USER_SYSTEM_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_USER_SYSTEM_NAME(fid,data));


% The current reboot count saved in EEPROM or flash memory.
block_read(140) = struct('def_name', 'DEVICE_RESET_COUNT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEVICE_RESET_COUNT(fid,data));

% Controller firmware filename, copied from the macro, written as characters.
block_read(141) = struct('def_name', 'CTRL_FW_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_FILENAME(fid,data));

% Controller firmware upload date, copied from the macro, written as characters.
block_read(142) = struct('def_name', 'CTRL_FW_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_DATE(fid,data));

% Controller firmware upload time, copied from the macro, written as characters.
block_read(143) = struct('def_name', 'CTRL_FW_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CTRL_FW_TIME(fid,data));

% OTMP Module firmware filename, copied from the macro, written as characters.
block_read(144) = struct('def_name', 'MODULE_FW_FILENAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data));

% OTMP Module firmware upload date, copied from the macro, written as characters.
block_read(145) = struct('def_name', 'MODULE_FW_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_DATE(fid,data));

% OTMP Module firmware upload time, copied from the macro, written as characters.
block_read(146) = struct('def_name', 'MODULE_FW_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_FW_TIME(fid,data));

% OTMP module name, written as characters.
block_read(147) = struct('def_name', 'MODULE_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_NAME(fid,data));

% OTMP Module SKU, typically written as 4 characters.
block_read(148) = struct('def_name', 'MODULE_SKU', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_SKU(fid,data));


% OTMP Module serial number, written as characters.
block_read(153) = struct('def_name', 'MODULE_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_SN(fid,data));


% The MAC address of the device's ATWINC1500 module.
block_read(150) = struct('def_name', 'WINC1500_MAC_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_WINC1500_MAC_ADDR(fid,data));

% The local IPv4 address of the device's ATWINC1500 module.
block_read(151) = struct('def_name', 'WINC1500_IP4_ADDR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_WINC1500_IP4_ADDR(fid,data));


% Current battery state-of charge, in percent.
block_read(170) = struct('def_name', 'BATTERY_SOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_SOC(fid,data));

% Current battery voltage, in millivolts.
block_read(171) = struct('def_name', 'BATTERY_VOLTS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_VOLTS(fid,data));

% Average current draw from the battery, in milli-amps.
block_read(172) = struct('def_name', 'BATTERY_CURRENT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_CURRENT(fid,data));

% Full capacity of the battery, in milli-amp hours.
block_read(173) = struct('def_name', 'BATTERY_FULL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_FULL(fid,data));

% Remaining capacity of the battery, in milli-amp hours.
block_read(174) = struct('def_name', 'BATTERY_REMAIN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_REMAIN(fid,data));

% Average power draw, in milliWatts.
block_read(175) = struct('def_name', 'BATTERY_POWER', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_POWER(fid,data));

% Battery state-of-health, in percent.
block_read(176) = struct('def_name', 'BATTERY_SOH', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_SOH(fid,data));

% Combined battery state-of-charge, voltage, current, capacity, power, and state-of-health.
block_read(177) = struct('def_name', 'BATTERY_STATUS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BATTERY_STATUS(fid,data));


% Actual rotation rate, in RPM, of the feeder servo (OmniHome) when set to 180 speed.
block_read(190) = struct('def_name', 'FEED_SERVO_MAX_RPM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data));

% Current speed setting (0-180) for the feeder servo (OmniHome).
block_read(191) = struct('def_name', 'FEED_SERVO_SPEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data));


% A single subject's name.
block_read(200) = struct('def_name', 'SUBJECT_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data));

% The subject's or subjects' experimental group name.
block_read(201) = struct('def_name', 'GROUP_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_GROUP_NAME(fid,data));


% Test administrator's name.
block_read(224) = struct('def_name', 'ADMIN_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ADMIN_NAME(fid,data));


% The user's name for the current experiment.
block_read(300) = struct('def_name', 'EXP_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_EXP_NAME(fid,data));

% The user's name for task type, which can be a variant of the overall experiment type.
block_read(301) = struct('def_name', 'TASK_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data));


% The stage name for a behavioral session.
block_read(400) = struct('def_name', 'STAGE_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data));

% The stage description for a behavioral session.
block_read(401) = struct('def_name', 'STAGE_DESCRIPTION', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAGE_DESCRIPTION(fid,data));


% Indicates that an AMG8833 thermopile array sensor is present in the system.
block_read(1000) = struct('def_name', 'AMG8833_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_ENABLED(fid,data));

% Indicates that an BMP280 temperature/pressure sensor is present in the system.
block_read(1001) = struct('def_name', 'BMP280_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_ENABLED(fid,data));

% Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.
block_read(1002) = struct('def_name', 'BME280_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_ENABLED(fid,data));

% Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.
block_read(1003) = struct('def_name', 'BME680_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_ENABLED(fid,data));

% Indicates that an CCS811 VOC/eC02 sensor is present in the system.
block_read(1004) = struct('def_name', 'CCS811_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CCS811_ENABLED(fid,data));

% Indicates that an SGP30 VOC/eC02 sensor is present in the system.
block_read(1005) = struct('def_name', 'SGP30_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_ENABLED(fid,data));

% Indicates that an VL53L0X time-of-flight distance sensor is present in the system.
block_read(1006) = struct('def_name', 'VL53L0X_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_ENABLED(fid,data));

% Indicates that an ALS-PT19 ambient light sensor is present in the system.
block_read(1007) = struct('def_name', 'ALSPT19_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ALSPT19_ENABLED(fid,data));

% Indicates that an MLX90640 thermopile array sensor is present in the system.
block_read(1008) = struct('def_name', 'MLX90640_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_ENABLED(fid,data));

% Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.
block_read(1009) = struct('def_name', 'ZMOD4410_ENABLED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ENABLED(fid,data));


% A point in a tracked ambulation path, with absolute x- and y-coordinates in millimeters, with facing direction theta, in degrees.
block_read(1024) = struct('def_name', 'AMBULATION_XY_THETA', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMBULATION_XY_THETA(fid,data));


% The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
block_read(1100) = struct('def_name', 'AMG8833_THERM_CONV', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_CONV(fid,data));

% The current AMG8833 thermistor reading as a converted float32 value, in Celsius.
block_read(1101) = struct('def_name', 'AMG8833_THERM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_FL(fid,data));

% The current AMG8833 thermistor reading as a raw, signed 16-bit integer.
block_read(1102) = struct('def_name', 'AMG8833_THERM_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_THERM_INT(fid,data));


% The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.
block_read(1110) = struct('def_name', 'AMG8833_PIXELS_CONV', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_CONV(fid,data));

% The current AMG8833 pixel readings as converted float32 values, in Celsius.
block_read(1111) = struct('def_name', 'AMG8833_PIXELS_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_FL(fid,data));

% The current AMG8833 pixel readings as a raw, signed 16-bit integers.
block_read(1112) = struct('def_name', 'AMG8833_PIXELS_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_AMG8833_PIXELS_INT(fid,data));

% The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.
block_read(1113) = struct('def_name', 'HTPA32X32_PIXELS_FP62', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_FP62(fid,data));

% The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).
block_read(1114) = struct('def_name', 'HTPA32X32_PIXELS_INT_K', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT_K(fid,data));

% The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.
block_read(1115) = struct('def_name', 'HTPA32X32_AMBIENT_TEMP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data));

% The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).
block_read(1116) = struct('def_name', 'HTPA32X32_PIXELS_INT12_C', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT12_C(fid,data));

% The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.
block_read(1117) = struct('def_name', 'HTPA32X32_HOTTEST_PIXEL_FP62', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HTPA32X32_HOTTEST_PIXEL_FP62(fid,data));


% The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor
block_read(1120) = struct('def_name', 'BH1749_RGB', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BH1749_RGB(fid,data));

% A special block acting as a sanity check, only used in cases of debugging
block_read(1121) = struct('def_name', 'DEBUG_SANITY_CHECK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_DEBUG_SANITY_CHECK(fid,data));


% The current BME280 temperature reading as a converted float32 value, in Celsius.
block_read(1200) = struct('def_name', 'BME280_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_TEMP_FL(fid,data));

% The current BMP280 temperature reading as a converted float32 value, in Celsius.
block_read(1201) = struct('def_name', 'BMP280_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_TEMP_FL(fid,data));

% The current BME680 temperature reading as a converted float32 value, in Celsius.
block_read(1202) = struct('def_name', 'BME680_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_TEMP_FL(fid,data));


% The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1210) = struct('def_name', 'BME280_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_PRES_FL(fid,data));

% The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1211) = struct('def_name', 'BMP280_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BMP280_PRES_FL(fid,data));

% The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).
block_read(1212) = struct('def_name', 'BME680_PRES_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_PRES_FL(fid,data));


% The current BM280 humidity reading as a converted float32 value, in percent (%).
block_read(1220) = struct('def_name', 'BME280_HUM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME280_HUM_FL(fid,data));

% The current BME680 humidity reading as a converted float32 value, in percent (%).
block_read(1221) = struct('def_name', 'BME680_HUM_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_HUM_FL(fid,data));


% The current BME680 gas resistance reading as a converted float32 value, in units of kOhms
block_read(1230) = struct('def_name', 'BME680_GAS_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_BME680_GAS_FL(fid,data));


% The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).
block_read(1300) = struct('def_name', 'VL53L0X_DIST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_DIST(fid,data));

% Indicates the VL53L0X sensor experienced a range failure.
block_read(1301) = struct('def_name', 'VL53L0X_FAIL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data));


% The serial number of the SGP30.
block_read(1400) = struct('def_name', 'SGP30_SN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_SN(fid,data));


% The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).
block_read(1410) = struct('def_name', 'SGP30_EC02', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data));


% The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).
block_read(1420) = struct('def_name', 'SGP30_TVOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data));


% The MLX90640 unique device ID saved in the device's EEPROM.
block_read(1500) = struct('def_name', 'MLX90640_DEVICE_ID', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_DEVICE_ID(fid,data));

% Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.
block_read(1501) = struct('def_name', 'MLX90640_EEPROM_DUMP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_EEPROM_DUMP(fid,data));

% ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).
block_read(1502) = struct('def_name', 'MLX90640_ADC_RES', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_ADC_RES(fid,data));

% Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).
block_read(1503) = struct('def_name', 'MLX90640_REFRESH_RATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_REFRESH_RATE(fid,data));

% Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).
block_read(1504) = struct('def_name', 'MLX90640_I2C_CLOCKRATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_I2C_CLOCKRATE(fid,data));


% The current MLX90640 pixel readings as converted float32 values, in Celsius.
block_read(1510) = struct('def_name', 'MLX90640_PIXELS_TO', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data));

% The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.
block_read(1511) = struct('def_name', 'MLX90640_PIXELS_IM', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_IM(fid,data));

% The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.
block_read(1512) = struct('def_name', 'MLX90640_PIXELS_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_INT(fid,data));


% The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.
block_read(1520) = struct('def_name', 'MLX90640_I2C_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_I2C_TIME(fid,data));

% The calculation time for the uncalibrated or calibrated image captured by the MLX90640.
block_read(1521) = struct('def_name', 'MLX90640_CALC_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_CALC_TIME(fid,data));

% The SD card write time for the MLX90640 float32 image data.
block_read(1522) = struct('def_name', 'MLX90640_IM_WRITE_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_IM_WRITE_TIME(fid,data));

% The SD card write time for the MLX90640 raw uint16 data.
block_read(1523) = struct('def_name', 'MLX90640_INT_WRITE_TIME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MLX90640_INT_WRITE_TIME(fid,data));


% The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.
block_read(1600) = struct('def_name', 'ALSPT19_LIGHT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ALSPT19_LIGHT(fid,data));


% The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.
block_read(1700) = struct('def_name', 'ZMOD4410_MOX_BOUND', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_MOX_BOUND(fid,data));

% Current configuration values for the ZMOD4410.
block_read(1701) = struct('def_name', 'ZMOD4410_CONFIG_PARAMS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_CONFIG_PARAMS(fid,data));

% Timestamped ZMOD4410 error event.
block_read(1702) = struct('def_name', 'ZMOD4410_ERROR', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ERROR(fid,data));

% Timestamped ZMOD4410 reading calibrated and converted to float32.
block_read(1703) = struct('def_name', 'ZMOD4410_READING_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_READING_FL(fid,data));

% Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.
block_read(1704) = struct('def_name', 'ZMOD4410_READING_INT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_READING_INT(fid,data));


% Timestamped ZMOD4410 eCO2 reading.
block_read(1710) = struct('def_name', 'ZMOD4410_ECO2', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_ECO2(fid,data));

% Timestamped ZMOD4410 indoor air quality reading.
block_read(1711) = struct('def_name', 'ZMOD4410_IAQ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_IAQ(fid,data));

% Timestamped ZMOD4410 total volatile organic compound reading.
block_read(1712) = struct('def_name', 'ZMOD4410_TVOC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_TVOC(fid,data));

% Timestamped ZMOD4410 total volatile organic compound reading.
block_read(1713) = struct('def_name', 'ZMOD4410_R_CDA', 'fcn', @(data)OmniTrakFileRead_ReadBlock_ZMOD4410_R_CDA(fid,data));


% Current accelerometer reading settings on any enabled LSM303.
block_read(1800) = struct('def_name', 'LSM303_ACC_SETTINGS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_ACC_SETTINGS(fid,data));

% Current magnetometer reading settings on any enabled LSM303.
block_read(1801) = struct('def_name', 'LSM303_MAG_SETTINGS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_MAG_SETTINGS(fid,data));

% Current readings from the LSM303 accelerometer, as float values in m/s^2.
block_read(1802) = struct('def_name', 'LSM303_ACC_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data));

% Current readings from the LSM303 magnetometer, as float values in uT.
block_read(1803) = struct('def_name', 'LSM303_MAG_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data));

% Current readings from the LSM303 temperature sensor, as float value in degrees Celcius
block_read(1804) = struct('def_name', 'LSM303_TEMP_FL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data));


% Spectrometer wavelengths, in nanometers.
block_read(1900) = struct('def_name', 'SPECTRO_WAVELEN', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SPECTRO_WAVELEN(fid,data));

% Spectrometer measurement trace.
block_read(1901) = struct('def_name', 'SPECTRO_TRACE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SPECTRO_TRACE(fid,data));


% Timestamped event for feeding/pellet dispensing.
block_read(2000) = struct('def_name', 'PELLET_DISPENSE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PELLET_DISPENSE(fid,data));

% Timestamped event for feeding/pellet dispensing in which no pellet was detected.
block_read(2001) = struct('def_name', 'PELLET_FAILURE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_PELLET_FAILURE(fid,data));


% Timestamped event marker for the start of a session pause, with no events recorded during the pause.
block_read(2010) = struct('def_name', 'HARD_PAUSE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data));

% Timestamped event marker for the stop of a session pause, with no events recorded during the pause.
block_read(2011) = struct('def_name', 'HARD_PAUSE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HARD_PAUSE_STOP(fid,data));

% Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.
block_read(2012) = struct('def_name', 'SOFT_PAUSE_START', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data));

% Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.
block_read(2013) = struct('def_name', 'SOFT_PAUSE_STOP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SOFT_PAUSE_STOP(fid,data));

% Timestamped event marker for the start of a trial, with accompanying microsecond clock reading
block_read(2014) = struct('def_name', 'TRIAL_START_SERIAL_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data));


% Starting position of an autopositioner in just the x-direction, with distance in millimeters.
block_read(2020) = struct('def_name', 'POSITION_START_X', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data));

% Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.
block_read(2021) = struct('def_name', 'POSITION_MOVE_X', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_X(fid,data));

% Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.
block_read(2022) = struct('def_name', 'POSITION_START_XY', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_XY(fid,data));

% Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.
block_read(2023) = struct('def_name', 'POSITION_MOVE_XY', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_XY(fid,data));

% Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
block_read(2024) = struct('def_name', 'POSITION_START_XYZ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_START_XYZ(fid,data));

% Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.
block_read(2025) = struct('def_name', 'POSITION_MOVE_XYZ', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POSITION_MOVE_XYZ(fid,data));


% Timestamped event for a TTL pulse output, with channel number, voltage, and duration.
block_read(2048) = struct('def_name', 'TTL_PULSE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_TTL_PULSE(fid,data));


% Stream input name for the specified input index.
block_read(2100) = struct('def_name', 'STREAM_INPUT_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STREAM_INPUT_NAME(fid,data));


% Starting calibration baseline coefficient, for the specified module index.
block_read(2200) = struct('def_name', 'CALIBRATION_BASELINE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE(fid,data));

% Starting calibration slope coefficient, for the specified module index.
block_read(2201) = struct('def_name', 'CALIBRATION_SLOPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE(fid,data));

% Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.
block_read(2202) = struct('def_name', 'CALIBRATION_BASELINE_ADJUST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_BASELINE_ADJUST(fid,data));

% Timestamped in-session calibration slope coefficient adjustment, for the specified module index.
block_read(2203) = struct('def_name', 'CALIBRATION_SLOPE_ADJUST', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_SLOPE_ADJUST(fid,data));

% Most recent calibration date/time, for the specified module index.
block_read(2204) = struct('def_name', 'CALIBRATION_DATE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CALIBRATION_DATE(fid,data));


% Type of hit threshold (i.e. peak force), for the specified input.
block_read(2300) = struct('def_name', 'HIT_THRESH_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HIT_THRESH_TYPE(fid,data));


% A name/description of secondary thresholds used in the behavior.
block_read(2310) = struct('def_name', 'SECONDARY_THRESH_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SECONDARY_THRESH_NAME(fid,data));


% Type of initation threshold (i.e. force or touch), for the specified input.
block_read(2320) = struct('def_name', 'INIT_THRESH_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_INIT_THRESH_TYPE(fid,data));


% A timestamped manual feed event, triggered remotely.
block_read(2400) = struct('def_name', 'REMOTE_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_REMOTE_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered from the hardware user interface.
block_read(2401) = struct('def_name', 'HWUI_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_HWUI_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered randomly by the firmware.
block_read(2402) = struct('def_name', 'FW_RANDOM_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FW_RANDOM_FEED(fid,data));

% A timestamped manual feed event, triggered from a computer software user interface.
block_read(2403) = struct('def_name', 'SWUI_MANUAL_FEED_DEPRECATED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data));

% A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.
block_read(2404) = struct('def_name', 'FW_OPERANT_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data));

% A timestamped manual feed event, triggered from a computer software user interface.
block_read(2405) = struct('def_name', 'SWUI_MANUAL_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data));

% A timestamped manual feed event, triggered randomly by computer software.
block_read(2406) = struct('def_name', 'SW_RANDOM_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SW_RANDOM_FEED(fid,data));

% A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.
block_read(2407) = struct('def_name', 'SW_OPERANT_FEED', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data));


% MotoTrak version 3.0 trial outcome data.
block_read(2500) = struct('def_name', 'MOTOTRAK_V3P0_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_OUTCOME(fid,data));

% MotoTrak version 3.0 trial stream signal.
block_read(2501) = struct('def_name', 'MOTOTRAK_V3P0_SIGNAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data));


% Nosepoke status bitmask, typically written only when it changes.
block_read(2560) = struct('def_name', 'POKE_BITMASK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data));


% Capacitive sensor status bitmask, typically written only when it changes.
block_read(2576) = struct('def_name', 'CAPSENSE_BITMASK', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CAPSENSE_BITMASK(fid,data));

% Capacitive sensor reading for one sensor, in ADC ticks or clock cycles.
block_read(2577) = struct('def_name', 'CAPSENSE_VALUE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_CAPSENSE_VALUE(fid,data));


% Name/description of the output trigger type for the given index.
block_read(2600) = struct('def_name', 'OUTPUT_TRIGGER_NAME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_OUTPUT_TRIGGER_NAME(fid,data));


% Vibration task trial outcome data.
block_read(2700) = struct('def_name', 'VIBRATION_TASK_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VIBRATION_TASK_TRIAL_OUTCOME(fid,data));

% Vibrotactile detection task trial data.
block_read(2701) = struct('def_name', 'VIBROTACTILE_DETECTION_TASK_TRIAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data));


% LED detection task trial outcome data.
block_read(2710) = struct('def_name', 'LED_DETECTION_TASK_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data));

% Light source model name.
block_read(2711) = struct('def_name', 'LIGHT_SRC_MODEL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LIGHT_SRC_MODEL(fid,data));

% Light source type (i.e. LED, LASER, etc).
block_read(2712) = struct('def_name', 'LIGHT_SRC_TYPE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_LIGHT_SRC_TYPE(fid,data));


% SensiTrak tactile discrimination task trial outcome data.
block_read(2720) = struct('def_name', 'STTC_2AFC_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STTC_2AFC_TRIAL_OUTCOME(fid,data));

% Number of pads on the SensiTrak Tactile Carousel module.
block_read(2721) = struct('def_name', 'STTC_NUM_PADS', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STTC_NUM_PADS(fid,data));

% Microstep setting on the specified OTMP module.
block_read(2722) = struct('def_name', 'MODULE_MICROSTEP', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_MICROSTEP(fid,data));

% Steps per rotation on the specified OTMP module.
block_read(2723) = struct('def_name', 'MODULE_STEPS_PER_ROT', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_STEPS_PER_ROT(fid,data));


% Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
block_read(2730) = struct('def_name', 'MODULE_PITCH_CIRC', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data));

% Center offset, in millimeters, for the specified OTMP module.
block_read(2731) = struct('def_name', 'MODULE_CENTER_OFFSET', 'fcn', @(data)OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data));


% SensiTrak proprioception discrimination task trial outcome data.
block_read(2740) = struct('def_name', 'STAP_2AFC_TRIAL_OUTCOME', 'fcn', @(data)OmniTrakFileRead_ReadBlock_STAP_2AFC_TRIAL_OUTCOME(fid,data));


% Fixed reinforcement task trial data.
block_read(2800) = struct('def_name', 'FR_TASK_TRIAL', 'fcn', @(data)OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL(fid,data));


% An oscilloscope recording, in units of volts, from one or multiple channels, with time units, in seconds, along with a variable number of parameters describing the recording conditions.
block_read(3072) = struct('def_name', 'SCOPE_TRACE', 'fcn', @(data)OmniTrakFileRead_ReadBlock_SCOPE_TRACE(fid,data));


function data = OmniTrakFileRead_ReadBlock_ESP8266_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		122
%		ESP8266_CHIP_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.chip_id = fread(fid,1,'uint32');                                %Save the device's unique chip ID.


function data = OmniTrakFileRead_ReadBlock_ESP8266_FLASH_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		123
%		ESP8266_FLASH_ID

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
data.device.flash_id = fread(fid,1,'uint32');                               %Save the device's unique flash chip ID.


function data = OmniTrakFileRead_ReadBlock_ESP8266_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	121
%		DEFINITION:		ESP8266_IP4_ADDR
%		DESCRIPTION:	The local IPv4 address of the device's ESP8266 module.

fprintf(1,'Need to finish coding for Block 121: ESP8266_IP4_ADDR\n');


function data = OmniTrakFileRead_ReadBlock_ESP8266_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	120
%		DEFINITION:		ESP8266_MAC_ADDR
%		DESCRIPTION:	The MAC address of the device's ESP8266 module.

fprintf(1,'Need to finish coding for Block 120: ESP8266_MAC_ADDR\n');


function data = OmniTrakFileRead_ReadBlock_EXP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		300
%		EXP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.experiment.name = fread(fid,N,'*char')';                               %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_MAX_RPM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		190
%		FEED_SERVO_MAX_RPM

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).max_rpm = fread(fid,1,'float32');                     %Read in the maximum measure speed, in RPM.


function data = OmniTrakFileRead_ReadBlock_FEED_SERVO_SPEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		191
%		FEED_SERVO_SPEED

data = OmniTrakFileRead_Check_Field_Name(data,'device','feeder');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
data.device.feeder(i).servo_speed = fread(fid,1,'uint8');                   %Read in the current speed setting (0-180).


function data = OmniTrakFileRead_ReadBlock_FILE_VERSION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1
%		FILE_VERSION

fprintf(1,'Need to finish coding for Block 1: FILE_VERSION');


function data = OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL(fid,data)

%
% OmniTrakFileRead_ReadBlock_FR_TASK_TRIAL.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_FR_TASK_TRIAL reads in the "FR_TASK_TRIAL" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain the parameters and outcomes for one Fixed Reinforcment behavior
%   trial.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0AF0
%		DEFINITION:		FR_TASK_TRIAL
%		DESCRIPTION:	Fixed reinforcement task trial data.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint16');                                                %Read in the FR_TASK_TRIAL data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        t = fread(fid,1,'uint16');                                          %Read in the trial index.
        data.trial(t).datenum = fread(fid,1,'float64');                     %Read in the serial date number timestamp.
        data.trial(t).outcome = fread(fid,1,'*char');                       %Read in the outcome code.
        data.trial(t).target_poke = fread(fid,1,'uint8');                   %Read in the target nosepoke index.
        data.trial(t).thresh = fread(fid,1,'uint8');                        %Read in the required number of pokes.
        data.trial(t).poke_count = fread(fid,1,'uint16');                   %Read in the number of completed pokes.
        data.trial(t).hit_time = fread(fid,1,'float32');                    %Read in the hit (first reward) time (0 for no reward).
        data.trial(t).reward_dur = fread(fid,1,'float32');                  %Read in the reward window duration (lick availability), in seconds.
        data.trial(t).num_licks = fread(fid,1,'uint16');                    %Read in the number of licks.
        data.trial(t).num_feedings = fread(fid,1,'uint16');                 %Read in the number of feedings/dispensings.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_FW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2404
%		FW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_firmware';                            %Save the feed trigger source.  


function data = OmniTrakFileRead_ReadBlock_FW_RANDOM_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2402
%		FW_RANDOM_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'random_firmware';                             %Save the feed trigger source.     


function data = OmniTrakFileRead_ReadBlock_GROUP_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		201
%		GROUP_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.group = fread(fid,N,'*char')';                                         %Read in the characters of the group name.


function data = OmniTrakFileRead_ReadBlock_HARD_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2010
%		HARD_PAUSE_START

fprintf(1,'Need to finish coding for Block 2010: HARD_PAUSE_START');


function data =  OmniTrakFileRead_ReadBlock_HARD_PAUSE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x07DB
%		DEFINITION:		HARD_PAUSE_STOP
%		DESCRIPTION:	Timestamped event marker for the stop of a session pause, with no events recorded during the pause.

error('Need to finish coding for OFBC block 0x07DB ("HARD_PAUSE_STOP")!');


function data = OmniTrakFileRead_ReadBlock_HIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2300
%		HIT_THRESH_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'hit_thresh_type');           %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the signal index.
if isempty(data.hit_thresh_type)                                            %If there's no hit threshold type yet set...
    data.hit_thresh_type = cell(i,1);                                       %Create a cell array to hold the threshold types.
end
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.hit_thresh_type{i} = fread(fid,N,'*char')';                            %Read in the characters of the user's experiment name.


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_AMBIENT_TEMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1115
%		DEFINITION:		HTPA32X32_AMBIENT_TEMP
%		DESCRIPTION:	The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'HTPA32x32';                                             %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_HOTTEST_PIXEL_FP62(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1117
%		DEFINITION:		HTPA32X32_HOTTEST_PIXEL_FP62
%		DESCRIPTION:	The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

fprintf(1,'Need to finish coding for Block 1117: HTPA32X32_HOTTEST_PIXEL_FP62\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_FP62(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1113
%		DEFINITION:		HTPA32X32_PIXELS_FP62
%		DESCRIPTION:	The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.

fprintf(1,'Need to finish coding for Block 1113: HTPA32X32_PIXELS_FP62\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT12_C(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1116
%		DEFINITION:		HTPA32X32_PIXELS_INT12_C
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC).

fprintf(1,'Need to finish coding for Block 1116: HTPA32X32_PIXELS_INT12_C\n');


function data = OmniTrakFileRead_ReadBlock_HTPA32X32_PIXELS_INT_K(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1114
%		DEFINITION:		HTPA32X32_PIXELS_INT_K
%		DESCRIPTION:	The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).


data = OmniTrakFileRead_Check_Field_Name(data,'htpa','id');                 %Call the subfunction to check for existing fieldnames.
id = fread(fid,1,'uint8');                                                  %Read in the HTPA sensor index (there may be multiple sensors).
if isempty(data.htpa(1).id)                                                 %If this is the first reading for any HTPA sensor.
    sensor_i = 1;                                                           %Set the sensor index to 1.
    data.htpa(sensor_i).id = id;                                            %Save the sensor index.
else                                                                        %Otherwise...
    existing_ids = vertcat(data.htpa.id);                                   %Grab all of the existing HTAP sensor IDs.
    sensor_i = find(id == existing_ids);                                    %Find the index for the current sensor.
end
data.htpa = OmniTrakFileRead_Check_Field_Name(data.htpa,'pixels');          %Call the subfunction to check for existing fieldnames.
reading_i = length(data.htpa(sensor_i).pixels) + 1;                         %Increment the sensor index.
data.htpa(sensor_i).pixels(reading_i).timestamp = fread(fid,1,'uint32');    %Save the microcontroller millisecond clock timestamp for the reading.
% temp = fread(fid,1024,'uint8');                                             %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
temp = fread(fid,1024,'uint16');                                            %Read in the pixel values as 16-bit unsigned integers of deciKelvin.
data.htpa(sensor_i).pixels(reading_i).decikelvin = reshape(temp,32,32)';    %Reshape the values into a 32x32 matrix.


function data = OmniTrakFileRead_ReadBlock_HWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2401
%		HWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_hardware'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_hardware';                           %Save the feed trigger source.
end


function data = OmniTrakFileRead_ReadBlock_INCOMPLETE_BLOCK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		50
%		INCOMPLETE_BLOCK

fprintf(1,'Need to finish coding for Block 50: INCOMPLETE_BLOCK');


function data = OmniTrakFileRead_ReadBlock_INIT_THRESH_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2320
%		INIT_THRESH_TYPE

fprintf(1,'Need to finish coding for Block 2320: INIT_THRESH_TYPE');


function data = OmniTrakFileRead_ReadBlock_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2710
%		LED_DETECTION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Read in the trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Read in the trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the trial outcome.
N = fread(fid,1,'uint8');                                                   %Read in the number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Read in the feeding times.
data.trial(t).hit_win = fread(fid,1,'float32');                             %Read in the hit window.
data.trial(t).ls_index = fread(fid,1,'uint8');                              %Read in the light source index (1-8).
data.trial(t).ls_pwm = fread(fid,1,'uint8');                                %Read in the light source intensity (PWM).                
data.trial(t).ls_dur = fread(fid,1,'float32');                              %Read in the light stimulus duration.
data.trial(t).hold_time = fread(fid,1,'float32');                           %Read in the hold time.
data.trial(t).time_held = fread(fid,1,'float32');                           %Read in the time held.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
num_signals = 1;                                                            %%<<REMOVE AFTER DEBUGGING.
N = fread(fid,1,'uint32');                                                  %Read in the number of samples.                
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
data.trial(t).signal(:,1) = fread(fid,N,'uint16');                          %Read in the nosepoke signal.
for i = 2:num_signals                                                       %Step through the non-nosepoke signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each non-nosepoke signal.
end


function data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_MODEL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2711
%		LIGHT_SRC_MODEL

data = OmniTrakFileRead_Check_Field_Name(data,'light_src','chan');          %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
ls_i = fread(fid,1,'uint16');                                               %Read in the light source channel index.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the light source model.
data.light_src(module_i).chan(ls_i).model = fread(fid,N,'*char')';          %Read in the characters of the light source model.


function data = OmniTrakFileRead_ReadBlock_LIGHT_SRC_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2712
%		LIGHT_SRC_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'light_src','chan');          %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
ls_i = fread(fid,1,'uint16');                                               %Read in the light source channel index.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters in the light source type.
data.light_src(module_i).chan(ls_i).type = fread(fid,N,'*char')';           %Read in the characters of the light source type.


function data = OmniTrakFileRead_ReadBlock_LSM303_ACC_FL(fid,data)

%   Block Code: 1802
%   Block Definition: LSM303_ACC_FL
%   Description: "Current readings from the LSM303D accelerometer, as float values in m/s^2."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z acceleration readings, in m/s^2.


data = OmniTrakFileRead_Check_Field_Name(data,'accel');                     %Call the subfunction to check for existing fieldnames.
i = length(data.accel) + 1;                                                 %Grab a new accelerometer reading index.
data.accel(i).src = 'LSM303';                                               %Save the source of the accelerometer reading.
data.accel(i).id = fread(fid,1,'uint8');                                    %Read in the accelerometer sensor index (there may be multiple sensors).
data.accel(i).time = fread(fid,1,'uint32');                                 %Save the millisecond clock timestamp for the reading.
data.accel(i).xyz = fread(fid,3,'float32');                                 %Save the accelerometer x-y-z readings as float-32 values.


function data = OmniTrakFileRead_ReadBlock_LSM303_ACC_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1800
%		LSM303_ACC_SETTINGS

fprintf(1,'Need to finish coding for Block 1800: LSM303_ACC_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_LSM303_MAG_FL(fid,data)

%   Block Code: 1803
%   Block Definition: LSM303_MAG_FL
%   Description: "Current readings from the LSM303D magnetometer, as float values in uT."
%   Status:
%   Block Format:
%     * 1x (uint8): LSM303D I2C address or ID.
%     * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
%     * 3x (float32): x, y, & z magnetometer readings, in uT.


data = OmniTrakFileRead_Check_Field_Name(data,'mag');                       %Call the subfunction to check for existing fieldnames.
i = length(data.mag) + 1;                                                   %Grab a new magnetometer reading index.
data.mag(i).src = 'LSM303';                                                 %Save the source of the magnetometer reading.
data.mag(i).id = fread(fid,1,'uint8');                                      %Read in the magnetometer sensor index (there may be multiple sensors).
data.mag(i).time = fread(fid,1,'uint32');                                   %Save the millisecond clock timestamp for the reading.
data.mag(i).xyz = fread(fid,3,'float32');                                   %Save the magnetometer x-y-z readings as float-32 values.


function data = OmniTrakFileRead_ReadBlock_LSM303_MAG_SETTINGS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1801
%		LSM303_MAG_SETTINGS

fprintf(1,'Need to finish coding for Block 1801: LSM303_MAG_SETTINGS');


function data = OmniTrakFileRead_ReadBlock_LSM303_TEMP_FL(fid,data)

%   Block Code: 1804
%   Block Definition: LSM303_TEMP_FL
%   Description: ."Current readings from the LSM303 temperature sensor, as float value in degrees Celsius."
%   Status:
%   Block Format:
%     * 1x (uint8) LSM303 I2C address or ID. 
%     * 1x (uint32) millisecond timestamp. 
%     * 1x (float32) temperature reading, in Celsius.


data = OmniTrakFileRead_Check_Field_Name(data,'temp');                      %Call the subfunction to check for existing fieldnames.
i = length(data.temp) + 1;                                                  %Grab a new temperature reading index.
data.temp(i).src = 'LSM303';                                                %Save the source of the temperature reading.
data.temp(i).id = fread(fid,1,'uint8');                                     %Read in the HTPA sensor index (there may be multiple sensors).
data.temp(i).timestamp = fread(fid,1,'uint32');                             %Save the microcontroller millisecond clock timestamp for the reading.
data.temp(i).celsius = fread(fid,1,'float32');                              %Save the temperature reading as a float32 value.


function data = OmniTrakFileRead_ReadBlock_MLX90640_ADC_RES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1502
%		MLX90640_ADC_RES

fprintf(1,'Need to finish coding for Block 1502: MLX90640_ADC_RES');


function data = OmniTrakFileRead_ReadBlock_MLX90640_CALC_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1521
%		MLX90640_CALC_TIME

fprintf(1,'Need to finish coding for Block 1521: MLX90640_CALC_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_DEVICE_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1500
%		MLX90640_DEVICE_ID

fprintf(1,'Need to finish coding for Block 1500: MLX90640_DEVICE_ID');


function data = OmniTrakFileRead_ReadBlock_MLX90640_EEPROM_DUMP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1501
%		MLX90640_EEPROM_DUMP

fprintf(1,'Need to finish coding for Block 1501: MLX90640_EEPROM_DUMP');


function data = OmniTrakFileRead_ReadBlock_MLX90640_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1008
%		MLX90640_ENABLED

fprintf(1,'Need to finish coding for Block 1008: MLX90640_ENABLED');


function data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_CLOCKRATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1504
%		MLX90640_I2C_CLOCKRATE

fprintf(1,'Need to finish coding for Block 1504: MLX90640_I2C_CLOCKRATE');


function data = OmniTrakFileRead_ReadBlock_MLX90640_I2C_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1520
%		MLX90640_I2C_TIME

fprintf(1,'Need to finish coding for Block 1520: MLX90640_I2C_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_IM_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1522
%		MLX90640_IM_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1522: MLX90640_IM_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_INT_WRITE_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1523
%		MLX90640_INT_WRITE_TIME

fprintf(1,'Need to finish coding for Block 1523: MLX90640_INT_WRITE_TIME');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_IM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1511
%		MLX90640_PIXELS_IM

fprintf(1,'Need to finish coding for Block 1511: MLX90640_PIXELS_IM');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1512
%		MLX90640_PIXELS_INT

fprintf(1,'Need to finish coding for Block 1512: MLX90640_PIXELS_INT');


function data = OmniTrakFileRead_ReadBlock_MLX90640_PIXELS_TO(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1510
%		MLX90640_PIXELS_TO

id = fread(fid,1,'uint8');                                                  %Read in the AMG8833 sensor index (there may be multiple sensors).
if ~isfield(data,'mlx')                                                     %If the structure doesn't yet have an "amg" field..
    data.mlx = [];                                                          %Create the field.
    data.mlx(1).id = id;                                                    %Save the file-specified index for this AMG8833.
end
temp = vertcat(data.mlx(:).id);                                             %Grab all of the existing AMG8833 indices.
i = find(temp == id);                                                       %Find the field index for the current AMG8833.
if ~isfield(data.mlx,'pixels')                                              %If the "amg" field doesn't yet have an "pixels" field..
    data.mlx.pixels = [];                                                   %Create the "pixels" field. 
end            
j = length(data.mlx(i).pixels) + 1;                                         %Grab a new reading index.   
data.mlx(i).pixels(j).timestamp = fread(fid,1,'uint32');                    %Save the millisecond clock timestamp for the reading.
data.mlx(i).pixels(j).float = nan(24,32);                                   %Create an 8x8 matrix to hold the pixel values.
for k = 1:24                                                                %Step through the rows of pixels.
    data.mlx(i).pixels(j).float(k,:) = fliplr(fread(fid,32,'float32'));     %Read in each row of pixel values.
end


function data = OmniTrakFileRead_ReadBlock_MLX90640_REFRESH_RATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1503
%		MLX90640_REFRESH_RATE

fprintf(1,'Need to finish coding for Block 1503: MLX90640_REFRESH_RATE');


function data = OmniTrakFileRead_ReadBlock_MODULE_CENTER_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2731
%		DEFINITION:		MODULE_CENTER_OFFSET
%		DESCRIPTION:	Center offset, in millimeters, for the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_CENTER_OFFSET,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_center_offset())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','center_offset');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).center_offset = fread(fid,1,'single');                %Read in the handle's center offset, in millimeters.


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	145
%		DEFINITION:		MODULE_FW_DATE
%		DESCRIPTION:	OTMP Module firmware upload date, copied from the macro, written as characters.

fprintf(1,'Need to finish coding for Block 145: MODULE_FW_DATE\n');


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OmniTrakFileRead_ReadBlock_MODULE_FW_FILENAME reads in the 
%   "MODULE_FW_FILENAME" data block from an *.OmniTrak format file. This 
%   block is intended to contain the firmware filename, written as 
%   characters, of a connected module, as well as the module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0090
%		DEFINITION:		MODULE_FW_FILENAME
%		DESCRIPTION:	OTMP Module firmware filename, copied from the 
%                       macro, written as characters.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',...
    {'port','firmware'});                                                   %Call the subfunction to check for existing fieldnames.         

port_i = fread(fid,1,'uint8');                                              %Read in the port index.
existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first device...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded device.
    if ~any(i)                                                              %If the port index doesn't match any existing devices...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device(i).firmware(1).filename = fread(fid,N,'*char')';                %Add the device firmware filename.
data.device(i).port = port_i;                                               %Add the port index.


function data = OmniTrakFileRead_ReadBlock_MODULE_FW_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	146
%		DEFINITION:		MODULE_FW_TIME
%		DESCRIPTION:	OTMP Module firmware upload time, copied from the macro, written as characters.

fprintf(1,'Need to finish coding for Block 146: MODULE_FW_TIME\n');


function data = OmniTrakFileRead_ReadBlock_MODULE_MICROSTEP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2722
%		DEFINITION:		MODULE_MICROSTEP
%		DESCRIPTION:	Microstep setting on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_MICROSTEP,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_microstep(),'uint8');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','microstep');        %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).microstep = fread(fid,1,'uint8');                     %Read in the microstop setting.


function data =  OmniTrakFileRead_ReadBlock_MODULE_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_MODULE_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_MODULE_NAME reads in the "MODULE_NAME" data
%   block from an *.OmniTrak format file. This block is intended to contain
%   the name of a connected module, as well as the module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0093
%		DEFINITION:		MODULE_NAME
%		DESCRIPTION:	OTMP module name, written as characters.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%   2025-07-02 - Drew Sloan - Changed filed name from "module" to "device".
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',{'port','name'});    %Call the subfunction to check for existing fieldnames.         

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

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device(i).name = fread(fid,N,'*char')';                                %Add the module name.
data.device(i).port = port_i;                                               %Add the port index.


function data = OmniTrakFileRead_ReadBlock_MODULE_PITCH_CIRC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2730
%		DEFINITION:		MODULE_PITCH_CIRC
%		DESCRIPTION:	Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_PITCH_CIRC,'uint16');
% fwrite(fid,1,'uint8');
% val = double(handles.ctrl.stap_get_pitch_circumference())/1000;
% fwrite(fid,val,'single');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module',...
    'pitch_circumference');                                                 %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).pitch_circumference = fread(fid,1,'single');          %Read in the pitch circumference of the gear, in millimeters.


function data =  OmniTrakFileRead_ReadBlock_MODULE_SKU(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0094
%		DEFINITION:		MODULE_SKU
%		DESCRIPTION:	OTMP Module SKU, typically written as 4 characters.

error('Need to finish coding for OFBC block 0x0094 ("MODULE_SKU")!');


function data =  OmniTrakFileRead_ReadBlock_MODULE_SN(fid,data)

%
% OmniTrakFileRead_ReadBlock_MODULE_SN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_MODULE_SN reads in the "MODULE_SN" data
%   block from an *.OmniTrak format file. This block is intended to contain
%   the serial number, written as characters, of a connected module, as 
%   well as the module's port index.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0099
%		DEFINITION:		MODULE_SN
%		DESCRIPTION:	OTMP Module serial number, written as characters.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'device',...
    {'port','serial_num'});                                                 %Call the subfunction to check for existing fieldnames.         

port_i = fread(fid,1,'uint8');                                              %Read in the port index.
existing_ports = vertcat(data.device.port);                                 %Fetch all the port indices already loaded in the structure...
if isempty(existing_ports)                                                  %If this is the first device...
    i = 1;                                                                  %Set the index to 1.
else                                                                        %Otherwise...
    i = (port_i == existing_ports);                                         %Check for a match to an already-loaded device.
    if ~any(i)                                                              %If the port index doesn't match any existing devices...
        i = length(data.device) + 1;                                        %Increment the index.
    end
end

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device(i).serial_num = fread(fid,N,'*char')';                          %Add the device serial number.
data.device(i).port = port_i;                                               %Add the port index.


function data = OmniTrakFileRead_ReadBlock_MODULE_STEPS_PER_ROT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2723
%		DEFINITION:		MODULE_STEPS_PER_ROT
%		DESCRIPTION:	Steps per rotation on the specified OTMP module.
%
% fwrite(fid,ofbc.MODULE_STEPS_PER_ROT,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_steps_per_rot(),'uint16');
%

data = OmniTrakFileRead_Check_Field_Name(data,'module','steps_per_rot');    %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).steps_per_rot = fread(fid,1,'uint16');                %Read in the number of steps per rotation.


function data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2500
%		DEFINITION:		MOTOTRAK_V3P0_OUTCOME
%		DESCRIPTION:	MotoTrak version 3.0 trial outcome data.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp for the trial start.
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the character code for the outcome.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).init_thresh = fread(fid,1,'float32');                         %Read in the initiation threshold.
data.trial(t).hit_thresh = fread(fid,1,'float32');                          %Read in the hit threshold.
N = fread(fid,1,'uint8');                                                   %Read in the number of secondary hit thresholds.
if N > 0                                                                    %If there were any secondary hit thresholds...
    data.trial(t).secondary_hit_thresh = fread(fid,N,'float32')';           %Read in each secondary hit threshold.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of hits.
if N > 0                                                                    %If there were any hits...
    data.trial(t).hit_time = fread(fid,N,'uint32')';                        %Read in each millisecond clock timestamp for each hit.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of output triggers.
if N > 0                                                                    %If there were any output triggers...
    data.trial(t).trig_time = fread(fid,1,'uint32');                        %Read in each millisecond clock timestamp for each output trigger.
end
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
if ~isfield(data.trial,'times')                                             %If the sample times field doesn't yet exist...
    data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                 %Pre-allocate a matrix to hold sample times.
end
if ~isfield(data.trial,'signal')                                            %If the signal matrix field doesn't yet exist...
    data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                %Pre-allocate a matrix to hold signal samples.
end
for i = 1:pre_N                                                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end       


function data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2501
%		MOTOTRAK_V3P0_SIGNAL

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                     %Pre-allocate a matrix to hold sample times, in microseconds.
data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                    %Pre-allocate a matrix to hold signal samples.
for i = (pre_N + 1):(pre_N + hitwin_N + post_N)                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the microsecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end


function data = OmniTrakFileRead_ReadBlock_MS_FILE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2
%		MS_FILE_START

data = OmniTrakFileRead_Check_Field_Name(data,'file','start','millis');     %Call the subfunction to check for existing fieldnames.    

data.file.start.millis = fread(fid,1,'uint32');                             %Save the file start 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_MS_FILE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		3
%		MS_FILE_STOP

data = OmniTrakFileRead_Check_Field_Name(data,'file','stop','millis');      %Call the subfunction to check for existing fieldnames.   

data.file.stop.millis = fread(fid,1,'uint32');                              %Save the file stop 32-bit millisecond clock timestamp.


function data = OmniTrakFileRead_ReadBlock_MS_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		23
%		MS_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 23: MS_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_NTP_SYNC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		20
%		NTP_SYNC

fprintf(1,'Need to finish coding for Block 20: NTP_SYNC');


function data = OmniTrakFileRead_ReadBlock_NTP_SYNC_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		21
%		NTP_SYNC_FAIL

fprintf(1,'Need to finish coding for Block 21: NTP_SYNC_FAIL');


function data = OmniTrakFileRead_ReadBlock_ORIGINAL_FILENAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		40
%		ORIGINAL_FILENAME

fprintf(1,'Need to finish coding for Block 40: ORIGINAL_FILENAME');


function data = OmniTrakFileRead_ReadBlock_OUTPUT_TRIGGER_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2600
%		OUTPUT_TRIGGER_NAME

fprintf(1,'Need to finish coding for Block 2600: OUTPUT_TRIGGER_NAME');


function data = OmniTrakFileRead_ReadBlock_PELLET_DISPENSE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2000
%		PELLET_DISPENSE

fprintf(1,'Need to finish coding for Block 2000: PELLET_DISPENSE');


function data = OmniTrakFileRead_ReadBlock_PELLET_FAILURE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2001
%		PELLET_FAILURE

data = OmniTrakFileRead_Check_Field_Name(data,'pellet','fail');             %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.pellet) < i                                                  %If there's no entry yet for this dispenser...
    data.pellet(i).fail = fread(fid,1,'uint32');                            %Save the millisecond clock timestamp for the pellet dispensing failure.
else                                                                        %Otherwise, if there's an entry for this dispenser.
    j = size(data.pellet(i).fail,1) + 1;                                    %Find the next index for the pellet failure timestamp.
    data.pellet(i).fail(j) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the pellet dispensing failure.
end       


function data = OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data)

%
% OmniTrakFileRead_ReadBlock_POKE_BITMASK.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_POKE_BITMASK reads in the "POKE_BITMASK" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain an 8-bit bitmask with bits indicating the poked/unpoked status
%   of a bank of nosepokes, paired both a computer clock timestamp (serial
%   date number) and a 32-bit microcontroller clock timestamp (typically
%   millis() or micros()).
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0A00
%		DEFINITION:		POKE_BITMASK
%		DESCRIPTION:	Nosepoke status bitmask, typically written only 
%                       when it changes.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%



ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'poke',...
    {'datenum','micros','status'});                                         %Call the subfunction to check for existing fieldnames.         
i = size(data.poke.datenum,1) + 1;                                          %Find the next index for the pellet timestamp for this dispenser.

if i == 1                                                                   %If this is the first bitmask reading...
    data.poke.datenum = fread(fid,1,'float64');                             %Save the serial date number timestamp.
    data.poke.micros = fread(fid,1,'float32');                              %Save the microcontroller microsecond timestamp.
else                                                                        %Otherwise...
    data.poke.datenum(i,1) = fread(fid,1,'float64');                        %Save the serial date number timestamp.
    data.poke.micros(i,1) = fread(fid,1,'float32');                         %Save the microcontroller microsecond timestamp.
end

num_sensors = fread(fid,1,'uint8');                                         %Read in the number of sensors.
capsense_mask = fread(fid,1,'uint8');                                       %Read in the sensor status bitmask.
capsense_status = bitget(capsense_mask,1:num_sensors);                      %Grab the status for each nosepoke.
if i == 1                                                                   %If this is the first nosepoke event...
    data.poke.status = capsense_status;                                     %Create the status matrix.
else                                                                        %Otherwise...
    data.poke.status(i,:) = capsense_status;                                %Add the new status to the matrix.
end


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2021
%		POSITION_MOVE_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','move');                %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
j = size(data.pos(i).move, 1) + 1;                                          %Find a new row index in the positioner movement matrix.
data.pos(i).move(j,:) = nan(1,4);                                           %Add 4 NaNs to a new row in the movement matrix.            
data.pos(i).move(j,1) = fread(fid,1,'uint32');                              %Save the millisecond clock timestamp for the movement.
data.pos(i).move(j,2) = fread(fid,1,'float32');                             %Save the new positioner x-value as a float32 value.     


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2023
%		POSITION_MOVE_XY

fprintf(1,'Need to finish coding for Block 2023: POSITION_MOVE_XY');


function data = OmniTrakFileRead_ReadBlock_POSITION_MOVE_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2025
%		POSITION_MOVE_XYZ

fprintf(1,'Need to finish coding for Block 2025: POSITION_MOVE_XYZ');


function data = OmniTrakFileRead_ReadBlock_POSITION_START_X(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2020
%		POSITION_START_X

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,1,'float32'), NaN, NaN];                     %Save the starting positioner x-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_POSITION_START_XY(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2022
%		POSITION_START_XY

data = OmniTrakFileRead_Check_Field_Name(data,'pos','start');               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the module index.
data.pos(i).start = [fread(fid,2,'float32'), NaN];                          %Save the starting positioner x- and y-value as a float32 value.   


function data = OmniTrakFileRead_ReadBlock_POSITION_START_XYZ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2024
%		POSITION_START_XYZ

fprintf(1,'Need to finish coding for Block 2024: POSITION_START_XYZ');


function data = OmniTrakFileRead_ReadBlock_PRIMARY_INPUT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		111
%		PRIMARY_INPUT

data = OmniTrakFileRead_Check_Field_Name(data,'input');                     %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.input(1).primary = fread(fid,N,'*char')';                              %Read in the characters of the primary module name.


function data = OmniTrakFileRead_ReadBlock_PRIMARY_MODULE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	110
%		DEFINITION:		PRIMARY_MODULE
%		DESCRIPTION:	Primary module name, for systems with interchangeable modules.
%
%   UPDATE LOG:
%   2024-01-19 - Drew Sloan - Added handling for old files in which the
%                             character count was written as a uint16.
%

data = OmniTrakFileRead_Check_Field_Name(data,'module');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
temp_str = fread(fid,N,'*char')';                                           %Read in the characters of the primary module name.
if temp_str(1) == 0                                                         %If the first character is zero...
    fseek(fid,-(N+1),'cof');                                                %Rewind to the character count.
    N = fread(fid,1,'uint16');                                              %Read in the number of characters.
    temp_str = fread(fid,N,'*char')';                                       %Read in the characters of the primary module name.
end
data.module(1).name = temp_str;                                             %Save the primary module name.


function data = OmniTrakFileRead_ReadBlock_REMOTE_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2400
%		REMOTE_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_remote';                               %Save the feed trigger source.  


function data = OmniTrakFileRead_ReadBlock_RENAMED_FILE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		41
%		RENAMED_FILE

data = OmniTrakFileRead_Check_Field_Name(data,'file_info','rename');        %Call the subfunction to check for existing fieldnames.
i = length(data.file_info.rename) + 1;                                      %Find the next available index for a renaming event.
data.file_info.rename(i).time = fread(fid,1,'float64');                     %Read in the timestamp for the renaming.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the old filename.
data.file_info.rename(i).old = char(fread(fid,N,'uchar')');                 %Read in the old filename.
N = fread(fid,1,'uint16');                                                  %Read in the number of characters in the new filename.
data.file_info.rename(i).new = char(fread(fid,N,'uchar')');                 %Read in the new filename.     


function data = OmniTrakFileRead_ReadBlock_RTC_STRING(fid,data)

%	OmniTrak File Block Code (OFBC):
%		31
%		RTC_STRING

fprintf(1,'Need to finish coding for Block 31: RTC_STRING');


function data = OmniTrakFileRead_ReadBlock_RTC_STRING_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		30
%		RTC_STRING_DEPRECATED

fprintf(1,'Need to finish coding for Block 30: RTC_STRING_DEPRECATED');


function data = OmniTrakFileRead_ReadBlock_RTC_VALUES(fid,data)

%	OmniTrak File Block Code (OFBC):
%		32
%		RTC_VALUES

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
data.clock(i).ms = fread(fid,1,'uint32');                                   %Save the 32-bit millisecond clock timestamp.
yr = fread(fid,1,'uint16');                                                 %Read in the year.
mo = fread(fid,1,'uint8');                                                  %Read in the month.
dy = fread(fid,1,'uint8');                                                  %Read in the day.
hr = fread(fid,1,'uint8');                                                  %Read in the hour.
mn = fread(fid,1,'uint8');                                                  %Read in the minute.
sc = fread(fid,1,'uint8');                                                  %Read in the second.            
data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);                    %Save the RTC time as a MATLAB serial date number.
data.clock(i).source = 'RTC';                                               %Indicate that the date/time source was a real-time clock.


function data = OmniTrakFileRead_ReadBlock_SAMD_CHIP_ID(fid,data)

%	OmniTrak File Block Code (OFBC):
%		112
%		SAMD_CHIP_ID

data = OmniTrakFileRead_Check_Field_Name(data,'device','samd_chip_id');     %Call the subfunction to check for existing fieldnames.    
data.device.samd_chip_id = fread(fid,4,'uint32');                           %Save the 32-bit SAMD chip ID.


function data =  OmniTrakFileRead_ReadBlock_SCOPE_TRACE(fid,data)

%
% OmniTrakFileRead_ReadBlock_SCOPE_TRACE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SCOPE_TRACE reads in the "SCOPE_TRACE" data 
%   block from an *.OmniTrak format file. This block is intended to contain
%   a single oscilloscope recording, in units of volts, from one or
%   multiple channels, with time units in seconds, along with a variable 
%   number of parameters describing the recording conditions.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x000C
%		DEFINITION:		SCOPE_TRACE
%		DESCRIPTION:	An oscilloscope recording, in units of volts, from 
%                       one or multiple channels, with time units, in 
%                       seconds, along with a variable number of parameters
%                       describing the recording conditions.
%
%   UPDATE LOG:
%   2025-06-19 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trace');                     %Call the subfunction to check for existing fieldnames.
trace_i = length(data.trace) + 1;                                           %Increment the oscilloscope trace index.

ver = fread(fid,1,'uint16');                                                %Read in the "SCOPE_TRACE" data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        num_fields = fread(fid,1,'uint8');                                  %Read in the number of fields to follow.
        for i = 1:num_fields                                                %Step through the fields.
            N = fread(fid,1,'uint8');                                       %Read in the number of characters in the field name.
            field = fread(fid,N,'*char')';                                  %Read in the field name.
            data.trace(trace_i).(field) = fread(fid,1,'float64');           %Read in the value for each field.
        end
        num_samples = fread(fid,1,'uint64');                                %Read in the number of samples.
        num_signals = fread(fid,1,'uint8');                                 %Read in the number of signals.
        data.trace(trace_i).sample_times = ...
            fread(fid,num_samples,'float32')';                              %Read in the sampling times.
        data.trace(trace_i).signal = nan(num_signals, num_samples);         %Pre-allocate an array to hold the signals.
        for i = 1:num_signals                                               %Step through each signal.
            data.trace(trace_i).signal(i,:) = ...
                fread(fid,num_samples,'float32');                           %Read in each signal.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_SECONDARY_THRESH_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2310
%		SECONDARY_THRESH_NAME

fprintf(1,'Need to finish coding for Block 2310: SECONDARY_THRESH_NAME');


function data = OmniTrakFileRead_ReadBlock_SGP30_EC02(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1410
%		SGP30_EC02

if ~isfield(data,'eco2')                                                    %If the structure doesn't yet have a "eco2" field..
    data.eco2 = [];                                                         %Create the field.
end
i = length(data.eco2) + 1;                                                  %Grab a new eCO2 reading index.
data.eco2(i).src = 'SGP30';                                                 %Save the source of the eCO2 reading.
data.eco2(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.eco2(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.eco2(i).int = fread(fid,1,'uint16');                                   %Save the eCO2 reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_SGP30_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1005
%		SGP30_ENABLED

fprintf(1,'Need to finish coding for Block 1005: SGP30_ENABLED');


function data = OmniTrakFileRead_ReadBlock_SGP30_SN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1400
%		SGP30_SN

fprintf(1,'Need to finish coding for Block 1400: SGP30_SN');


function data = OmniTrakFileRead_ReadBlock_SGP30_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1420
%		SGP30_TVOC

if ~isfield(data,'tvoc')                                                    %If the structure doesn't yet have a "tvoc" field..
    data.tvoc = [];                                                         %Create the field.
end
i = length(data.tvoc) + 1;                                                  %Grab a new TVOC reading index.
data.tvoc(i).src = 'SGP30';                                                 %Save the source of the TVOC reading.
data.tvoc(i).id = fread(fid,1,'uint8');                                     %Read in the SGP30 sensor index (there may be multiple sensors).
data.tvoc(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.tvoc(i).int = fread(fid,1,'uint16');                                   %Save the TVOC reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_SOFT_PAUSE_START(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2012
%		SOFT_PAUSE_START

fprintf(1,'Need to finish coding for Block 2012: SOFT_PAUSE_START');


function data =  OmniTrakFileRead_ReadBlock_SOFT_PAUSE_STOP(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x07DD
%		DEFINITION:		SOFT_PAUSE_STOP
%		DESCRIPTION:	Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.

error('Need to finish coding for OFBC block 0x07DD ("SOFT_PAUSE_STOP")!');


function data = OmniTrakFileRead_ReadBlock_SPECTRO_TRACE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1901
%		SPECTRO_TRACE

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','trace');           %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
t = numel(data.spectro(spectro_i).trace) + 1;                               %Find the next trace index.
data.spectro(spectro_i).trace(t).module = fread(fid,1,'uint8');             %Read in the module index.
data.spectro(spectro_i).trace(t).chan = fread(fid,1,'uint16');              %Read in the light source channel index.
data.spectro(spectro_i).trace(t).time = fread(fid,1,'float64');             %Read in the trace timestamp.
data.spectro(spectro_i).trace(t).intensity = fread(fid,1,'float32');        %Read in the light source intensity.
data.spectro(spectro_i).trace(t).position = fread(fid,1,'float32');         %Read in the light source position.
data.spectro(spectro_i).trace(t).integration = fread(fid,1,'float32');      %Read in the integration time.
data.spectro(spectro_i).trace(t).minus_background = fread(fid,1,'uint8');   %Read in the the background subtraction flag.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
reps = fread(fid,1,'uint16');                                               %Read in the number of repetitions in the trace.
data.spectro(spectro_i).trace(t).data = nan(reps,N);                        %Pre-allocate a data field.
for i = 1:reps                                                              %Step through each repetition.
    data.spectro(spectro_i).trace(t).data(i,:) = fread(fid,N,'float64');    %Read in each repetition.
end


function data = OmniTrakFileRead_ReadBlock_SPECTRO_WAVELEN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1900
%		SPECTRO_WAVELEN

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','wavelengths');     %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
data.spectro(spectro_i).wavelengths = fread(fid,N,'float32')';              %Read in the characters of the light source model.


function data = OmniTrakFileRead_ReadBlock_STAGE_DESCRIPTION(fid,data)

%	OmniTrak File Block Code (OFBC):
%		401
%		STAGE_DESCRIPTION

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage.description = fread(fid,N,'*char')';                             %Read in the characters of the behavioral session stage description.


function data = OmniTrakFileRead_ReadBlock_STAGE_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		400
%		STAGE_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.stage.name = fread(fid,N,'*char')';                                    %Read in the characters of the behavioral session stage name.


function data = OmniTrakFileRead_ReadBlock_STAP_2AFC_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2740
%		DEFINITION:		STAP_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak proprioception discrimination task trial outcome data.

%   2022/03/16 - Drew Sloan - Function first created.
%

try
    spot = ftell(fid);
data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Character code for the outcome.
data.trial(t).visited_feeder = fread(fid,1,'*char');                        %Character code for the visited feeder.
N = fread(fid,1,'uint8');                                                   %Number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Feeding times.
data.trial(t).max_touch_dur = fread(fid,1,'float32');                       %Touch duration maximum limit.
data.trial(t).min_touch_dur = fread(fid,1,'float32');                       %Touch duration minimum limit.
data.trial(t).touch_dur = fread(fid,1,'float32');                           %Read in the actual touch duration.
data.trial(t).choice_time = fread(fid,1,'float32');                         %Feeder choice time limit.
data.trial(t).response_time = fread(fid,1,'float32');                       %Feeder response time.

data.trial(t).movement_start = fread(fid,1,'uint32');                       %Movement start time (Arduino millisecond clock).
N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
if data.trial(t).excursion_type(1) == 'C'
    fseek(fid,-(N + 5),'cof');
    N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
    data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
    data.trial(t).movement_start = NaN;
end
data.trial(t).amplitude = fread(fid,1,'float32');                           %Excursion amplitude, in millimeters.
data.trial(t).speed = fread(fid,1,'float32');                               %Excursion speed, in millimeters/second.

num_signals = fread(fid,1,'uint8');                                         %Number of data signals (besides the timestamp).
N = fread(fid,1,'uint32');                                                  %Number of samples in each stream.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end
catch
    disp(spot);
end


function data = OmniTrakFileRead_ReadBlock_STREAM_INPUT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2100
%		STREAM_INPUT_NAME

fprintf(1,'Need to finish coding for Block 2100: STREAM_INPUT_NAME');


function data = OmniTrakFileRead_ReadBlock_STTC_2AFC_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2720
%		DEFINITION:		STTC_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak tactile discrimination task trial outcome data.
%
%   2022/03/16 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Character code for the outcome.
data.trial(t).visited_feeder = fread(fid,1,'*char');                        %Character code for the visited feeder.
N = fread(fid,1,'uint8');                                                   %Number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Feeding times.
data.trial(t).max_touch_dur = fread(fid,1,'float32');                       %Touch duration maximum limit.
data.trial(t).min_touch_dur = fread(fid,1,'float32');                       %Touch duration minimum limit.
data.trial(t).touch_dur = fread(fid,1,'float32');                           %Read in the actual touch duration.
data.trial(t).choice_time = fread(fid,1,'float32');                         %Feeder choice time limit.
data.trial(t).response_time = fread(fid,1,'float32');                       %Feeder response time.

data.trial(t).pad_index = fread(fid,1,'uint8');                             %Texture pad index.
N = fread(fid,1,'uint8');                                                   %Number of characters in the pad label.
data.trial(t).pad_label = fread(fid,N,'*char')';                            %Texture pad label.

num_signals = fread(fid,1,'uint8');                                         %Number of data signals (besides the timestamp).
N = fread(fid,1,'uint32');                                                  %Number of samples in each stream.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end


function data = OmniTrakFileRead_ReadBlock_STTC_NUM_PADS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2721
%		DEFINITION:		STTC_NUM_PADS
%		DESCRIPTION:	Number of pads on the SensiTrak Tactile Carousel module.
%
% fwrite(fid,ofbc.STTC_NUM_PADS,'uint16');
% fwrite(fid,1,'uint8');
% fwrite(fid,handles.ctrl.sttc_get_num_pads(),'uint8');

data = OmniTrakFileRead_Check_Field_Name(data,'module','num_pads');         %Call the subfunction to check for existing fieldnames.
module_i = fread(fid,1,'uint8');                                            %Read in the module index.
data.module(module_i).num_pads = fread(fid,1,'uint8');                      %Read in the number of texture pads.
if data.module(module_i).num_pads > 10                                      %If there's more than 10 texture pads.
    temp = 0;                                                               %Create a variable to hold the block code.
    while (temp ~= 2722) && ~feof(fid)                                      %Loop until we find the next expected block code.        
        fseek(fid,-1,'cof');                                                %Rewind one byte.
        temp = fread(fid,1,'uint16');                                       %Read in an unsigned 16-bit integer.
%         fprintf(1,'ftell(fid) = %1.0f, temp = %1.0f\n',ftell(fid),temp);
    end
    fseek(fid,-3,'cof');                                                    %Rewind 3 bytes.
    data.module(module_i).num_pads = fread(fid,1,'uint8');                  %Read in the number of texture pads.
end


function data = OmniTrakFileRead_ReadBlock_SUBJECT_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		4
%		SUBJECT_DEPRECATED

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject = fread(fid,N,'*char')';                                       %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_SUBJECT_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		200
%		SUBJECT_NAME

N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.subject.name = fread(fid,N,'*char')';                                  %Read in the characters of the subject's name.


function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2405
%		SWUI_MANUAL_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'feed',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.
if length(data.feed) < i                                                    %If the structure doesn't yet have this dispenser index...
    for j = (length(data.feed)+1):i                                         %Step through each missing index.
        data.feed(i) = struct('time',[],'num',[],'source',[]);              %Add new indices to the structure.
    end 
end
j = size(data.feed(i).time,1) + 1;                                          %Find the next index for the feed timestamp for this dispenser.
if j == 1                                                                   %If this is the first manual feeding...
    data.feed(i).time = fread(fid,1,'float64');                             %Save the millisecond clock timestamp.
    data.feed(i).num = fread(fid,1,'uint16');                               %Save the number of feedings.
    data.feed(i).source = {'manual_software'};                              %Save the feed trigger source.  
else                                                                        %Otherwise, if this isn't the first manual feeding...
    data.feed(i).time(j,1) = fread(fid,1,'float64');                        %Save the millisecond clock timestamp.
    data.feed(i).num(j,1) = fread(fid,1,'uint16');                          %Save the number of feedings.
    data.feed(i).source{j,1} = 'manual_software';                           %Save the feed trigger source.
end


function data = OmniTrakFileRead_ReadBlock_SWUI_MANUAL_FEED_DEPRECATED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2403
%		SWUI_MANUAL_FEED_DEPRECATED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = 1;                                                                      %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint8');                             %Save the number of feedings.
data.pellet(i).source{j,1} = 'manual_software';                             %Save the feed trigger source.


function data = OmniTrakFileRead_ReadBlock_SW_OPERANT_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2407
%		SW_OPERANT_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'operant_software';                            %Save the feed trigger source.   


function data = OmniTrakFileRead_ReadBlock_SW_RANDOM_FEED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2406
%		SW_RANDOM_FEED

data = OmniTrakFileRead_Check_Field_Name(data,'pellet',...
    {'time','num','source'});                                               %Call the subfunction to check for existing fieldnames.
i = fread(fid,1,'uint8');                                                   %Read in the dispenser index.                
j = size(data.pellet(i).time,1) + 1;                                        %Find the next index for the pellet timestamp for this dispenser.
data.pellet(i).time(j,1) = fread(fid,1,'float64');                          %Save the millisecond clock timestamp.
data.pellet(i).num(j,1) = fread(fid,1,'uint16');                            %Save the number of feedings.
data.pellet(i).source{j,1} = 'random_software';                             %Save the feed trigger source.   


function data = OmniTrakFileRead_ReadBlock_SYSTEM_FW_VER(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_SN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_SN reads in the "SYSTEM_FW_VER" data 
%   block from an *.OmniTrak format file. This block is intended to contain
%   the firmware version for the primary device for the system collecting 
%   data, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0067
%		DEFINITION:		SYSTEM_SN
%		DESCRIPTION:	System firmware version, written as characters.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-07-02 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%


data = OmniTrakFileRead_Check_Field_Name(data,'system');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.fw_version = char(fread(fid,N,'uchar')');                       %Read in the firmware version.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_HW_VER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		102
%		SYSTEM_HW_VER

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.    
data.device.hw_version = fread(fid,1,'float32');                            %Save the device hardware version.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_MFR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		105
%		SYSTEM_MFR

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.device.manufacturer = char(fread(fid,N,'uchar')');                     %Read in the manufacturer.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_NAME(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_NAME.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_NAME reads in the "SYSTEM_NAME" 
%   data block from an *.OmniTrak format file. This block is intended to 
%   contain the overall system name, not just the name of the primary
%   device or controller, written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0065
%		DEFINITION:		SYSTEM_NAME
%		DESCRIPTION:	Vulintus system name.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-06-19 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%

data = OmniTrakFileRead_Check_Field_Name(data,'system','name');             %Call the subfunction to check for existing fieldnames.         

N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.name = fread(fid,N,'*char')';                                   %Read in the characters of the system name.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_SN(fid,data)

%
% OmniTrakFileRead_ReadBlock_SYSTEM_SN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SYSTEM_SN reads in the "SYSTEM_SN" data 
%   block from an *.OmniTrak format file. This block is intended to contain
%   the serial number of the primary device for the system collecting data,
%   written as characters.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0068
%		DEFINITION:		SYSTEM_SN
%		DESCRIPTION:	System serial number, written as characters.
%
%   UPDATE LOG:
%   ????-??-?? - Drew Sloan - Function first created.
%   2025-07-02 - Drew Sloan - Updated function description to match the
%                             "ReadBlock" documentation style.
%


data = OmniTrakFileRead_Check_Field_Name(data,'system');                    %Call the subfunction to check for existing fieldnames.
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
data.system.serial_num = char(fread(fid,N,'uchar')');                       %Read in the serial number.


function data = OmniTrakFileRead_ReadBlock_SYSTEM_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		100
%		SYSTEM_TYPE

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field.
    data.device = [];                                                       %Create the field.
end
data.device.type = fread(fid,1,'uint8');                                    %Save the device type value.


function data = OmniTrakFileRead_ReadBlock_TASK_TYPE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		301
%		TASK_TYPE

data = OmniTrakFileRead_Check_Field_Name(data,'task');                    %Call the subfunction to check for existing fieldnames.                
N = fread(fid,1,'uint16');                                                  %Read in the number of characters.
data.task(1).type = fread(fid,N,'*char')';                                  %Read in the characters of the user's task type.


function data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	25
%		DEFINITION:		TIME_ZONE_OFFSET
%		DESCRIPTION:	Computer clock time zone offset from UTC.       
%
% fwrite(fid,ofbc.TIME_ZONE_OFFSET,'uint16');                          
% dt = datenum(datetime('now','TimeZone','local')) - ...
%     datenum(datetime('now','TimeZone','UTC'));                         
% fwrite(fid,dt,'float64');    

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.
data.clock(1).time_zone = fread(fid,1,'float64');                           %Read in the time zone adjustment relative to UTC.


function data = OmniTrakFileRead_ReadBlock_TIME_ZONE_OFFSET_HHMM(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	26
%		DEFINITION:		TIME_ZONE_OFFSET_HHMM
%		DESCRIPTION:	Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes


data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
hr = fread(fid,1,'int8');                                                   %Read in the hour of the time zone offset.
min = fread(fid,1,'uint8');                                                 %Read in the minutes of the time zone offset.
if hr < 0                                                                   %If the time zone offset is less than one.
    data.clock(i).time_zone = double(hr) - double(min)/60;                  %Save the time zone offset in fractional hours.
else                                                                        %Otherwise...
    data.clock(i).time_zone = double(hr) + double(min)/60;                  %Save the time zone offset in fractional hours.
end


function data = OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2014
%		DEFINITION:		TRIAL_START_SERIAL_DATE
%		DESCRIPTION:	Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

data = OmniTrakFileRead_Check_Field_Name(data,'trial','start','datenum');   %Call the subfunction to check for existing fieldnames.

timestamp = fread(fid,1,'float64');                                         %Read in the serial date number timestamp.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start.datenum = timestamp;                                    %Save the serial date number timestamp for the trial.


function data = OmniTrakFileRead_ReadBlock_TTL_PULSE(fid,data)

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


function data = OmniTrakFileRead_ReadBlock_USER_SYSTEM_NAME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		130
%		USER_SYSTEM_NAME

if ~isfield(data,'device')                                                  %If the structure doesn't yet have an "device" field..
    data.device = [];                                                       %Create the field.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of characters.
if N < 255                                                                  %If there's less than 255 characters in the system name.
    data.device.user_system_name = fread(fid,N,'*char')';                   %Read in the characters of the system name.
else                                                                        %Otherwise...
    data.device.user_system_name = 'USER_SYSTEM_NAME_ERROR';                %Show that there was an error in the system name.
    temp = 'xxx';                                                           %Create a temporary string for comparison.
    while ~strcmpi(temp,'COM')                                              %Loop until we find the characters "COM"...
        fseek(fid,-2,'cof');                                                %Rewind 2 bytes.
        temp = fread(fid,3,'*char')';                                       %Read in the characters of the system name.
    end
    fseek(fid,-6,'cof');                                                    %Rewind 5 bytes.
end


function data = OmniTrakFileRead_ReadBlock_USER_TIME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		60
%		USER_TIME

data = OmniTrakFileRead_Check_Field_Name(data,'clock');                     %Call the subfunction to check for existing fieldnames.    
i = length(data.clock) + 1;                                                 %Find the next available index for a new real-time clock synchronization.
data.clock(i).ms = fread(fid,1,'uint32');                                   %Save the 32-bit millisecond clock timestamp.
yr = double(fread(fid,1,'uint8')) + 2000;                                   %Read in the year.
mo = fread(fid,1,'uint8');                                                  %Read in the month.
dy = fread(fid,1,'uint8');                                                  %Read in the day.
hr = fread(fid,1,'uint8');                                                  %Read in the hour.
mn = fread(fid,1,'uint8');                                                  %Read in the minute.
sc = fread(fid,1,'uint8');                                                  %Read in the second.            
data.clock(i).datenum = datenum(yr, mo, dy, hr, mn, sc);                    %Save the RTC time as a MATLAB serial date number.
data.clock(i).source = 'USER';                                              %Indicate that the date/time source was a real-time clock.


function data = OmniTrakFileRead_ReadBlock_US_TIMER_ROLLOVER(fid,data)

%	OmniTrak File Block Code (OFBC):
%		24
%		US_TIMER_ROLLOVER

fprintf(1,'Need to finish coding for Block 24: US_TIMER_ROLLOVER');


function data = OmniTrakFileRead_ReadBlock_VIBRATION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2700
%		VIBRATION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Read in the trial start time (serial date number).
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the trial outcome.
N = fread(fid,1,'uint8');                                                   %Read in the number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Read in the feeding times.
data.trial(t).hit_win = fread(fid,1,'float32');                             %Read in the hit window.
data.trial(t).vib_dur = fread(fid,1,'float32');                             %Read in the vibration pulse duration.
data.trial(t).vib_rate = fread(fid,1,'float32');                            %Read in the vibration pulse rate.
data.trial(t).actual_vib_rate = fread(fid,1,'float32');                     %Read in the actual vibration pulse rate.
data.trial(t).gap_length = fread(fid,1,'float32');                          %Read in the gap length.
data.trial(t).actual_gap_length = fread(fid,1,'float32');                   %Read in the actual gap length.
data.trial(t).hold_time = fread(fid,1,'float32');                           %Read in the hold time.
data.trial(t).time_held = fread(fid,1,'float32');                           %Read in the time held.
data.trial(t).vib_n = fread(fid,1,'uint16');                                %Read in the number of vibration pulses.
data.trial(t).gap_start = fread(fid,1,'uint16');                            %Read in the number of vibration gap start index.
data.trial(t).gap_stop = fread(fid,1,'uint16');                             %Read in the number of vibration gap stop index.
data.trial(t).debounce_samples = fread(fid,1,'uint16');                     %Read in the number of debounce samples.
data.trial(t).pre_samples = fread(fid,1,'uint32');                          %Read in the number of pre-trial samples.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
N = fread(fid,1,'uint32');                                                  %Read in the number of samples.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end


function data = OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data)

%
% OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_VIBROTACTILE_DETECTION_TASK_TRIAL writes
%   data from individual trials of the Fixed Reinforcement task.
%
%   OFBC block code: 0x0A8D
%
%   UPDATE LOG:
%   2025-05-27 - Drew Sloan - Function completed.
%

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2701
%		DEFINITION:		VIBROTACTILE_DETECTION_TASK_TRIAL
%		DESCRIPTION:	Vibrotactile detection task trial data.

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint16');                                                %Read in the FR_TASK_TRIAL data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.        
        t = fread(fid,1,'uint16');                                          %Read in the trial number/index.
        data.trial(t).start_time = fread(fid,1,'float64');                  %Read in the trial start time (serial date number).
        data.trial(t).outcome = fread(fid,1,'*char');                       %Read in the trial outcome.
        N = fread(fid,1,'uint8');                                           %Read in the number of feedings.
        data.trial(t).feed_time = fread(fid,N,'float64');                   %Read in the feeding times.
        data.trial(t).hit_win = fread(fid,1,'float32');                     %Read in the hit window.
        data.trial(t).vib_dur = fread(fid,1,'float32');                     %Read in the vibration pulse duration.
        data.trial(t).vib_rate = fread(fid,1,'float32');                    %Read in the vibration pulse rate.
        data.trial(t).actual_vib_rate = fread(fid,1,'float32');             %Read in the actual vibration pulse rate.
        data.trial(t).gap_length = fread(fid,1,'float32');                  %Read in the gap length.
        data.trial(t).actual_gap_length = fread(fid,1,'float32');           %Read in the actual gap length.
        data.trial(t).hold_time = fread(fid,1,'float32');                   %Read in the hold time.
        data.trial(t).time_held = fread(fid,1,'float32');                   %Read in the time held.
        data.trial(t).vib_n = fread(fid,1,'uint16');                        %Read in the number of vibration pulses.
        data.trial(t).gap_start = fread(fid,1,'uint16');                    %Read in the number of vibration gap start index.
        data.trial(t).gap_stop = fread(fid,1,'uint16');                     %Read in the number of vibration gap stop index.
        data.trial(t).pre_samples = fread(fid,1,'uint32');                  %Read in the number of pre-trial samples.
        num_signals = fread(fid,1,'uint8');                                 %Read in the number of signal streams.
        N = fread(fid,1,'uint32');                                          %Read in the number of samples.
        data.trial(t).times = fread(fid,N,'uint32');                        %Read in the millisecond clock timestampes.
        data.trial(t).signal = nan(N,num_signals);                          %Create a matrix to hold the sensor signals.
        for i = 1:num_signals                                               %Step through the signals.
            data.trial(t).signal(:,i) = fread(fid,N,'float32');             %Read in each signal.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end


function data = OmniTrakFileRead_ReadBlock_VL53L0X_DIST(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1300
%		VL53L0X_DIST

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                                  %Grab a new distance reading index.
data.dist(i).src = 'VL53L0X';                                               %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                                     %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                                  %Save the millisecond clock timestamp for the reading.
data.dist(i).int = fread(fid,1,'uint16');                                   %Save the distance reading as an unsigned 16-bit value.   


function data = OmniTrakFileRead_ReadBlock_VL53L0X_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1006
%		VL53L0X_ENABLED

fprintf(1,'Need to finish coding for Block 1006: VL53L0X_ENABLED');


function data = OmniTrakFileRead_ReadBlock_VL53L0X_FAIL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1301
%		VL53L0X_FAIL

if ~isfield(data,'dist')                                                    %If the structure doesn't yet have a "dist" field..
    data.dist = [];                                                         %Create the field.
end
i = length(data.dist) + 1;                                      %Grab a new distance reading index.
data.dist(i).src = 'SGP30';                                     %Save the source of the distance reading.
data.dist(i).id = fread(fid,1,'uint8');                         %Read in the VL53L0X sensor index (there may be multiple sensors).
data.dist(i).time = fread(fid,1,'uint32');                      %Save the millisecond clock timestamp for the reading.
data.dist(i).int = NaN;                                         %Save a NaN in place of a value to indicate a read failure.


function data = OmniTrakFileRead_ReadBlock_WINC1500_IP4_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		151
%		WINC1500_IP4_ADDR

fprintf(1,'Need to finish coding for Block 151: WINC1500_IP4_ADDR');


function data = OmniTrakFileRead_ReadBlock_WINC1500_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		150
%		WINC1500_MAC_ADDR

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.
data.device.mac_addr = fread(fid,6,'uint8');                                %Save the device MAC address.


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_CONFIG_PARAMS(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1701
%		ZMOD4410_CONFIG_PARAMS

fprintf(1,'Need to finish coding for Block 1701: ZMOD4410_CONFIG_PARAMS');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ECO2(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1710
%		ZMOD4410_ECO2

fprintf(1,'Need to finish coding for Block 1710: ZMOD4410_ECO2');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ENABLED(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1009
%		ZMOD4410_ENABLED

fprintf(1,'Need to finish coding for Block 1009: ZMOD4410_ENABLED');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_ERROR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1702
%		ZMOD4410_ERROR

fprintf(1,'Need to finish coding for Block 1702: ZMOD4410_ERROR');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_IAQ(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1711
%		ZMOD4410_IAQ

fprintf(1,'Need to finish coding for Block 1711: ZMOD4410_IAQ');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_MOX_BOUND(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1700
%		ZMOD4410_MOX_BOUND

fprintf(1,'Need to finish coding for Block 1700: ZMOD4410_MOX_BOUND');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_FL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1703
%		ZMOD4410_READING_FL

fprintf(1,'Need to finish coding for Block 1703: ZMOD4410_READING_FL');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_READING_INT(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1704
%		ZMOD4410_READING_INT

data = OmniTrakFileRead_Check_Field_Name(data,'gas_adc');                   %Call the subfunction to check for existing fieldnames.
i = length(data.gas_adc) + 1;                                               %Grab a new TVOC reading index.
data.gas_adc(i).src = 'ZMOD4410';                                           %Save the source of the TVOC reading.
data.gas_adc(i).id = fread(fid,1,'uint8');                                  %Read in the SGP30 sensor index (there may be multiple sensors).
data.gas_adc(i).time = fread(fid,1,'uint32');                               %Save the millisecond clock timestamp for the reading.
data.gas_adc(i).int = fread(fid,1,'uint16');                                %Save the TVOC reading as an unsigned 16-bit value.


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_R_CDA(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1713
%		ZMOD4410_R_CDA

fprintf(1,'Need to finish coding for Block 1713: ZMOD4410_R_CDA');


function data = OmniTrakFileRead_ReadBlock_ZMOD4410_TVOC(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1712
%		ZMOD4410_TVOC

fprintf(1,'Need to finish coding for Block 1712: ZMOD4410_TVOC');


function waitbar = big_waitbar(varargin)

figsize = [2,16];                                                           %Set the default figure size, in centimeters.
barcolor = 'b';                                                             %Set the default waitbar color.
titlestr = 'Waiting...';                                                    %Set the default waitbar title.
txtstr = 'Waiting...';                                                      %Set the default waitbar string.
val = 0;                                                                    %Set the default value of the waitbar to zero.

str = {'FigureSize','Color','Title','String','Value'};                      %List the allowable parameter names.
for i = 1:2:length(varargin)                                                %Step through any optional input arguments.
    if ~ischar(varargin{i}) || ~any(strcmpi(varargin{i},str))               %If the first optional input argument isn't one of the expected property names...
        beep;                                                               %Play the Matlab warning noise.
        cprintf('red','%s\n',['ERROR IN BIG_WAITBAR: Property '...
            'name not recognized! Optional input properties are:']);        %Show an error.
        for j = 1:length(str)                                               %Step through each allowable parameter name.
            cprintf('red','\t%s\n',str{j});                                 %List each parameter name in the command window, in red.
        end
        return                                                              %Skip execution of the rest of the function.
    else                                                                    %Otherwise...
        if strcmpi(varargin{i},'FigureSize')                                %If the optional input property is "FigureSize"...
            figsize = varargin{i+1};                                        %Set the figure size to that specified, in centimeters.            
        elseif strcmpi(varargin{i},'Color')                                 %If the optional input property is "Color"...
            barcolor = varargin{i+1};                                       %Set the waitbar color the specified color.
        elseif strcmpi(varargin{i},'Title')                                 %If the optional input property is "Title"...
            titlestr = varargin{i+1};                                       %Set the waitbar figure title to the specified string.
        elseif strcmpi(varargin{i},'String')                                %If the optional input property is "String"...
            txtstr = varargin{i+1};                                         %Set the waitbar text to the specified string.
        elseif strcmpi(varargin{i},'Value')                                 %If the optional input property is "Value"...
            val = varargin{i+1};                                            %Set the waitbar value to the specified value.
        end
    end    
end

orig_units = get(0,'units');                                                %Grab the current system units.
set(0,'units','centimeters');                                               %Set the system units to centimeters.
pos = get(0,'Screensize');                                                  %Grab the screensize.
h = figsize(1);                                                             %Set the height of the figure.
w = figsize(2);                                                             %Set the width of the figure.
fig = figure('numbertitle','off',...
    'name',titlestr,...
    'units','centimeters',...
    'Position',[pos(3)/2-w/2, pos(4)/2-h/2, w, h],...
    'menubar','none',...
    'resize','off');                                                        %Create a figure centered in the screen.
ax = axes('units','centimeters',...
    'position',[0.25,0.25,w-0.5,h/2-0.3],...
    'parent',fig);                                                          %Create axes for showing loading progress.
if val > 1                                                                  %If the specified value is greater than 1...
    val = 1;                                                                %Set the value to 1.
elseif val < 0                                                              %If the specified value is less than 0...
    val = 0;                                                                %Set the value to 0.
end    
obj = fill(val*[0 1 1 0 0],[0 0 1 1 0],barcolor,'edgecolor','k');           %Create a fill object to show loading progress.
set(ax,'xtick',[],'ytick',[],'box','on','xlim',[0,1],'ylim',[0,1]);         %Set the axis limits and ticks.
txt = uicontrol(fig,'style','text','units','centimeters',...
    'position',[0.25,h/2+0.05,w-0.5,h/2-0.3],'fontsize',10,...
    'horizontalalignment','left','backgroundcolor',get(fig,'color'),...
    'string',txtstr);                                                       %Create a text object to show the current point in the wait process.  
set(0,'units',orig_units);                                                  %Set the system units back to the original units.

waitbar.type = 'big_waitbar';                                               %Set the structure type.
waitbar.title = @(str)SetTitle(fig,str);                                    %Set the function for changing the waitbar title.
waitbar.string = @(str)SetString(fig,txt,str);                              %Set the function for changing the waitbar string.
% waitbar.value = @(val)SetVal(fig,obj,val);                                  %Set the function for changing waitbar value.
waitbar.value = @(varargin)GetSetVal(fig,obj,varargin{:});                  %Set the function for reading/setting the waitbar value.
waitbar.color = @(val)SetColor(fig,obj,val);                                %Set the function for changing waitbar color.
waitbar.close = @()CloseWaitbar(fig);                                       %Set the function for closing the waitbar.
waitbar.isclosed = @()WaitbarIsClosed(fig);                                 %Set the function for checking whether the waitbar figure is closed.

drawnow;                                                                    %Immediately show the waitbar.


%% This function sets the name/title of the waitbar figure.
function SetTitle(fig,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(fig,'name',str);                                                    %Set the figure name to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function sets the string on the waitbar figure.
function SetString(fig,txt,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(txt,'string',str);                                                  %Set the string in the text object to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


% %% This function sets the current value of the waitbar.
% function SetVal(fig,obj,val)
% if ishandle(fig)                                                            %If the waitbar figure is still open...
%     if val > 1                                                              %If the specified value is greater than 1...
%         val = 1;                                                            %Set the value to 1.
%     elseif val < 0                                                          %If the specified value is less than 0...
%         val = 0;                                                            %Set the value to 0.
%     end
%     set(obj,'xdata',val*[0 1 1 0 0]);                                       %Set the patch object to extend to the specified value.
%     drawnow;                                                                %Immediately update the figure.
% else                                                                        %Otherwise...
%     warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
% end


%% This function reads/sets the waitbar value.
function val = GetSetVal(fig,obj,varargin)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    if nargin > 2                                                           %If a value was passed.
        val = varargin{1};                                                  %Grab the specified value.
        if val > 1                                                          %If the specified value is greater than 1...
            val = 1;                                                        %Set the value to 1.
        elseif val < 0                                                      %If the specified value is less than 0...
            val = 0;                                                        %Set the value to 0.
        end
        set(obj,'xdata',val*[0 1 1 0 0]);                                   %Set the patch object to extend to the specified value.
        drawnow;                                                            %Immediately update the figure.
    else                                                                    %Otherwise...
        val = get(obj,'xdata');                                             %Grab the x-coordinates from the patch object.
        val = val(2);                                                       %Return the right-hand x-coordinate.
    end
else                                                                        %Otherwise...
    warning('Cannot access the waitbar figure. It has been closed.');       %Show a warning.
end
    


%% This function sets the color of the waitbar.
function SetColor(fig,obj,val)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(obj,'facecolor',val);                                               %Set the patch object to have the specified facecolor.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function closes the waitbar figure.
function CloseWaitbar(fig)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    close(fig);                                                             %Close the waitbar figure.
    drawnow;                                                                %Immediately update the figure to allow it to close.
end


%% This function returns a logical value indicate whether the waitbar figure has been closed.
function isclosed = WaitbarIsClosed(fig)
isclosed = ~ishandle(fig);                                                  %Check to see if the figure handle is still a valid handle.


function count = cprintf(style,format,varargin)
% CPRINTF displays styled formatted text in the Command Window
%
% Syntax:
%    count = cprintf(style,format,...)
%
% Description:
%    CPRINTF processes the specified text using the exact same FORMAT
%    arguments accepted by the built-in SPRINTF and FPRINTF functions.
%
%    CPRINTF then displays the text in the Command Window using the
%    specified STYLE argument. The accepted styles are those used for
%    Matlab's syntax highlighting (see: File / Preferences / Colors / 
%    M-file Syntax Highlighting Colors), and also user-defined colors.
%
%    The possible pre-defined STYLE names are:
%
%       'Text'                 - default: black
%       'Keywords'             - default: blue
%       'Comments'             - default: green
%       'Strings'              - default: purple
%       'UnterminatedStrings'  - default: dark red
%       'SystemCommands'       - default: orange
%       'Errors'               - default: light red
%       'Hyperlinks'           - default: underlined blue
%
%       'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White'
%
%    STYLE beginning with '-' or '_' will be underlined. For example:
%          '-Blue' is underlined blue, like 'Hyperlinks';
%          '_Comments' is underlined green etc.
%
%    STYLE beginning with '*' will be bold (R2011b+ only). For example:
%          '*Blue' is bold blue;
%          '*Comments' is bold green etc.
%    Note: Matlab does not currently support both bold and underline,
%          only one of them can be used in a single cprintf command. But of
%          course bold and underline can be mixed by using separate commands.
%
%    STYLE also accepts a regular Matlab RGB vector, that can be underlined
%    and bolded: -[0,1,1] means underlined cyan, '*[1,0,0]' is bold red.
%
%    STYLE is case-insensitive and accepts unique partial strings just
%    like handle property names.
%
%    CPRINTF by itself, without any input parameters, displays a demo
%
% Example:
%    cprintf;   % displays the demo
%    cprintf('text',   'regular black text');
%    cprintf('hyper',  'followed %s','by');
%    cprintf('key',    '%d colored', 4);
%    cprintf('-comment','& underlined');
%    cprintf('err',    'elements\n');
%    cprintf('cyan',   'cyan');
%    cprintf('_green', 'underlined green');
%    cprintf(-[1,0,1], 'underlined magenta');
%    cprintf([1,0.5,0],'and multi-\nline orange\n');
%    cprintf('*blue',  'and *bold* (R2011b+ only)\n');
%    cprintf('string');  % same as fprintf('string') and cprintf('text','string')
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab
%    functionality. It works on Matlab 7+, but use at your own risk!
%
%    A technical description of the implementation can be found at:
%    <a href="http://undocumentedmatlab.com/blog/cprintf/">http://UndocumentedMatlab.com/blog/cprintf/</a>
%
% Limitations:
%    1. In R2011a and earlier, a single space char is inserted at the
%       beginning of each CPRINTF text segment (this is ok in R2011b+).
%
%    2. In R2011a and earlier, consecutive differently-colored multi-line
%       CPRINTFs sometimes display incorrectly on the bottom line.
%       As far as I could tell this is due to a Matlab bug. Examples:
%         >> cprintf('-str','under\nline'); cprintf('err','red\n'); % hidden 'red', unhidden '_'
%         >> cprintf('str','regu\nlar'); cprintf('err','red\n'); % underline red (not purple) 'lar'
%
%    3. Sometimes, non newline ('\n')-terminated segments display unstyled
%       (black) when the command prompt chevron ('>>') regains focus on the
%       continuation of that line (I can't pinpoint when this happens). 
%       To fix this, simply newline-terminate all command-prompt messages.
%
%    4. In R2011b and later, the above errors appear to be fixed. However,
%       the last character of an underlined segment is not underlined for
%       some unknown reason (add an extra space character to make it look better)
%
%    5. In old Matlab versions (e.g., Matlab 7.1 R14), multi-line styles
%       only affect the first line. Single-line styles work as expected.
%       R14 also appends a single space after underlined segments.
%
%    6. Bold style is only supported on R2011b+, and cannot also be underlined.
%
% Change log:
%    2012-08-09: Graceful degradation support for deployed (compiled) and non-desktop applications; minor bug fixes
%    2012-08-06: Fixes for R2012b; added bold style; accept RGB string (non-numeric) style
%    2011-11-27: Fixes for R2011b
%    2011-08-29: Fix by Danilo (FEX comment) for non-default text colors
%    2011-03-04: Performance improvement
%    2010-06-27: Fix for R2010a/b; fixed edge case reported by Sharron; CPRINTF with no args runs the demo
%    2009-09-28: Fixed edge-case problem reported by Swagat K
%    2009-05-28: corrected nargout behavior sugegsted by Andreas Gäb
%    2009-05-13: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>
%
% See also:
%    sprintf, fprintf

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.08 $  $Date: 2012/10/17 21:41:09 $

  persistent majorVersion minorVersion
  if isempty(majorVersion)
      %v = version; if str2double(v(1:3)) <= 7.1
      %majorVersion = str2double(regexprep(version,'^(\d+).*','$1'));
      %minorVersion = str2double(regexprep(version,'^\d+\.(\d+).*','$1'));
      %[a,b,c,d,versionIdStrs]=regexp(version,'^(\d+)\.(\d+).*');  %#ok unused
      v = sscanf(version, '%d.', 2);
      majorVersion = v(1); %str2double(versionIdStrs{1}{1});
      minorVersion = v(2); %str2double(versionIdStrs{1}{2});
  end

  % The following is for debug use only:
  %global docElement txt el
  if ~exist('el','var') || isempty(el),  el=handle([]);  end  %#ok mlint short-circuit error ("used before defined")
  if nargin<1, showDemo(majorVersion,minorVersion); return;  end
  if isempty(style),  return;  end
  if all(ishandle(style)) && length(style)~=3
      dumpElement(style);
      return;
  end

  % Process the text string
  if nargin<2, format = style; style='text';  end
  %error(nargchk(2, inf, nargin, 'struct'));
  %str = sprintf(format,varargin{:});

  % In compiled mode
  try useDesktop = usejava('desktop'); catch, useDesktop = false; end
  if isdeployed | ~useDesktop %#ok<OR2> - for Matlab 6 compatibility
      % do not display any formatting - use simple fprintf()
      % See: http://undocumentedmatlab.com/blog/bold-color-text-in-the-command-window/#comment-103035
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/1390a26e7ef4aa4d
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/13a6ed3223333b21
      count1 = fprintf(format,varargin{:});
  else
      % Else (Matlab desktop mode)
      % Get the normalized style name and underlining flag
      [underlineFlag, boldFlag, style] = processStyleInfo(style);

      % Set hyperlinking, if so requested
      if underlineFlag
          format = ['<a href="">' format '</a>'];

          % Matlab 7.1 R14 (possibly a few newer versions as well?)
          % have a bug in rendering consecutive hyperlinks
          % This is fixed by appending a single non-linked space
          if majorVersion < 7 || (majorVersion==7 && minorVersion <= 1)
              format(end+1) = ' ';
          end
      end

      % Set bold, if requested and supported (R2011b+)
      if boldFlag
          if (majorVersion > 7 || minorVersion >= 13)
              format = ['<strong>' format '</strong>'];
          else
              boldFlag = 0;
          end
      end

      % Get the current CW position
      cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
      lastPos = cmdWinDoc.getLength;

      % If not beginning of line
      bolFlag = 0;  %#ok
      %if docElement.getEndOffset - docElement.getStartOffset > 1
          % Display a hyperlink element in order to force element separation
          % (otherwise adjacent elements on the same line will be merged)
          if majorVersion<7 || (majorVersion==7 && minorVersion<13)
              if ~underlineFlag
                  fprintf('<a href=""> </a>');  %fprintf('<a href=""> </a>\b');
              elseif format(end)~=10  % if no newline at end
                  fprintf(' ');  %fprintf(' \b');
              end
          end
          %drawnow;
          bolFlag = 1;
      %end

      % Get a handle to the Command Window component
      mde = com.mathworks.mde.desk.MLDesktop.getInstance;
      cw = mde.getClient('Command Window');
      xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);

      % Store the CW background color as a special color pref
      % This way, if the CW bg color changes (via File/Preferences), 
      % it will also affect existing rendered strs
      com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);

      % Display the text in the Command Window
      count1 = fprintf(2,format,varargin{:});

      %awtinvoke(cmdWinDoc,'remove',lastPos,1);   % TODO: find out how to remove the extra '_'
      drawnow;  % this is necessary for the following to work properly (refer to Evgeny Pr in FEX comment 16/1/2011)
      docElement = cmdWinDoc.getParagraphElement(lastPos+1);
      if majorVersion<7 || (majorVersion==7 && minorVersion<13)
          if bolFlag && ~underlineFlag
              % Set the leading hyperlink space character ('_') to the bg color, effectively hiding it
              % Note: old Matlab versions have a bug in hyperlinks that need to be accounted for...
              %disp(' '); dumpElement(docElement)
              setElementStyle(docElement,'CW_BG_Color',1+underlineFlag,majorVersion,minorVersion); %+getUrlsFix(docElement));
              %disp(' '); dumpElement(docElement)
              el(end+1) = handle(docElement);  %#ok used in debug only
          end

          % Fix a problem with some hidden hyperlinks becoming unhidden...
          fixHyperlink(docElement);
          %dumpElement(docElement);
      end

      % Get the Document Element(s) corresponding to the latest fprintf operation
      while docElement.getStartOffset < cmdWinDoc.getLength
          % Set the element style according to the current style
          %disp(' '); dumpElement(docElement)
          specialFlag = underlineFlag | boldFlag;
          setElementStyle(docElement,style,specialFlag,majorVersion,minorVersion);
          %disp(' '); dumpElement(docElement)
          docElement2 = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
          if isequal(docElement,docElement2),  break;  end
          docElement = docElement2;
          %disp(' '); dumpElement(docElement)
      end

      % Force a Command-Window repaint
      % Note: this is important in case the rendered str was not '\n'-terminated
      xCmdWndView.repaint;

      % The following is for debug use only:
      el(end+1) = handle(docElement);  %#ok used in debug only
      %elementStart  = docElement.getStartOffset;
      %elementLength = docElement.getEndOffset - elementStart;
      %txt = cmdWinDoc.getText(elementStart,elementLength);
  end

  if nargout
      count = count1;
  end
  return;  % debug breakpoint

% Process the requested style information
function [underlineFlag,boldFlag,style] = processStyleInfo(style)
  underlineFlag = 0;
  boldFlag = 0;

  % First, strip out the underline/bold markers
  if ischar(style)
      % Styles containing '-' or '_' should be underlined (using a no-target hyperlink hack)
      %if style(1)=='-'
      underlineIdx = (style=='-') | (style=='_');
      if any(underlineIdx)
          underlineFlag = 1;
          %style = style(2:end);
          style = style(~underlineIdx);
      end

      % Check for bold style (only if not underlined)
      boldIdx = (style=='*');
      if any(boldIdx)
          boldFlag = 1;
          style = style(~boldIdx);
      end
      if underlineFlag && boldFlag
          warning('YMA:cprintf:BoldUnderline','Matlab does not support both bold & underline')
      end

      % Check if the remaining style sting is a numeric vector
      %styleNum = str2num(style); %#ok<ST2NM>  % not good because style='text' is evaled!
      %if ~isempty(styleNum)
      if any(style==' ' | style==',' | style==';')
          style = str2num(style); %#ok<ST2NM>
      end
  end

  % Style = valid matlab RGB vector
  if isnumeric(style) && length(style)==3 && all(style<=1) && all(abs(style)>=0)
      if any(style<0)
          underlineFlag = 1;
          style = abs(style);
      end
      style = getColorStyle(style);

  elseif ~ischar(style)
      error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

  % Style name
  else
      % Try case-insensitive partial/full match with the accepted style names
      validStyles = {'Text','Keywords','Comments','Strings','UnterminatedStrings','SystemCommands','Errors', ...
                     'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White', ...
                     'Hyperlinks'};
      matches = find(strncmpi(style,validStyles,length(style)));

      % No match - error
      if isempty(matches)
          error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

      % Too many matches (ambiguous) - error
      elseif length(matches) > 1
          error('YMA:cprintf:AmbigStyle','Ambiguous style name - supply extra characters for uniqueness')

      % Regular text
      elseif matches == 1
          style = 'ColorsText';  % fixed by Danilo, 29/8/2011

      % Highlight preference style name
      elseif matches < 8
          style = ['Colors_M_' validStyles{matches}];

      % Color name
      elseif matches < length(validStyles)
          colors = [0,0,0; 0,1,1; 1,0,1; 0,0,1; 0,1,0; 1,0,0; 1,1,0; 1,1,1];
          requestedColor = colors(matches-7,:);
          style = getColorStyle(requestedColor);

      % Hyperlink
      else
          style = 'Colors_HTML_HTMLLinks';  % CWLink
          underlineFlag = 1;
      end
  end

% Convert a Matlab RGB vector into a known style name (e.g., '[255,37,0]')
function styleName = getColorStyle(rgb)
  intColor = int32(rgb*255);
  javaColor = java.awt.Color(intColor(1), intColor(2), intColor(3));
  styleName = sprintf('[%d,%d,%d]',intColor);
  com.mathworks.services.Prefs.setColorPref(styleName,javaColor);

% Fix a bug in some Matlab versions, where the number of URL segments
% is larger than the number of style segments in a doc element
function delta = getUrlsFix(docElement)  %#ok currently unused
  tokens = docElement.getAttribute('SyntaxTokens');
  links  = docElement.getAttribute('LinkStartTokens');
  if length(links) > length(tokens(1))
      delta = length(links) > length(tokens(1));
  else
      delta = 0;
  end

% fprintf(2,str) causes all previous '_'s in the line to become red - fix this
function fixHyperlink(docElement)
  try
      tokens = docElement.getAttribute('SyntaxTokens');
      urls   = docElement.getAttribute('HtmlLink');
      urls   = urls(2);
      links  = docElement.getAttribute('LinkStartTokens');
      offsets = tokens(1);
      styles  = tokens(2);
      doc = docElement.getDocument;

      % Loop over all segments in this docElement
      for idx = 1 : length(offsets)-1
          % If this is a hyperlink with no URL target and starts with ' ' and is collored as an error (red)...
          if strcmp(styles(idx).char,'Colors_M_Errors')
              character = char(doc.getText(offsets(idx)+docElement.getStartOffset,1));
              if strcmp(character,' ')
                  if isempty(urls(idx)) && links(idx)==0
                      % Revert the style color to the CW background color (i.e., hide it!)
                      styles(idx) = java.lang.String('CW_BG_Color');
                  end
              end
          end
      end
  catch
      % never mind...
  end

% Set an element to a particular style (color)
function setElementStyle(docElement,style,specialFlag, majorVersion,minorVersion)
  %global tokens links urls urlTargets  % for debug only
  global oldStyles
  if nargin<3,  specialFlag=0;  end
  % Set the last Element token to the requested style:
  % Colors:
  tokens = docElement.getAttribute('SyntaxTokens');
  try
      styles = tokens(2);
      oldStyles{end+1} = styles.cell;

      % Correct edge case problem
      extraInd = double(majorVersion>7 || (majorVersion==7 && minorVersion>=13));  % =0 for R2011a-, =1 for R2011b+
      %{
      if ~strcmp('CWLink',char(styles(end-hyperlinkFlag))) && ...
          strcmp('CWLink',char(styles(end-hyperlinkFlag-1)))
         extraInd = 0;%1;
      end
      hyperlinkFlag = ~isempty(strmatch('CWLink',tokens(2)));
      hyperlinkFlag = 0 + any(cellfun(@(c)(~isempty(c)&&strcmp(c,'CWLink')),tokens(2).cell));
      %}

      styles(end-extraInd) = java.lang.String('');
      styles(end-extraInd-specialFlag) = java.lang.String(style);  %#ok apparently unused but in reality used by Java
      if extraInd
          styles(end-specialFlag) = java.lang.String(style);
      end

      oldStyles{end} = [oldStyles{end} styles.cell];
  catch
      % never mind for now
  end
  
  % Underlines (hyperlinks):
  %{
  links = docElement.getAttribute('LinkStartTokens');
  if isempty(links)
      %docElement.addAttribute('LinkStartTokens',repmat(int32(-1),length(tokens(2)),1));
  else
      %TODO: remove hyperlink by setting the value to -1
  end
  %}

  % Correct empty URLs to be un-hyperlinkable (only underlined)
  urls = docElement.getAttribute('HtmlLink');
  if ~isempty(urls)
      urlTargets = urls(2);
      for urlIdx = 1 : length(urlTargets)
          try
              if urlTargets(urlIdx).length < 1
                  urlTargets(urlIdx) = [];  % '' => []
              end
          catch
              % never mind...
              a=1;  %#ok used for debug breakpoint...
          end
      end
  end
  
  % Bold: (currently unused because we cannot modify this immutable int32 numeric array)
  %{
  try
      %hasBold = docElement.isDefined('BoldStartTokens');
      bolds = docElement.getAttribute('BoldStartTokens');
      if ~isempty(bolds)
          %docElement.addAttribute('BoldStartTokens',repmat(int32(1),length(bolds),1));
      end
  catch
      % never mind - ignore...
      a=1;  %#ok used for debug breakpoint...
  end
  %}
  
  return;  % debug breakpoint

% Display information about element(s)
function dumpElement(docElements)
  %return;
  numElements = length(docElements);
  cmdWinDoc = docElements(1).getDocument;
  for elementIdx = 1 : numElements
      if numElements > 1,  fprintf('Element #%d:\n',elementIdx);  end
      docElement = docElements(elementIdx);
      if ~isjava(docElement),  docElement = docElement.java;  end
      %docElement.dump(java.lang.System.out,1)
      disp(' ');
      disp(docElement)
      tokens = docElement.getAttribute('SyntaxTokens');
      if isempty(tokens),  continue;  end
      links = docElement.getAttribute('LinkStartTokens');
      urls  = docElement.getAttribute('HtmlLink');
      try bolds = docElement.getAttribute('BoldStartTokens'); catch, bolds = []; end
      txt = {};
      tokenLengths = tokens(1);
      for tokenIdx = 1 : length(tokenLengths)-1
          tokenLength = diff(tokenLengths(tokenIdx+[0,1]));
          if (tokenLength < 0)
              tokenLength = docElement.getEndOffset - docElement.getStartOffset - tokenLengths(tokenIdx);
          end
          txt{tokenIdx} = cmdWinDoc.getText(docElement.getStartOffset+tokenLengths(tokenIdx),tokenLength).char;  %#ok
      end
      lastTokenStartOffset = docElement.getStartOffset + tokenLengths(end);
      txt{end+1} = cmdWinDoc.getText(lastTokenStartOffset, docElement.getEndOffset-lastTokenStartOffset).char;  %#ok
      %cmdWinDoc.uiinspect
      %docElement.uiinspect
      txt = strrep(txt',sprintf('\n'),'\n');
      try
          data = [tokens(2).cell m2c(tokens(1)) m2c(links) m2c(urls(1)) cell(urls(2)) m2c(bolds) txt];
          if elementIdx==1
              disp('    SyntaxTokens(2,1) - LinkStartTokens - HtmlLink(1,2) - BoldStartTokens - txt');
              disp('    ==============================================================================');
          end
      catch
          try
              data = [tokens(2).cell m2c(tokens(1)) m2c(links) txt];
          catch
              disp([tokens(2).cell m2c(tokens(1)) txt]);
              try
                  data = [m2c(links) m2c(urls(1)) cell(urls(2))];
              catch
                  % Mtlab 7.1 only has urls(1)...
                  data = [m2c(links) urls.cell];
              end
          end
      end
      disp(data)
  end

% Utility function to convert matrix => cell
function cells = m2c(data)
  %datasize = size(data);  cells = mat2cell(data,ones(1,datasize(1)),ones(1,datasize(2)));
  cells = num2cell(data);

% Display the help and demo
function showDemo(majorVersion,minorVersion)
  fprintf('cprintf displays formatted text in the Command Window.\n\n');
  fprintf('Syntax: count = cprintf(style,format,...);  click <a href="matlab:help cprintf">here</a> for details.\n\n');
  url = 'http://UndocumentedMatlab.com/blog/cprintf/';
  fprintf(['Technical description: <a href="' url '">' url '</a>\n\n']);
  fprintf('Demo:\n\n');
  boldFlag = majorVersion>7 || (majorVersion==7 && minorVersion>=13);
  s = ['cprintf(''text'',    ''regular black text'');' 10 ...
       'cprintf(''hyper'',   ''followed %s'',''by'');' 10 ...
       'cprintf(''key'',     ''%d colored'',' num2str(4+boldFlag) ');' 10 ...
       'cprintf(''-comment'',''& underlined'');' 10 ...
       'cprintf(''err'',     ''elements:\n'');' 10 ...
       'cprintf(''cyan'',    ''cyan'');' 10 ...
       'cprintf(''_green'',  ''underlined green'');' 10 ...
       'cprintf(-[1,0,1],  ''underlined magenta'');' 10 ...
       'cprintf([1,0.5,0], ''and multi-\nline orange\n'');' 10];
   if boldFlag
       % In R2011b+ the internal bug that causes the need for an extra space
       % is apparently fixed, so we must insert the sparator spaces manually...
       % On the other hand, 2011b enables *bold* format
       s = [s 'cprintf(''*blue'',   ''and *bold* (R2011b+ only)\n'');' 10];
       s = strrep(s, ''')',' '')');
       s = strrep(s, ''',5)',' '',5)');
       s = strrep(s, '\n ','\n');
   end
   disp(s);
   eval(s);


%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%
% - Fix: Remove leading space char (hidden underline '_')
% - Fix: Find workaround for multi-line quirks/limitations
% - Fix: Non-\n-terminated segments are displayed as black
% - Fix: Check whether the hyperlink fix for 7.1 is also needed on 7.2 etc.
% - Enh: Add font support


function not_empty = isnt_empty_field(obj, fieldname, varargin)

%
% isnt_empty_field.m
%   
%   copyright 2024, Vulintus, Inc.
%
%   ISNT_EMPTY_FIELD is a recursive function that checks if the all of 
%   specified fields/subfields exist in the in the specified structure 
%   ("structure"), and then checks if the last subfield is empty.
%
%   UPDATE LOG:
%   2024-08-27 - Drew Sloan - Function first created.
%   2024-11-11 - Drew Sloan - Created complementary function
%                             "is_empty_field" to check for the reverse
%                             case.
%   2025-02-17 - Drew Sloan - Added an "isprop" check to be able to check
%                             class properties like structure fields.
%


switch class(obj)                                                           %Switch between the different recognized classes.
    case 'struct'                                                           %Structure.
        not_empty = isfield(obj, fieldname);                                %Check to see if the fieldname exists.
    case {'Vulintus_Behavior_Class','Vulintus_OTSC_Handler','datetime'}     %Vulintus classes.
        not_empty = isprop(obj, fieldname);                                 %Check to see if the property exists.     
    otherwise                                                               %For all other cases...
        not_empty = ~isempty(obj);                                          %Check to see if the object is empty.                   
end
if ~not_empty                                                               %If the field doesn't exist...
    return                                                                  %Skip the rest of the function.
end

if nargin == 2 || isempty(varargin)                                         %If only one field name was passed...    
    if (not_empty)                                                          %If the field exists...
        not_empty = ~isempty(obj.(fieldname));                              %Check to see if the field isn't empty.
    end
elseif nargin == 3                                                          %If a field name and one subfield name was passed...
    not_empty = isnt_empty_field(obj.(fieldname),varargin{1});              %Recursively call this function to check the subfield.
else                                                                        %Otherwise...
    not_empty = isnt_empty_field(obj.(fieldname),varargin{1},...
        varargin{2:end});                                                   %Recursively call this function to handle all subfields.
end


