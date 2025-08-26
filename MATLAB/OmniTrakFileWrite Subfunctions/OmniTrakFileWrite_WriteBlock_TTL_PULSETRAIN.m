function OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN(fid, block_code, timestamp, chan, volts, pulse_dur, pulse_ipi, pulse_num)

%
% OmniTrakFileWrite_WriteBlock_TTL_PULSETRAIN.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_TTL_PULSETRAIN writes the channel, 
%   timestamp, voltage, pulse duration, offset-to-onset inter-pulse 
%   interval, and number of pulses for a TTL pulsetrain when one is sent 
%   during a behavioral program.
%
%   OFBC block code: 0x0800
%
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%   2025-08-25 - Drew Sloan - Created new block version (2) to handle 
%                             pulsetrains in addition to single pulses.
%

data_block_version = 2;                                                     %Set the TTL_PULSETRAIN block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Write the TTL_PULSETRAIN block version.

fwrite(fid, timestamp, 'float64');                                          %TTL pulse onset timestamp (serial date number).
fwrite(fid, chan, 'uint8');                                                 %Stimulation channel.
fwrite(fid, volts, 'float32');                                              %Output pulse voltage.
fwrite(fid, pulse_dur, 'float32');                                          %Duration of the output pulse, in seconds.
if isempty(pulse_ipi) || isnan(pulse_ipi)                                   %If there's no valid inter-pulse interval...
    fwrite(fid, 0, 'float32');                                              %Write a zero for the interpulse interval.
else                                                                        %Otherwise...
    fwrite(fid, pulse_ipi, 'float32');                                      %Offset-to-onset interpulse interval, in seconds.
end
if isempty(pulse_num) || isnan(pulse_num)                                   %If there's no valid inter-pulse interval...
    fwrite(fid, 1, 'uint16');                                               %Write a one for the number of pulse.
else                                                                        %Otherwise...
    fwrite(fid, pulse_num, 'uint16');                                       %Number of pulses in the pulsetrain.
end                        