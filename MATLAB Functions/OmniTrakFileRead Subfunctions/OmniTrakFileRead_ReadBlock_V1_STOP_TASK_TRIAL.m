function session = OmniTrakFileRead_ReadBlock_V1_STOP_TASK_TRIAL(fid, session)
    %OMNITRAKFILEREAD_READBLOCK_V1_STOP_TASK_TRIAL reads data of an
    %individual trial of the STOP task.

    %Create a struct to hold the trial data
    trial_data = struct( ...
        'start_time', NaT, ...
        'outcome', 'M', ...
        'target_zone', 0, ...
        'target_stop_duration', 0, ...
        'reward_time', NaT, ...
        'zone_events', [] ...
    );

    zone_events = struct( ...
        'entrance_time', {}, ...
        'stop_duration', {}, ...
        'zone_id', {}, ...
        'anticipatory_licks', {} ...
    );

    %Read in the version of the stop task trial block
    stop_task_trial_block_version = fread(fid, 1, 'uint16');

    %Check to see if the version is supported
    if (stop_task_trial_block_version == 1)

        %Read in the trial number
        trial_number = fread(fid, 1, 'uint16');

        %Read in the trial start time
        trial_start_time = fread(fid, 1, 'float64');
        trial_start_datetime = datetime(datevec(trial_start_time));

        %Read in the trial outcome
        trial_outcome = fread(fid, 1, 'uchar');

        %Read in the trial's target zone
        trial_target_zone = fread(fid, 1, 'uint8');

        %Read in the target stop duration
        trial_target_stop_duration = fread(fid, 1, 'float32');

        %Read in the trial's reward time
        trial_reward_time = fread(fid, 1, 'float64');
        trial_reward_datetime = datetime(datevec(trial_reward_time));

        %Read in the number of zone events that occurred during this trial
        trial_num_zone_events = fread(fid, 1, 'uint32');

        %Read in each individual zone event
        for i = 1:trial_num_zone_events

            %Read in the version of the zone-event sub-block
            zone_event_block_version = fread(fid, 1, 'uint16');

            %Read in the zone entrance time
            zone_entrance_time = fread(fid, 1, 'float64');
            zone_entrance_datetime = datetime(datevec(zone_entrance_time));

            %Read in the stop duration
            zone_stop_duration = fread(fid, 1, 'float64');

            %Read in the zone id
            zone_id = fread(fid, 1, 'uint8');

            %Read in the number of licks that occurred
            zone_licks = fread(fid, 1, 'uint32');

            %Read in the timestamp of each lick
            zone_lick_times = datetime.empty;
            for j = 1:zone_licks
                zone_lick_time = fread(fid, 1, 'float64');
                zone_lick_times = [zone_lick_times zone_lick_time];
            end

            %Form a struct representing this zone event
            zone_event = struct( ...
                'entrance_time', zone_entrance_datetime, ...
                'stop_duration', zone_stop_duration, ...
                'zone_id', zone_id, ...
                'anticipatory_licks', zone_lick_times ...
            );

            %Add this zone event to the array of all zone events
            zone_events = [zone_events zone_event];

        end

        %Set the trial data
        trial_data.start_time = trial_start_datetime;
        trial_data.outcome = trial_outcome;
        trial_data.target_zone = trial_target_zone;
        trial_data.target_stop_duration = trial_target_stop_duration;
        trial_data.reward_time = trial_reward_datetime;
        trial_data.zone_events = zone_events;

        %Append the trial onto the session
        session.trial(trial_number) = trial_data;

    end












