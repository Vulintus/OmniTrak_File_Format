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