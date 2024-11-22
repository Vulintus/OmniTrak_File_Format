function data = OmniTrakFileRead_ReadBlock_V1_FR_TASK_TRIAL(fid,data)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	2800
%		DEFINITION:		FR_TASK_TRIAL
%		DESCRIPTION:	Fixed reinforcement task trial data.


data = OmniTrakFileRead_Check_Field_Name(data,'trial');                     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint16');                                                %Read in the FR_TASK_TRIAL data block version

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1.
        t = fread(fid,1,'uint16');                                          %Read in the trial index.
        data.trial(t).datenum = fread(fid,1,'float64');                     %Read in the serial date number timestamp.
        data.trial(t).outcome = fread(fid,1,'*char');                       %Read in the outcome code.
        data.trial(t).target_poke = fread(fid,1,'uint8');                   %Read in the target nosepoke index.
        data.trial(t).thresh = fread(fid,1,'uint8');                        %Read in the required number of pokes.
        data.trial(t).poke_count = fread(fid,1,'uint16');                   %Read in the number of completed pokes.
        data.trial(t).hit_time = fread(fid,1,'float32');                    %Read in the hit (first reward) time (0 for no reward).
        data.trial(t).reward_dur = fread(fid,1,'float32');                  %Read in the reward window duration (lick availability), in seconds.
        data.trial(t).num_licks = fread(fid,1,'uint16');                    %Read in the number of licks.
        data.trial(t).num_feedings = fread(fid,1,'uint16');                 %Read in the number of feedings/dispensings.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end