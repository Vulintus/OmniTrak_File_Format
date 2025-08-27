function data =  OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN_ABORT(fid,data)

%
% OmniTrakFileRead_ReadBlock_TTL_PULSETRAIN_ABORT.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_TTL_PULSETRAIN_ABORT reads in the 
%   "SESSION_PARAMS_JSON" data block from an *.OmniTrak format file. This 
%   block is intended to contain the fields and values of the "params"
%   field from the Vulintus_Behavior_Session_Class of a behavioral program
%   instance. This block is intended to be a failsafe cpaturing all session
%   parameters in case pertinent parameters are omitted from other data
%   blocks.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0801
%		DEFINITION:		TTL_PULSETRAIN_ABORT
%		DESCRIPTION:	Timestamped event for when a TTL pulsetrain is 
%                       canceled before completion.
%
%   UPDATE LOG:
%       2025-08-26 - Drew Sloan - Function first created.
%


data = OmniTrakFileRead_Check_Field_Name(data,'ttl');                       %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the TTL_PULSETRAIN data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1 (implemented 2025-08-25).        
        src = fread(fid,1,'uint8')';                                        %Device "port" number.
        chan = fread(fid,1,'uint8')';                                       %Output channel.
        i = find(vertcat(data.ttl.src) == src & ...
            vertcat(data.ttl.chan) == chan,1,'last');                       %Find the last TTL event index for this device and channel.
        if isempty(i)                                                       %If no match was found...
            i = length(data.ttl) + 1;                                       %Increment the TTL pulse index.
            data.ttl(i).src = src;                                          %Save the device "port" number.
            data.ttl(i).chan = chan;                                        %Save the channel number.
        end
        datatype_mask = fread(fid,1,'uint8')';                              %Bitmask indicating included data types.
        if bitget(datatype_mask,1)                                          %Bitmask bit 1.
            data.ttl(i).stop.datenum = fread(fid,1,'float64');              %Serial date number.
        end
        if bitget(datatype_mask,2)                                          %Bitmask bit 2.
            data.ttl(i).stop.millis = fread(fid,1,'uint32');                %Serial date number.
        end
        train_dur = [];                                                     %Create a variable to hold the train duration.
        if isnt_empty_field(data.ttl(i),'start','millis') && ...
                isnt_empty_field(data.ttl(i),'stop','millis')             %If microcontroller millisecond clock readings are available for the TTL start and stop.
            train_dur = data.ttl(i).stop.millis - data.ttl(i).start.millis; %Calculate the pulsetrain duration in milliseconds.
            train_dur = double(train_dur)/1000;                             %Convert the train duration to seconds.
        elseif isnt_empty_field(data.ttl(i),'start','datenum') && ...
                isnt_empty_field(data.ttl(i),'stop','datenum')              %If serial date numbers are available for the TTL start and stop.
            train_dur = 86400*(data.ttl(i).stop.datenum - ...
                data.ttl(i).start.datenum);                                 %Calculate the pulsetrain duration in milliseconds.
        end
        if ~isempty(train_dur)                                              %If a train duration could be calculated.
            if isnt_empty_field(data.ttl(i),'pulse_dur')                    %If a pulse duration was saved...
                if train_dur < data.ttl(i).pulse_dur                        %If the TTL pulsetrain was aborted before a single pulse completed...
                    data.ttl(i).pulse_dur = train_dur;                      %Set the pulse duration to the train duration.
                    data.ttl(i).pulse_n = 1;                                %Set the pulse duration to the train duration.
                elseif isnt_empty_field(data.ttl(i),'pulse_ipi')            %If an inter-pulse interval was saved...
                    ipp = data.ttl(i).pulse_dur + data.ttl(i).pulse_ipi;    %Find the full pulse period.
                    data.ttl(i).pulse_n = ceil(train_dur/ipp);              %Update the pulse count.
                end
            end
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end