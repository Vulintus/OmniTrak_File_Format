function data = OmniTrakFileRead_ReadBlock_V1_STAP_2AFC_TRIAL_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2740
%		DEFINITION:		STAP_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak proprioception discrimination task trial outcome data.

%   2022/03/16 - Drew Sloan - Function first created.
%

try
    spot = ftell(fid);
data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Trial index.
data.trial(t).start_time = fread(fid,1,'float64');                          %Trial start time (serial date number).
data.trial(t).start_millis = fread(fid,1,'uint32');                         %Trial start time (Arduino millisecond clock).
data.trial(t).outcome = fread(fid,1,'*char');                               %Character code for the outcome.
data.trial(t).visited_feeder = fread(fid,1,'*char');                        %Character code for the visited feeder.
N = fread(fid,1,'uint8');                                                   %Number of feedings.
data.trial(t).feed_time = fread(fid,N,'float64');                           %Feeding times.
data.trial(t).max_touch_dur = fread(fid,1,'float32');                       %Touch duration maximum limit.
data.trial(t).min_touch_dur = fread(fid,1,'float32');                       %Touch duration minimum limit.
data.trial(t).touch_dur = fread(fid,1,'float32');                           %Read in the actual touch duration.
data.trial(t).choice_time = fread(fid,1,'float32');                         %Feeder choice time limit.
data.trial(t).response_time = fread(fid,1,'float32');                       %Feeder response time.

data.trial(t).movement_start = fread(fid,1,'uint32');                       %Movement start time (Arduino millisecond clock).
N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
if data.trial(t).excursion_type(1) == 'C'
    fseek(fid,-(N + 5),'cof');
    N = fread(fid,1,'uint8');                                                   %Number of characters in the excursion type.
    data.trial(t).excursion_type = fread(fid,N,'*char')';                       %Excursion type.
    data.trial(t).movement_start = NaN;
end
data.trial(t).amplitude = fread(fid,1,'float32');                           %Excursion amplitude, in millimeters.
data.trial(t).speed = fread(fid,1,'float32');                               %Excursion speed, in millimeters/second.

num_signals = fread(fid,1,'uint8');                                         %Number of data signals (besides the timestamp).
N = fread(fid,1,'uint32');                                                  %Number of samples in each stream.
data.trial(t).times = fread(fid,N,'uint32');                                %Read in the millisecond clock timestampes.
data.trial(t).signal = nan(N,num_signals);                                  %Create a matrix to hold the sensor signals.
for i = 1:num_signals                                                       %Step through the signals.
    data.trial(t).signal(:,i) = fread(fid,N,'float32');                     %Read in each signal.
end
catch
    disp(spot);
end