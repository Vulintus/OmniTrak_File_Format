function data = OmniTrakFileRead_ReadBlock_MOTOTRAK_V3P0_SIGNAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		2501
%		MOTOTRAK_V3P0_SIGNAL

data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
num_signals = fread(fid,1,'uint8');                                         %Read in the number of signal streams.
pre_N = fread(fid,1,'uint16');                                              %Read in the number of pre-trial samples.
hitwin_N = fread(fid,1,'uint16');                                           %Read in the number of hit window samples.
post_N = fread(fid,1,'uint16');                                             %Read in the number of post-trial samples.
data.trial(t).N_samples = [pre_N, hitwin_N, post_N];                        %Save the number of samples for each phase of the trial.
data.trial(t).times = nan(pre_N + hitwin_N + post_N,1);                     %Pre-allocate a matrix to hold sample times, in microseconds.
data.trial(t).signal = nan(pre_N + hitwin_N + post_N,3);                    %Pre-allocate a matrix to hold signal samples.
for i = (pre_N + 1):(pre_N + hitwin_N + post_N)                             %Step through the samples starting at the hit window.
    data.trial(t).times(i) = fread(fid,1,'uint32');                         %Save the microsecond clock timestamp for the sample.
    data.trial(t).signal(i,:) = fread(fid,num_signals,'int16');             %Save the signal samples.
end