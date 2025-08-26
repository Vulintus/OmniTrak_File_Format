function OmniTrakFileWrite_WriteBlock_TRIAL_PARAMS_JSON(fid, block_code, varargin)

%
% OmniTrakFileWrite_WriteBlock_TRIAL_PARAMS_JSON
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_TRIAL_PARAMS_JSON creates a block of
%   JSON-formatted text listing out all of the fields and values in the
%   "params" field of the passed Vulintus_Behavior_Trial_Class. This
%   block is intended to be a failsafe which captures pertinent trial
%   parameters that might have been omitted from other data blocks.
%
%		BLOCK VALUE:	0x0201
%		DEFINITION:		TRIAL_PARAMS_JSON
%		DESCRIPTION:	Behavioral trial parameters structure encoded in
%                       JSON format text.
%
%   UPDATE LOG:
%   2025-08-26 - Drew Sloan - Function first created.
%


trial = varargin{1};                                                        %The behavior structure will be the first optional input argument.

data_block_version = 1;                                                     %Set the data block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint16');                                    %Data block version.

txt = jsonencode(trial.params,PrettyPrint=true);                            %Convert the data to JSON-formatted text.
if any(txt == '\')                                                          %If there's any forward slashes...    
    txt = strrep(txt,'\','\\');                                             %Replace all single forward slashes with two slashes.
    k = strfind(txt,'\\\');                                                 %Look for any triple forward slashes...
    txt(k) = [];                                                            %Kick out the extra forward slashes.
end