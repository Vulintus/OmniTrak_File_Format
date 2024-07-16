function OmniTrakFileWrite_WriteBlock_V1_STOP_TASK_TRIAL (fid, block_code, trial, session)
    %
    % OmniTrakFileWrite_WriteBlock_V1_Stop_Task_Trial.m - Vulintus, Inc.
    %
    %   OmniTrakFileWrite_WriteBlock_V1_Stop_Task_Trial writes data from
    %   individual trials of the STOP task.
    %
    %   UPDATE LOG:
    %   2024-07-15 - David Pruitt - Function first created.
    %

    %Set the "STOP task" trial block version.
    data_block_version = 1;                                                     

    %OmniTrak file format block code.
    fwrite(fid, block_code, 'uint16');                                          
    
    %Write the "STOP task" trial block version.
    fwrite(fid, data_block_version, 'uint16');                                  

    %Write the trial number.
    fwrite(fid, session.TrialCount, 'uint16');                                  

    %Get the trial start-time formatted as a datenum
    timestamp = datenum(trial.StartTime);

    %Write the trial start timestamp as a datenum (float64).
    fwrite(fid, timestamp, 'float64');

    %Convert the trial outcome to an 'H' or an 'M' (hit or miss)
    trial_outcome = 'H';
    if (trial.Result == Stop_Task_Trial_Result.Failure)
        trial_outcome = 'M';
    end

    %Write the trial outcome.
    fwrite(fid, trial_outcome(1), 'uchar');                                     

    %Write the target zone for this trial
    fwrite(fid, trial.TargetZone, 'uint8');                                     

    %Write the required amount of time that animal must "stop" in target zone
    fwrite(fid, trial.TargetStopDuration, 'float32');                           

    %Convert the reward time to a datenum (float64)
    reward_timestamp = datenum(trial.RewardTime);

    %Write the reward time to the file
    fwrite(fid, reward_timestamp, 'float64');

    %Write the number of zone events that occurred during this trial
    num_zone_events = length(trial.ZoneEvents);
    fwrite(fid, num_zone_events, 'uint32');

    %If the number of zone events is more than 0, write each zone event to
    %the file
    for i = 1:num_zone_events
        %Get this zone event
        zone_event = trial.ZoneEvents(i);

        %Set the version of the "zone event" sub-block
        zone_event_block_version = 1;

        %Write the version
        fwrite(fid, zone_event_block_version, 'uint16');

        %Convert the zone entrance time to a datenum
        entrance_time_datenum = datenum(zone_event.EntranceTime);

        %Write the entrance time to the file
        fwrite(fid, entrance_time_datenum, 'float64');

        %Write the stop duration to the file
        fwrite(fid, zone_event.StopDuration, 'float64');

        %Write the zone id for this zone event
        fwrite(fid, zone_event.Zone, 'uint8');

        %Write the number of anticipatory licks that occurred
        anticipatory_lick_count = length(zone_event.AnticipatoryLicks);
        fwrite(fid, anticipatory_lick_count, 'uint32');

        %Write out the timestamp of each lick
        for i = 1:anticipatory_lick_count
            d = datenum(zone_event.AnticipatoryLicks(i));
            fwrite(fid, d, 'float64');
        end
    end
    






