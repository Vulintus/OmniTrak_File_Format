function data = OmniTrakFileRead_ReadBlock_VIBROTACTILE_DETECTION_TASK_TRIAL(fid,data)

%
% OmniTrakFileWrite_WriteBlock_VIBROTACTILE_DETECTION_TASK_TRIAL
%   
%   copyright 2024, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_VIBROTACTILE_DETECTION_TASK_TRIAL writes
%   data from individual trials of the Fixed Reinforcement task.
%
%   OFBC block code: 0x0A8D
%
%   UPDATE LOG:
%   2025-05-27 - Drew Sloan - Function completed.
%

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2701
%		DEFINITION:		VIBROTACTILE_DETECTION_TASK_TRIAL
%		DESCRIPTION:	Vibrotactile detection task trial data.

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint16');                                                %Read in the FR_TASK_TRIAL data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.        
        t = fread(fid,1,'uint16');                                          %Read in the trial number/index.
        data.trial(t).start_time = fread(fid,1,'float64');                  %Read in the trial start time (serial date number).
        data.trial(t).outcome = fread(fid,1,'*char');                       %Read in the trial outcome.
        N = fread(fid,1,'uint8');                                           %Read in the number of feedings.
        data.trial(t).feed_time = fread(fid,N,'float64');                   %Read in the feeding times.
        data.trial(t).hit_win = fread(fid,1,'float32');                     %Read in the hit window.
        data.trial(t).vib_dur = fread(fid,1,'float32');                     %Read in the vibration pulse duration.
        data.trial(t).vib_rate = fread(fid,1,'float32');                    %Read in the vibration pulse rate.
        data.trial(t).actual_vib_rate = fread(fid,1,'float32');             %Read in the actual vibration pulse rate.
        data.trial(t).gap_length = fread(fid,1,'float32');                  %Read in the gap length.
        data.trial(t).actual_gap_length = fread(fid,1,'float32');           %Read in the actual gap length.
        data.trial(t).hold_time = fread(fid,1,'float32');                   %Read in the hold time.
        data.trial(t).time_held = fread(fid,1,'float32');                   %Read in the time held.
        data.trial(t).vib_n = fread(fid,1,'uint16');                        %Read in the number of vibration pulses.
        data.trial(t).gap_start = fread(fid,1,'uint16');                    %Read in the number of vibration gap start index.
        data.trial(t).gap_stop = fread(fid,1,'uint16');                     %Read in the number of vibration gap stop index.
        data.trial(t).pre_samples = fread(fid,1,'uint32');                  %Read in the number of pre-trial samples.
        num_signals = fread(fid,1,'uint8');                                 %Read in the number of signal streams.
        N = fread(fid,1,'uint32');                                          %Read in the number of samples.
        data.trial(t).times = fread(fid,N,'uint32');                        %Read in the millisecond clock timestampes.
        data.trial(t).signal = nan(N,num_signals);                          %Create a matrix to hold the sensor signals.
        for i = 1:num_signals                                               %Step through the signals.
            data.trial(t).signal(:,i) = fread(fid,N,'float32');             %Read in each signal.
        end

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end