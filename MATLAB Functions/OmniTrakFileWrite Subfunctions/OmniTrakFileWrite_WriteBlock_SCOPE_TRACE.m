function OmniTrakFileWrite_WriteBlock_SCOPE_TRACE(fid, block_code, times, signal, params)

%
% OmniTrakFileWrite_WriteBlock_SCOPE_TRACE.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_SCOPE_TRACE writes a single oscilloscope 
%   recording, in units of volts, from one or multiple channels, with time
%   units in seconds, along with a variable number of parameters describing
%   the recording conditions.
%
%   OFBC block code: 0x00x089CAF0
%
%   UPDATE LOG:
%   2025-06-18 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %Set the SCOPE_TRACE block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %Write the SCOPE_TRACE block version.

param_fields = fieldnames(params)';                                         %Grab all of the parameter fields.
fwrite(fid, length(param_fields), 'uint8');                                 %Number of parameter fields.
for fld = param_fields                                                      %Step through each parameter field.
    fwrite(fid,length(fld{1}),'uint8');                                     %Number of characters in the field name.
    fwrite(fid,fld{1},'uchar');                                             %Characters of the field name.
    fwrite(fid,params.(fld{1}),'float64');                                  %Write each field value as a double.
end

if size(signal,1) > size(signal,2)                                          %If the signals are oriented vertically.
    signal = signal';                                                       %Traspose them.
end
if size(signal,2) > length(times)                                           %If there's more signal samples than times...
    signal(:,(length(x) + 1):end) = [];                                     %Kick out the extra samples.
elseif size(signal,2) < length(times)                                       %If there's more times than signal samples...
    times((size(signal,2)+1):end) = [];                                     %Kick out the extra times.
end

fwrite(fid,size(signal,2),'uint64');                                        %Write the number of samples.
fwrite(fid,size(signal,1),'uint8');                                         %Write the number of signals.
fwrite(fid,times,'float32');                                                %Write the times in single precision.
for i = 1:size(signal,1)                                                    %Step through each sample...
    fwrite(fid,signal(i,:),'float32');                                      %Write the samples in single precision.
end