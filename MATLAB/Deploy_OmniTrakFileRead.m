function Deploy_OmniTrakFileRead

%
%Deploy_OmniTrakFileRead.m - Vulintus, Inc.
%
%   DEPLOY_ST_PROPRIOCEPTION_2AFC_TASK collates all of the *.m file 
%   dependencies for the SensiTrak proprioception discrimination task 
%   program into a single *.m file and creates time-stamped back-up copies 
%   of each file when a file modification is detected.
%
%   UPDATE LOG:
%   03/10/2022 - Drew Sloan - Function first created, adapted from
%       Deploy_ST_Proprioception_2AFC_Task.m
%

start_script = which('OmniTrakFileRead_Beta.m');                            %Set the expected name of the initialization script.
collated_filename = 'OmniTrakFileRead.m';                                   %Set the name for the collated script.

[ofbc_dir, cur_dir, ~] = fileparts(start_script);                           %Strip out the filename from the path.
while ~strcmpi(cur_dir,'MATLAB') && ~isempty(cur_dir)                       %Loop until we get to the "MATLAB" folder.
    [ofbc_dir, cur_dir, ~] = fileparts(ofbc_dir);                           %Strip out the filename from the path.
end
ofbc_dir = fullfile(ofbc_dir,'MATLAB');                                     %Add the "MATLAB" directory back to the path.

% [collated_file, ~] = ...
%     Vulintus_Collate_Functions(start_script, collated_filename);            %Call the generalized function-collating script.

h = matlab.desktop.editor.getAll;                                           %Grab all *.m files open in the Matlab Editor.
for i = 1:length(h)                                                         %Step through each open *.m file.
    temp = h(i).Filename;                                                   %Grab the full path filename of the *.m file.
    temp(1:find(temp == '\',1,'last')) = [];                                %Kick out directory preceding the *.m file name.
    if strcmpi(temp,collated_filename)                                      %If any collated MotoTrak program is open for editing...
        h(i).close;                                                         %Close the MotoTrak program in the editor.
    end
end
drawnow;                                                                    %Allow the Editor to finish closing an necessary *.m files in the editor.

[program_dir,~,~] = fileparts(start_script);                                %Grab the full path of the initialization script.

clc;                                                                        %Clear the command line.
fprintf(1,'Checking function dependencies...');                             %Print a line to the command line to show that dependencies are being checked.
[depfuns, temp_matproducts] = ...
    matlab.codetools.requiredFilesAndProducts(start_script);                %Find all function and product dependencies for the start script.
matproducts = {temp_matproducts.Name};                                      %Copy the matlab product names to a cell array.
numfuns = 0;                                                                %Find the starting number of function dependencies.
while numfuns ~= length(depfuns)                                            %Loop until no more dependencies are found.    
    numfuns = length(depfuns);                                              %Count how many function dependencies exist at the start of the loop.
    for f = 1:length(depfuns)                                               %Step through each subfunction.        
        if strncmpi(program_dir,depfuns{f},length(program_dir))             %If the subfunction is in the current directory...
            fprintf('.');                                                   %Print another period to the command line.
            [temp_depfuns, temp_matproducts] = ...
                matlab.codetools.requiredFilesAndProducts(depfuns{f});      %Find all function dependencies for each subfunction.
            depfuns = union(temp_depfuns,depfuns);                          %Add any new function dependencies to the list.
            matproducts = union({temp_matproducts.Name},matproducts);       %Add any new product dependencies to the list.
        end
    end
end
depfuns = {start_script, depfuns{:}};                                       %#ok<CCAT> %Add the initialization script to the function list.
keepers = ones(size(depfuns));                                              %Create a matrix to check for duplicates.
for i = 2:numel(depfuns)                                                    %Step through every functions.
    if any(strcmpi(depfuns(1:i-1),depfuns{i}))                              %If this function matches any previous function...
        keepers(i) = 0;                                                     %Mark the function for exclusion.
    end
    [~,~,ext] = fileparts(depfuns{i});                                      %Grab the file extension for the function.
    if ~strcmpi(ext,'.m')                                                   %If this isn't an m-file...
        keepers(i) = 0;                                                     %Mark the file for exclusion.
    end
end
depfuns(keepers == 0) = [];                                                 %Kick out any duplicates from the function list.
fprintf(1,'\n');                                                            %Print a carriage return.

clc;                                                                        %Clear the command line.
main_fid = fopen(fullfile(ofbc_dir,collated_filename),'wt');                %Open a new *.m file to write the new script to.
fprintf(main_fid,'%s\n\n',...
    'function data = OmniTrakFileRead(file,varargin)');                     %Print the 'OmniTrakFileRead' function name to the file.
fprintf(main_fid,'%%Collated: %s\n\n',datestr(now,'mm/dd/yyyy, HH:MM:SS')); %Print the compile time to the file.
fprintf(1,...
    '1: %s\n2: \n','function data = OmniTrakFileRead(file,varargin)');      %Print the 'OmniTrakFileRead' function name to the command line.
fprintf(1,'3: %%Collated: %s\n',datestr(now,'mm/dd/yyyy, HH:MM:SS'));       %Print the compile time to the command line.
ln_num = 3;                                                                 %Create a variable to count the lines across the entire collated m-file.
for f = 1:length(depfuns)                                                   %Step through each included function.
    sub_fid = fopen(depfuns{f},'rt');                                       %Open the *.m file for reading as text.
    txt = fscanf(sub_fid,'%c');                                             %Read in all the characters of the *.m file.
    fclose(sub_fid);                                                        %Close the *.m file.
    a = 1;                                                                  %Create an index to mark the start of a line.
    b = 1;                                                                  %Create an index to mark the end of a line.    
    c = 0;                                                                  %Create a subfunction line counting variable.
    debug_skip = 0;                                                         %Create a boolean variable to indicate when we're skipping lines of code.
    while b < length(txt)                                                   %Loop until we run out of text.
        if txt(a) == 10                                                     %If the first character is a carriage return...
            c = c + 1;                                                      %Increment the subfunction line counter.
            ln_num = ln_num + 1;                                            %Increment the collated m-file line counter.
            fprintf(main_fid,'\n');                                         %Print a carraige return to the file.
            fprintf(1,'%1.0f:\n',ln_num);                                   %Print the line number to the command line.
            a = b + 1;                                                      %Set the start-of-line index to the next character.
            b = a;                                                          %Set the end-of-line index to the same character.
            ln = txt(a);                                                    %Grab the one-character line of text.
        else                                                                %Otherwise, if the first character isn't a carriage return...
            b = b + 1;                                                      %Advance the end-of-line character index.
            if txt(b) == 10 || b == length(txt)                             %If the end-of-line character is a carriage return...
                c = c + 1;                                                  %Increment the line counter.                
                ln = txt(a:b);                                              %Grab the line of text.
                if contains(ln,'%end debug code')                           %If the line indicates the end of a debugging section...
                    if debug_skip == 0                                      %If we're already outside of a debugging section of code...
                        fclose(main_fid);                                   %Close the new *.m file.
                        fprintf(1,'%1.0f: ',c);                             %Print the line number to the command line.
                        fprintf(1,'%s',ln);                                 %Print the line of text to the command line.
                        error(['No preceding ''%start debug code'' '...
                            'marker in "' depfuns{f} '", line ' ...
                            num2str(c)]);                                   %Show an non-matching section error and indicate the line in the *.m file.
                    end
                    debug_skip = 0;                                         %Set the boolean variable to skip the following section.
                elseif contains(ln,'%start debug code')                     %If the line indicates debugging code to follow...
                    if debug_skip == 1                                      %If we're already within a debugging section of code...
                        fclose(main_fid);                                   %Close the new *.m file.
                        fprintf(1,'%1.0f: ',c);                             %Print the line number to the command line.
                        fprintf(1,'%s',ln);                                 %Print the line of text to the command line.
                        error(['No preceding ''%end debug code'' '...
                            'marker in "' depfuns{f} '", line ' ...
                            num2str(c)]);                                   %Show an non-matching section error and indicate the line in the *.m file.
                    end
                    debug_skip = 1;                                         %Set the boolean variable to skip the following section.
                end
                ln_num = ln_num + 1;                                        %Increment the collated m-file line counter.                
                if ln_num > 5                                               %If this isn't the first line of the entire collated m-file...
                    fprintf(1,'%1.0f: ',ln_num);                            %Print the line number to the command line.
                    if debug_skip == 1                                      %If we're in a debugging section...
                        fprintf(1,'%s','%');                                %Add a comment marker to the start of the command line.
                        fprintf(main_fid,'%s','%');                         %Add a comment marker to the start of the new *.m file line.
                    end                    
                    fprintf(main_fid,'%s',ln);                              %Print the line of text to the new *.m file.
                    fprintf(1,'%s',ln);                                     %Print the line of text to the command line.
                end
                a = b + 1;                                                  %Set the start-of-line index to the next character.
                b = a;                                                      %Set the end-of-line index to the same character.
            end
        end
    end
    if ln(end) ~= 10                                                        %If the last line isn't a carriage return...
        fprintf(main_fid,'\n');                                             %Print a carraige return to the collated file.
        fprintf(1,'\n');                                                    %Print a carraige return to the command line.
    end
    fprintf(main_fid,'\n\n');                                               %Print two carraige returns to the collated file.
    fprintf(1,'%1.0f:\n%1.0f:\n', ln_num + (1:2));                          %Print two carraige returns to the command line.
    ln_num = ln_num + 2;                                                    %Add
end
fclose(main_fid);                                                           %Close the new *.m file.

depfun_dir = fullfile(program_dir,'Required Toolbox Functions');            %Create the function dependency subfolder.
if ~exist(depfun_dir,'dir')                                                 %If the subfolder doesn't already exist...
    mkdir(depfun_dir);                                                      %Create it.
end
for f = 1:length(depfuns)                                                   %Step through each included function.
    [fun_dir,~,~] = fileparts(depfuns{f});                                  %Grab the path from each function.
    if ~strcmpi(program_dir,fun_dir)                                        %If the function isn't in the program folder...
        copyfile(depfuns{f},depfun_dir,'f');                                %Copy the function to the function dependency folder.
    end
end
if ~isempty(matproducts)                                                    %If there's any required MATLAB products.
    fun_file = fullfile(depfun_dir,'required_matlab_products.txt');         %Create a text filename to hold the list of MATLAB products.
    Vulintus_TSV_File_Write(matproducts',fun_file);                         %Write the required products to the list.
end

open('OmniTrakFileRead');                                                   %Open the new OmniTrakFileRead.