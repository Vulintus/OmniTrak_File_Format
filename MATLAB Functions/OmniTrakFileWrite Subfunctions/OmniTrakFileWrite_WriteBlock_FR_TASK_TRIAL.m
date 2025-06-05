function OmniTrakFileWrite_WriteBlock_FR_TASK_TRIAL(fid, block_code, behavior)

%
% OmniTrakFileWrite_WriteBlock_FR_TASK_TRIAL.m
%   
%   copyright 2023, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_FR_TASK_TRIAL writes data from
%   individual trials of the Fixed Reinforcement task.
%
%   OFBC block code: 0x0AF0
%
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %Set the FR_TASK_TRIAL block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %Write the FR_TASK_TRIAL block version.

fwrite(fid, behavior.session.count.trial, 'uint16');                        %Trial number.

dt = behavior.session.trial(end).time.start.datetime;                       %Grab the trial start time.
fwrite(fid, datenum(dt), 'float64');                                        %#ok<DATNM> %Trial start timestamp (serial date number).

fwrite(fid, behavior.session.trial(end).outcome(1), 'uchar');               %Trial outcome.

poke_i = behavior.session.trial(end).params.target_poke;                    %Grab the target poke index.
fwrite(fid, poke_i, 'uint8');                                               %Target nosepoke.
fwrite(fid, behavior.session.params.thresh, 'uint8');                       %Required number of pokes.
fwrite(fid, behavior.session.trial(end).count.nosepoke(poke_i), 'uint16');  %Poke count.

if isempty(behavior.session.trial(end).time.reward)                         %If no reward was delivered...
    fwrite(fid, 0, 'float32');                                              %Hit time (0 for misses).
else                                                                        %Otherwise...
    fwrite(fid, behavior.session.trial(end).time.reward(1), 'float32');     %Hit time.
end

fwrite(fid, behavior.session.params.reward_dur, 'float32');                 %Reward window duration (lick availability), in seconds.
fwrite(fid, behavior.session.trial(end).count.lick, 'uint16');              %Number of licks after the hit.
fwrite(fid, length(behavior.session.trial(end).time.reward), 'uint16');     %Total reward count.