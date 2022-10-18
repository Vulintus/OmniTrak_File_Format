function data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_TRACE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1901
%		SPECTRO_TRACE

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','trace');           %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
t = numel(data.spectro(spectro_i).trace) + 1;                               %Find the next trace index.
data.spectro(spectro_i).trace(t).light_src = fread(fid,1,'uint8');          %Read in the module index.
data.spectro(spectro_i).trace(t).chan = fread(fid,1,'uint16');              %Read in the light source channel index.
data.spectro(spectro_i).trace(t).time = fread(fid,1,'float64');             %Read in the trace timestamp.
data.spectro(spectro_i).trace(t).intensity = fread(fid,1,'float32');        %Read in the light source intensity.
data.spectro(spectro_i).trace(t).position = fread(fid,1,'float32');         %Read in the light source position.
data.spectro(spectro_i).trace(t).integration = fread(fid,1,'float32');      %Read in the integration time.
data.spectro(spectro_i).trace(t).minus_background = fread(fid,1,'uint8');   %Read in the the background subtraction flag.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
reps = fread(fid,1,'uint16');                                               %Read in the number of repetitions in the trace.
data.spectro(spectro_i).trace(t).data = nan(reps,N);                        %Pre-allocate a data field.
for i = 1:reps                                                              %Step through each repetition.
    data.spectro(spectro_i).trace(t).data(i,:) = fread(fid,N,'float64');    %Read in each repetition.
end