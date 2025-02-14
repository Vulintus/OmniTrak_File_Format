function OmniTrakFileWrite_WriteBlock_TTL_PULSE(fid, block_code, timestamp, chan, volts, dur)

%
% OmniTrakFileWrite_WriteBlock_TTL_PULSE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_TTL_PULSE writes the channel, 
%   timestamp, voltage, and duration (in milliseconds) of a TTL pulse when
%   one is sent during a behavioral program.
%
%   OFBC block code: 0x0800
%
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %Set the TTL_PULSE block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Write the TTL_PULSE block version.

fwrite(fid, timestamp, 'float64');                                          %TTL pulse onset timestamp (serial date number).
fwrite(fid, chan, 'uint8');                                                 %Stimulation channel.
fwrite(fid, volts, 'float32');                                              %Output pulse voltage.
fwrite(fid, dur, 'uint32');                                                 %Duration of the output pulse, in milliseconds.