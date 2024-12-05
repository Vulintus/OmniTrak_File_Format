function OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL.m
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_VIBROTACTILE_DETECTION_TASK_TRIAL writes
%   data from individual trials of the Fixed Reinforcement task.
%
%   OFBC block code: 0x0A8D
%
%   UPDATE LOG:
%   2024-12-04 - Drew Sloan - Function first created.
%

behavior = varargin{1};
trial = varargin{2};

data_block_version = 1;                                                     %Set the FR_TASK_TRIAL block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %Write the FR_TASK_TRIAL block version.

fwrite(fid,behavior.session.params.trial_num,'uint16');                     %Write the trial number.
fwrite(fid,trial.params.start_time,'float64');                              %Write the start time of the trial.
fwrite(fid,trial.params.outcome(1),'uchar');                                %Write the trial outcome as an unsigned character.
fwrite(fid,numel(trial.params.feed_time),'uint8');                          %Write the number of feedings.
if ~isempty(trial.params.feed_time)                                         %If there were any feedings...
    fwrite(fid,trial.params.feed_time,'float64');                           %Write the serial date number timestamp for every feeding.
end
fwrite(fid,behavior.session.params.hitwin,'float32');                       %Write the hit window duration, in seconds.
for f = {'vib_dur',...
        'vib_rate',...
        'actual_vib_rate',...
        'gap_length',...
        'actual_gap_length',...
        'hold_time',...
        'time_held'}                                                        %Step through various fields of the trial structure.
    fwrite(fid,trial.params.(f{1}),'float32');                              %Write each field value as a 32-bit float.
end
for f = {'vib_n',...
        'gap_start',...
        'gap_stop'}                                                         %Step through various fields of the trial structure.
    fwrite(fid,trial.params.(f{1}),'uint16');                               %Write each field value as an unsigned 16-bit integer.
end
fwrite(fid,1000*behavior.session.params.pre_trial_sampling/...
    behavior.session.params.period,'uint32');                               %Write the number of pre-trial samples.
fwrite(fid,2,'uint8');                                                      %Number of data streams (besides the timestamp).
fwrite(fid,trial.params.signal_index,'uint32');                             %Write the number of samples in the buffer.
fwrite(fid,trial.params.signal(1:trial.params.signal_index,1),'uint32');    %Write the microsecond clock timestamps.
fwrite(fid,trial.params.signal(1:trial.params.signal_index,2),'float32');   %Write the force values.
fwrite(fid,trial.params.signal(1:trial.params.signal_index,3),'float32');   %Write the touch sensor values