function OmniTrakFileWrite_WriteBlock_V1_FR_TASK_TRIAL(fid, block_code, trial, session)

%
%OmniTrakFileWrite_WriteBlock_V1_FR_TASK_TRIAL.m - Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_V1_FR_TASK_TRIAL writes data from
%   individual trials of the Fixed Reinforcement task.
%
%   UPDATE LOG:
%   2024-04-23 - Drew Sloan - Function first created.
%

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,session.ofbc_block_version,'uint16');                            %Write the FR_TASK_TRIAL block version.

switch session.ofbc_block_version                                           %Switch between the different block versions.
    
    case 1                                                                  %FR_TASK_TRIAL block version 1.
        fwrite(fid, session.trial_num, 'uint16');                           %Trial number.
        fwrite(fid, trial.timestamp, 'float64');                            %Trial start timestamp (serial date number).      
        fwrite(fid, trial.target_poke, 'uint8');                            %Target nosepoke.
        fwrite(fid, max(trial.plot_signal(:,2)), 'uint16');                 %Poke count.
        fwrite(fid, trial.hit_time, 'float32');                             %Hit time.
        fwrite(fid, session.feedings, 'uint16');                            %Feed count.

end