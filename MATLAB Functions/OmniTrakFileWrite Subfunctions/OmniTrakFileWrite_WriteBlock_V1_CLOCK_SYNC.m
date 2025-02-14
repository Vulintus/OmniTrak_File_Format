function OmniTrakFileWrite_WriteBlock_V1_CLOCK_SYNC(fid, block_code, port_i, varargin)

%
% OmniTrakFileWrite_WriteBlock_V1_CLOCK_SYNC.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_CLOCK_SYNC writes the current serial date 
%   number, millisecond clock reading, and/or microsecond clock reading at a 
%   single timepoint to assist in timestamp synchronization in an *.OmniTrak 
%   file.  
%
%   OFBC block code: 0x0016
%
%   UPDATE LOG:
%   2025-02-13 - Drew Sloan - Function first created.
%

bitmask = 0;                                                                %Initialize a bitmask to indicate which timestamp types are present.
for i = 1:2:numel(varargin)                                                 %Step through each input argument.
    switch lower(varargin{i})                                               %Switch between the input arguments.
        case 'datenum'                                                      %Serial date number.
            serial_date = varargin{i+1};                                    %Grab the timestamp.
            bitmask = bitset(bitmask,1);                                    %Update the bitmask.
        case 'millis'                                                       %Millisecond clock reading.
            millis = varargin{i+1};                                         %Grab the timestamp.
            bitmask = bitset(bitmask,2);                                    %Update the bitmask.
        case 'micros'                                                       %Microsecond clock reading.
            micros = varargin{i+1};                                         %Grab the timestamp.
            bitmask = bitset(bitmask,3);                                    %Update the bitmask.
        otherwise                                                           %If the input argument isn't recognized...
            error('ERROR IN %s: Unrecognized timestamp type "%s"!',...
                upper(mfilename), varargin{i});                             %Throw an error.
    end
end

if bitmask == 0                                                             %If no timestamps were provided...
    return;                                                                 %Return without writing anything.
end

data_block_version = 1;                                                     %Set the TTL_PULSE block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Block version.
fwrite(fid,port_i,'uint8');                                                 %Port number.
fwrite(fid,bitmask,'uint8');                                                %Bitmask indicating which timestamps are present.

if bitget(bitmask,1)                                                        %If the serial date number is present...
    fwrite(fid,serial_date,'float64');                                      %Write the serial date number.
end
if bitget(bitmask,2)                                                        %If the millisecond clock reading is present...
    fwrite(fid,millis,'uint32');                                            %Write the millisecond clock reading.
end
if bitget(bitmask,3)                                                        %If the microsecond clock reading is present...
    fwrite(fid,micros,'uint32');                                            %Write the microsecond clock reading.
end