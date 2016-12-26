warning('off','MATLAB:xlswrite:AddSheet');   % shut up, you excel.

%% Write away classification
classification_file = [Dirs.Results 'classification_results4.xls'];

% if file already exists, append a row with the new result. If not,
% create new file.
if exist('SubjectGroup3', 'var') ~= 1
    SubjectGroup3 = 'None';
end

if exist(classification_file, 'file')
    if strcmp(do_permutation, 'no')
        param = [roi SubjectGroup1 SubjectGroup2 SubjectGroup3 cellstr(conditionnames{condition}) mean(mean(classRateAll))];
    else
        param = [roi SubjectGroup1 SubjectGroup2 SubjectGroup3 cellstr(conditionnames{condition}) mean(mean(classRateAll)) p_value sorted_rndprm(ceil(0.95*nperm)) mean(sorted_rndprm)];
    end
    xlsappend(classification_file, param, 'SubjectClassification');
else
    % write to excel
    [Excel, ExcelWorkbook] = open_excelserver(classification_file);
    if strcmp(do_permutation, 'no')
        columnnames = [cellstr('MaskNr') cellstr('Group1') cellstr('Group2') cellstr('Group3') cellstr('Condition') cellstr('Classification Acc')];
        param = [roi SubjectGroup1 SubjectGroup2 SubjectGroup3 cellstr(conditionnames{condition}) mean(classRateAll)];
    else
        columnnames = [cellstr('MaskNr') cellstr('Group1') cellstr('Group2') cellstr('Group3') cellstr('Condition') cellstr('Classification Acc') cellstr('p-value') cellstr('Random Permutation Significance Border') cellstr('Mean of Random Permutation')];
        param = [roi SubjectGroup1 SubjectGroup2 SubjectGroup3 cellstr(conditionnames{condition}) mean(mean(classRateAll)) p_value sorted_rndprm(ceil(0.95*nperm)) mean(sorted_rndprm)];
    end
    xlswrite1(classification_file, columnnames, 'SubjectClassification', 'A1');
    xlswrite1(classification_file, param, 'SubjectClassification', 'A2');
    close_excelserver(ExcelWorkbook, Excel);
end

%% Write away results for subject confusion
if strcmp(do_subjectconfusion, 'yes')
    confusion_file = [Dirs.Results 'SubjectConfusion_ROI_' num2str(roi) '.xls'];
    
    [Excel, ExcelWorkbook] = open_excelserver(confusion_file);
    
    columnnames = [cellstr('SubjectIDs') cellstr('% correct classification') cellstr('# correct classification') cellstr('# total classification')];
    xlswrite1(confusion_file, columnnames, conditionnames{condition}, 'A1');
    xlswrite1(confusion_file, [(subjectconfusion{1}.correct_freq_subjects'./subjectconfusion{1}.total_freq_subjects')*100; (subjectconfusion{2}.correct_freq_subjects'./subjectconfusion{2}.total_freq_subjects')*100], conditionnames{condition}, 'B2');
    xlswrite1(confusion_file, [subjectIDsgroup{1}'; subjectIDsgroup{2}'], conditionnames{condition}, 'A2');
    xlswrite1(confusion_file, [subjectconfusion{1}.correct_freq_subjects'; subjectconfusion{2}.correct_freq_subjects'], conditionnames{condition}, 'C2');
    xlswrite1(confusion_file, [subjectconfusion{1}.total_freq_subjects'; subjectconfusion{2}.total_freq_subjects'], conditionnames{condition}, 'D2');
    
    close_excelserver(ExcelWorkbook, Excel);
end