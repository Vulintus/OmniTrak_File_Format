function data =  OmniTrakFileRead_ReadBlock_SESSION_PARAMS_JSON(fid,data)

%
% OmniTrakFileRead_ReadBlock_SESSION_PARAMS_JSON.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEREAD_READBLOCK_SESSION_PARAMS_JSON reads in the 
%   "SESSION_PARAMS_JSON" data block from an *.OmniTrak format file. This 
%   block is intended to contain the fields and values of the "params"
%   field from the Vulintus_Behavior_Session_Class of a behavioral program
%   instance. This block is intended to be a failsafe cpaturing all session
%   parameters in case pertinent parameters are omitted from other data
%   blocks.
%
%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	0x0200
%		DEFINITION:		SESSION_PARAMS_JSON
%		DESCRIPTION:	Behavioral session parameters structure encoded in 
%                       JSON format text.
%
%   UPDATE LOG:
%       2025-08-26 - Drew Sloan - Function first created.
%

data = OmniTrakFileRead_Check_Field_Name(data,'json','session_params');     %Call the subfunction to check for existing fieldnames.

ver = fread(fid,1,'uint8');                                                 %Read in the TTL_PULSETRAIN data block version.

switch ver                                                                  %Switch between the different data block versions.

    case 1                                                                  %Version 1 (implemented 2025-02-10).        
        N = fread(fid,1,'uint32');                                          %Read in the number of characters.
        txt = char(fread(fid,N,'uchar')');                                  %Read in the JSON-encoded text.
        txt = strrep(txt,'\','\\');                                         %Replace all single forward slashes with two slashes.
        txt = strrep(txt,'\\\','\\');                                       %Replace all triple forward slashes with two slashes.
        txt = strrep(txt,'\\"','\"');                                       %Replace all double forward slashes preceding double quotes with one slash.
        data.json.session_params = jsondecode(txt);                         %Convert the text to data.

    otherwise                                                               %Unrecognized data block version.
        error(['ERROR IN %s: Data block version #%1.0f is not '...
            'recognized!'], upper(mfilename), ver);                         %Show an error.
        
end
