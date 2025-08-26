function not_empty = isnt_empty_field(obj, fieldname, varargin)

%
% isnt_empty_field.m
%   
%   copyright 2024, Vulintus, Inc.
%
%   ISNT_EMPTY_FIELD is a recursive function that checks if the all of 
%   specified fields/subfields exist in the in the specified structure 
%   ("structure"), and then checks if the last subfield is empty.
%
%   UPDATE LOG:
%   2024-08-27 - Drew Sloan - Function first created.
%   2024-11-11 - Drew Sloan - Created complementary function
%                             "is_empty_field" to check for the reverse
%                             case.
%   2025-02-17 - Drew Sloan - Added an "isprop" check to be able to check
%                             class properties like structure fields.
%


switch class(obj)                                                           %Switch between the different recognized classes.
    case 'struct'                                                           %Structure.
        not_empty = isfield(obj, fieldname);                                %Check to see if the fieldname exists.
    case {'Vulintus_Behavior_Class','Vulintus_OTSC_Handler','datetime'}     %Vulintus classes.
        not_empty = isprop(obj, fieldname);                                 %Check to see if the property exists.     
    otherwise                                                               %For all other cases...
        not_empty = ~isempty(obj);                                          %Check to see if the object is empty.                   
end
if ~not_empty                                                               %If the field doesn't exist...
    return                                                                  %Skip the rest of the function.
end

if nargin == 2 || isempty(varargin)                                         %If only one field name was passed...    
    if (not_empty)                                                          %If the field exists...
        not_empty = ~isempty(obj.(fieldname));                              %Check to see if the field isn't empty.
    end
elseif nargin == 3                                                          %If a field name and one subfield name was passed...
    not_empty = isnt_empty_field(obj.(fieldname),varargin{1});              %Recursively call this function to check the subfield.
else                                                                        %Otherwise...
    not_empty = isnt_empty_field(obj.(fieldname),varargin{1},...
        varargin{2:end});                                                   %Recursively call this function to handle all subfields.
end