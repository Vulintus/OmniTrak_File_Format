function data = OmniTrakFileRead_ReadBlock_V1_MOTOTRAK_V3P0_OUTCOME(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2500
%		MOTOTRAK_V3P0_OUTCOME

data = OmniTrakFileRead_Check_Field_Name(data,'trial',[]);                  %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start_time = fread(fid,1,'uint32');                           %Save the millisecond clock timestamp for the trial start.
data.trial(t).outcome = fread(fid,1,'*char');                               %Read in the character code for the outcome.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).init_thresh = fread(fid,1,'float32');                         %Read in the initiation threshold.
data.trial(t).hit_thresh = fread(fid,1,'float32');                          %Read in the hit threshold.
N = fread(fid,1,'uint8');                                                   %Read in the number of secondary hit thresholds.
if N > 0                                                                    %If there were any secondary hit thresholds...
    data.trial(t).secondary_hit_thresh = fread(fid,N,'float32')';           %Read in each secondary hit threshold.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of hits.
if N > 0                                                                    %If there were any hits...
    data.trial(t).hit_time = fread(fid,N,'uint32')';                        %Read in each millisecond clock timestamp for each hit.
end
N = fread(fid,1,'uint8');                                                   %Read in the number of output triggers.
if N > 0                                                                    %If there were any output triggers...
    data.trial(t).trig_time = fread(fid,1,'uint32');                        %Read in each millisecond clock timestamp for each output trigger.
end
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
if ~isfield(data.trial,'times')                                             %If the sample times field doesn't yet exist...
    data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                 %Pre-allocate a matrix to hold sample times.
end
if ~isfield(data.trial,'signal')                                            %If the signal matrix field doesn't yet exist...
    data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                %Pre-allocate a matrix to hold signal samples.
end
for i = 1:pre_N                                                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the millisecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end       