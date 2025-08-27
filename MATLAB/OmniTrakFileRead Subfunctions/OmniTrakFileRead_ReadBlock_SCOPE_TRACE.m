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
%       2025-06-19 - Drew Sloan - Function first created.
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
