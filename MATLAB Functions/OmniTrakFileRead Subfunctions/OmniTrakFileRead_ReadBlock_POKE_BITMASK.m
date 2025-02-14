function data = OmniTrakFileRead_ReadBlock_POKE_BITMASK(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2560
%		DEFINITION:		POKE_BITMASK
%		DESCRIPTION:	Nosepoke status bitmask, typically written only when it changes.

ver = fread(fid,1,'uint8');                                                 %#ok<NASGU> %Data block version.

data = OmniTrakFileRead_Check_Field_Name(data,'poke',...
    {'datenum','micros','status'});                                         %Call the subfunction to check for existing fieldnames.         
j = size(data.poke.datenum,1) + 1;                                          %Find the next index for the pellet timestamp for this dispenser.
if isempty(data.poke.datenum)                                               %If the serial date number timestamp field is empty...
    data.poke.datenum = NaN;                                                %Initialize the field with a NaN.
end
data.poke.datenum(j,1) = fread(fid,1,'float64');                            %Save the serial date number timestamp.
if isempty(data.poke.micros)                                                %If the microcontroller microsecond timestamp field is empty...
    data.poke.micros = NaN;                                                 %Initialize the field with a NaN.
end
data.poke.micros(j,1) = fread(fid,1,'float32');                             %Save the microcontroller microsecond timestamp.
num_pokes = fread(fid,1,'uint8');                                           %Read in the number of nosepokes.
poke_mask = fread(fid,1,'uint8');                                           %Read in the nosepoke bitmask.
poke_status = zeros(1,num_pokes);                                           %Create a matrix to hold the nosepoke status.
for i = 1:num_pokes                                                         %Step through each nosepoke.
    poke_status(i) = bitget(poke_mask,i);                                   %Grab the status for each nosepoke.
end
if j == 1                                                                   %If this is the first nosepoke event...
    data.poke.status = poke_status;                                         %Create the status matrix.
else                                                                        %Otherwise...
    data.poke.status(j,:) = poke_status;                                    %Add the new status to the matrix.
end