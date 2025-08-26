function OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_VIBROTACTILE_DETECTION_TASK_TRIAL writes
%   data from individual trials of the SensiTrak vibrotactile detection
%   task to the *.OmniTrak file.
%
%		BLOCK VALUE:	0x0A8D
%		DEFINITION:		VIBROTACTILE_DETECTION_TASK_TRIAL
%		DESCRIPTION:	Vibrotactile detection task trial data.
%
%   UPDATE LOG:
%   2024-12-04 - Drew Sloan - Function first created.
%

behavior = varargin{1};                                                     %The behavior structure will be the first optional input argument.

data_block_version = 1;                                                     %Set the data block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %FR_TASK_TRIAL block version.

fwrite(fid,behavior.session.count.trial,'uint16');                          %Trial number.
fwrite(fid,datenum(behavior.session.trial(end).time.start.datetime),...
    'float64');                                                             %#ok<DATNM> %Start time of the trial
fwrite(fid,behavior.session.trial(end).outcome(1),'uchar');                 %Trial outcome as an unsigned character.
fwrite(fid,numel(behavior.session.trial(end).time.reward),'uint8');         %Number of feedings.
if ~isempty(behavior.session.trial(end).time.reward)                        %If there were any feedings...
    fwrite(fid,datenum(behavior.session.trial(end).time.reward),...
        'float64');                                                         %#ok<DATNM> %serial date number timestamp for every feeding.
end
fwrite(fid,behavior.session.params.hitwin,'float32');                       %hit window duration, in seconds.
for f = {'vib_dur',...
        'vib_rate',...
        'actual_vib_rate',...
        'gap_length',...
        'actual_gap_length',...
        'hold_time',...
        'time_held'}                                                        %Step through various fields of the trial structure.
    fwrite(fid,behavior.session.trial(end).params.(f{1}),'float32');        %Write each field value as a 32-bit float.
end
for f = {'vib_n',...
        'gap_start',...
        'gap_stop'}                                                         %Step through various fields of the trial structure.
    fwrite(fid,behavior.session.trial(end).params.(f{1}),'uint16');         %Write each field value as an unsigned 16-bit integer.
end
fwrite(fid,length(behavior.session.params.pre_sample_index),'uint32');      %number of pre-trial samples.
signal = behavior.session.trial(end).signal.force.read();                   %Read the signal from the buffer.
fwrite(fid,size(signal,1)-1,'uint8');                                       %Number of data streams (besides the timestamp).
fwrite(fid,size(signal,2),'uint32');                                        %Number of samples.
behavior.session.trial(end).signal = ...
    rmfield(behavior.session.trial(end).signal,'force');                    %Remove the buffer from the trial.
fwrite(fid,signal(1,:),'uint32');                                           %Microsecond clock timestamps.
for i = 2:size(signal,1)                                                    %Step through the other signals in the buffer.         
    fwrite(fid,signal(i,:),'float32');                                      %Filtered and raw force values.
end