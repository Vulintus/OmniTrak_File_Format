function data = OmniTrakFileRead_ReadBlock_V1_LED_DETECTION_TASK_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2710
%		LED_DETECTION_TASK_TRIAL_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Read in the trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Read in the trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the trial outcome.
N = fread(fid,1,'uint8');                                                   %Read in the number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Read in the feeding times.
data.trial(t).hit_win = fread(fid,1,'float32');                             %Read in the hit window.
data.trial(t).ls_index = fread(fid,1,'uint8');                              %Read in the light source index (1-8).
data.trial(t).ls_pwm = fread(fid,1,'uint8');                                %Read in the light source intensity (PWM).                
data.trial(t).ls_dur = fread(fid,1,'float32');                              %Read in the light stimulus duration.
data.trial(t).hold_time = fread(fid,1,'float32');                           %Read in the hold time.
data.trial(t).time_held = fread(fid,1,'float32');                           %Read in the time held.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
num_signals = 1;                                                            %%<<REMOVE AFTER DEBUGGING.
N = fread(fid,1,'uint32');                                                  %Read in the number of samples.                
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
data.trial(t).signal(:,1) = fread(fid,N,'uint16');                          %Read in the nosepoke signal.
for i = 2:num_signals                                                       %Step through the non-nosepoke signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each non-nosepoke signal.
end