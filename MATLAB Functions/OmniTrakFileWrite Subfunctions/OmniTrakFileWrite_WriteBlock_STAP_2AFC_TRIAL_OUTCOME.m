function OmniTrakFileWrite_WriteBlock_STAP_2AFC_TRIAL_OUTCOME(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_STAP_2AFC_TRIAL_OUTCOME
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_STAP_2AFC_TASK_TRIAL writes data from 
%   individual trials of the SensiTrak arm proprioception discrimination
%   task to the *.OmniTrak file.
%
%		BLOCK VALUE:	0x0AB4
%		DEFINITION:		STAP_2AFC_TRIAL_OUTCOME
%		DESCRIPTION:	SensiTrak proprioception discrimination task trial 
%                       outcome data.
%
%   UPDATE LOG:
%   2025-07-14 - Drew Sloan - Function first created, adapted from
%                             "STAP_2AFC_Write_Trial_Data".
%


behavior = varargin{1};                                                     %The behavior structure will be the first optional input argument.

data_block_version = 2;                                                     %Set the data block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,65536,'uint16');                                                 %Write a maximum uint16 value to indicate this is not a Version 1 block.
fwrite(fid,data_block_version,'uint16');                                    %Data block version.

fwrite(fid,behavior.session.count.trial,'uint16');                          %Trial number.
fwrite(fid,datenum(behavior.session.trial(end).time.start.datetime),...
    'float64');                                                             %#ok<DATNM> %Start time of the trial (serial date number).
fwrite(fid,behavior.session.trial(end).time.start.micros,'uint32');         %Start time of the trial (microcontroller microsecond clock).
fwrite(fid,behavior.session.trial(end).outcome(1),'uchar');                 %Trial outcome as an unsigned character.
fwrite(fid,behavior.session.trial(end).params.target_feeder,'uchar');       %Target feeder.
fwrite(fid,behavior.session.trial(end).params.visited_feeder,'uchar');      %Visited feeder.
fwrite(fid,numel(behavior.session.trial(end).time.reward),'uint8');         %Number of feedings.
if ~isempty(behavior.session.trial(end).time.reward)                        %If there were any feedings...
    fwrite(fid,datenum(behavior.session.trial(end).time.reward),...
        'float64');                                                         %#ok<DATNM> %serial date number timestamp for every feeding.
end
fwrite(fid,numel(behavior.session.params.reward_mode),'uint8');             %Number of characters in the reward mode.
fwrite(fid,behavior.session.params.reward_mode,'uchar');                    %Characters of the reward mode.
fwrite(fid,numel('BASIC'),'uint8');                                         %Number of characters in the excursion type.
fwrite(fid,'BASIC','uchar');                                                %Characters of the excursion type.
for f = {'amplitude',...
        'speed',...        
        'hold_pre',...
        'hold_peri',...
        'choice_win',...
        'time_held'}                                                        %Step through various fields of the trial structure.
    fwrite(fid,behavior.session.trial(end).params.(f{1}),'float32');        %Write each field value as a 32-bit float.
end
fwrite(fid,length(behavior.session.params.pre_sample_index),'uint32');      %number of pre-trial samples.
signal = behavior.session.trial(end).signal.force.read();                   %Read the signal from the buffer.
fwrite(fid,size(signal,1)-1,'uint8');                                       %Number of data streams (besides the timestamp).
fwrite(fid,size(signal,2),'uint32');                                        %Number of samples.
behavior.session.trial(end).signal = ...
    rmfield(behavior.session.trial(end).signal,'force');                    %Remove the buffer from the trial.
fwrite(fid,signal(1,:),'uint32');                                           %Microsecond clock timestamps.
for i = 2:size(signal,1)                                                    %Step through the other signals in the buffer.         
    fwrite(fid,signal(i,:),'float32');                                      %Filtered and raw force values.
end