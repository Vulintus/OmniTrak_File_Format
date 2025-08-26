function data = OmniTrakFileRead_ReadBlock_TRIAL_START_SERIAL_DATE(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2014
%		DEFINITION:		TRIAL_START_SERIAL_DATE
%		DESCRIPTION:	Timestamped event marker for the start of a trial, with accompanying microsecond clock reading

data = OmniTrakFileRead_Check_Field_Name(data,'trial','start','datenum');   %Call the subfunction to check for existing fieldnames.

timestamp = fread(fid,1,'float64');                                         %Read in the serial date number timestamp.
t = fread(fid,1,'uint16');                                                  %Read in the trial index.
data.trial(t).start.datenum = timestamp;                                    %Save the serial date number timestamp for the trial.