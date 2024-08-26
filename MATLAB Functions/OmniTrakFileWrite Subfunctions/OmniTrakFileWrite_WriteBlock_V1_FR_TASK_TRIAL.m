function OmniTrakFileWrite_WriteBlock_V1_FR_TASK_TRIAL(fid, block_code, behavior, trial, licks)

%
%OmniTrakFileWrite_WriteBlock_V1_FR_TASK_TRIAL.m - Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_FR_TASK_TRIAL writes data from
%   individual trials of the Fixed Reinforcement task.
%
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %Set the FR_TASK_TRIAL block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %Write the FR_TASK_TRIAL block version.

fwrite(fid, behavior.session.TrialCount, 'uint16');                         %Trial number.
fwrite(fid, datenum(trial.StartTime), 'float64');                           %Trial start timestamp (serial date number).
fwrite(fid, trial.Outcome(1), 'uchar');                                     %Trial outcome.
fwrite(fid, trial.params.target_poke, 'uint8');                             %Target nosepoke.
fwrite(fid, behavior.session.params.thresh, 'uint8');                       %Required number of pokes.
fwrite(fid, max(trial.signal.plot(:,2)), 'uint16');                         %Poke count.
fwrite(fid, trial.HitTime, 'float32');                                      %Hit time (0 for misses).
fwrite(fid, behavior.session.params.reward_dur, 'float32');                 %Reward window duration (lick availability), in seconds.
fwrite(fid, length(licks), 'uint16');                                       %Number of licks after the hit.
for i = 1:length(licks)                                                     %Step through each lick.
    fwrite(fid, licks(i), 'float32');                                       %Write each lick time.
end
fwrite(fid, behavior.session.FeedCount, 'uint16');                          %Total Feed count.