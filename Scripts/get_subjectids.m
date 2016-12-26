%% Function to get out the subjectIDs from excel file 
% Input:
%   - Dirs: structure containing all the necessary directories
%   - SubjectGroup1: Number of group 1 (corresponding to your excel file)
%   - SubjectGroup2: Number of group 2 (corresponding to your excel file)
%   - SubjectGroup3: Number of group 3 (corresponding to your excel file)

% Output:
%   - SubjectIDs: the subjectIDs 
%   - nsubj_gr1: number of subjects in group 1
%   - nsubj_gr2: number of subjects in group 2
%   - nsubj_gr3: number of subjects in group 3

% JB - March 2016

function [SubjectIDs, nsubj_gr1, nsubj_gr2, nsubj_gr3] = get_subjectids(Dirs, SubjectGroup1, SubjectGroup2, SubjectGroup3)

%% Read in the data from excelfile
[~, ~, raw] = xlsread(Dirs.ExcelDir,'Sheet1','A1:B200');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
allSubjectIDs = raw(:,1);
GroupID = raw(:,2); 
allSubjectIDs = allSubjectIDs(~cellfun('isempty',allSubjectIDs));
GroupID = GroupID(~cellfun('isempty',GroupID));

%% Get those SubjectIDs that corresponds to the wanted groups
rows_gr1 = find([GroupID{:}] == SubjectGroup1);
rows_gr2 = find([GroupID{:}] == SubjectGroup2);

nsubj_gr1 = size(rows_gr1,2);
nsubj_gr2 = size(rows_gr2,2);

if size(SubjectGroup3,1) > 0
    rows_gr3 = find([GroupID{:}] == SubjectGroup3);
    nsubj_gr3 = size(rows_gr3,2);
else
    nsubj_gr3 = [];
end


%% Make the new SubjectIDs 
for subj = 1:nsubj_gr1
    SubjectIDs{subj} = ['G1_' char(allSubjectIDs(rows_gr1(subj)))];
end

temp_nsubj = subj; 

for subj = 1:nsubj_gr2
    SubjectIDs{temp_nsubj + subj} = ['G2_' char(allSubjectIDs(rows_gr2(subj)))];
end
    
if exist('nsubj_gr3', 'var')
    temp_nsubj = (nsubj_gr1 + nsubj_gr2); 
    
    for subj = 1:nsubj_gr3
        SubjectIDs{temp_nsubj + subj} = ['G3_' char(allSubjectIDs(rows_gr2(subj)))];
    end
end



