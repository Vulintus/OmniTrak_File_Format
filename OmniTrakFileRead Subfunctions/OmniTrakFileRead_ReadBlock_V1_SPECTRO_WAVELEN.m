function data = OmniTrakFileRead_ReadBlock_V1_SPECTRO_WAVELEN(fid,data)

%	OmniTrak File Block Code (OFBC):
%		1900
%		SPECTRO_WAVELEN

data = OmniTrakFileRead_Check_Field_Name(data,'spectro','wavelengths');     %Call the subfunction to check for existing fieldnames.
spectro_i = fread(fid,1,'uint8');                                           %Read in the spectrometer index.
N = fread(fid,1,'uint32');                                                  %Read in the number of wavelengths tested by the spectrometer.
data.spectro(spectro_i).wavelengths = fread(fid,N,'float32')';              %Read in the characters of the light source model.