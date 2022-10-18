function data = OmniTrakFileRead_Check_Field_Name(data,fieldname,subfieldname)

if ~iscell(fieldname)                                                       %If the field name isn't a cell.
    fieldname = {fieldname};                                                %Convert it to a cell array.
end
if ~iscell(subfieldname)                                                    %If the subfield name isn't a cell..
    subfieldname = {subfieldname};                                          %Convert it to a cell array.
end
for i = 1:length(fieldname)                                                 %Step through each specified field name.        
    if ~isfield(data,fieldname{i})                                          %If the structure doesn't yet have the specified field...
        data.(fieldname{i}) = [];                                           %Create the field.
    end
    for j = 1:length(subfieldname)                                          %Step through each specified subfield name.            
        if ~isempty(subfieldname{j})                                        %If a subfield was specified...
            if ~isfield(data.(fieldname{i}),subfieldname{j})                %If the primary field doesn't yet have the specified subfield...
                data.(fieldname{i}).(subfieldname{j}) = [];                 %Create the subfield.
            end
        end   
    end
end