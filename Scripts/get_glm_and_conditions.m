%% Function to get out the subjectIDs from excel file
% Input:
%   - SubjectIDs: the subjectIDs
%   - Dirs: structure containing all the necessary directories

% Output:
%   - Dirs: structure containing all the necessary directories
%   - conditionnames: the names of the conditions
%   - conditionnumbers: which contrast numbers
%   - ncond: how many conditions there are

% JB - March 2016

function [Dirs, conditionnames, conditionnumbers, ncond] = get_glm_and_conditions(SubjectIDs, Dirs)

% Get the specific GLM in a subject folder, if there is any
underscore = find(SubjectIDs{1} == '_');
subjid = SubjectIDs{1}(underscore+1:end);
all_files = dir([Dirs.Data subjid filesep]);
all_files(1:2) = [];
isfolder = [all_files.isdir];
if size(isfolder, 2) > 0
    subfolders = {all_files(isfolder).name};
    [s,~] = listdlg('PromptString', 'Select a GLM:', 'SelectionMode','single', 'ListString', subfolders);
    Dirs.SubData = [char(subfolders(s)) filesep];
else
    Dirs.SubData = '';
end

% Get the conditions that will be used during subject classification
subjdir = [Dirs.Data subjid filesep Dirs.SubData];
all_spm_files = dir([subjdir 'spmT*']);
for file = 1:size(all_spm_files,1)
    loaded = spm_vol([subjdir all_spm_files(file).name]);
    double = find(loaded.descrip == ':');
    name_contrast{file} = loaded.descrip(double+2:end);
end

[s,~] = listdlg('PromptString', 'Select the conditions: ', 'SelectionMode', 'multiple', 'ListString', name_contrast);

conditionnumbers = s;
conditionnames = {name_contrast{s}};
ncond = size(conditionnames,2);
