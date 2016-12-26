%% Subject Classification
% Train and test between subjects of two groups or generalize across
% different groups. 
% 
% OPTIONS:
%   - work with GUI or script for adjusting variables. 
%   - functional or anatomical data
%   - include subject confusion or not
%   - include random permutations or not 
%   - do normal classification (same groups for training and testing) or 
%     do generalization classification (only possible if N_Groups > 2)

% READ THIS FIRST: 
%   - GUI is recommended if you are a first time user of this script or 
%     if you are a matlab beginner. 
%   - When you are working with general masks, these masks will be
%     coregistred to your data volume.
%   - If you want to work with anatomical data, make a seperate
%     folder with all the wr-anatomical files of the subjects. Make sure
%     that the name of the wr-anatomical files is the following: wrC1.nii
%     (where C1 is the SubjectID that corresponds to the subjectID in 
%     your excelfile). 
%   - Results will be written away to excel-files in the Result Directory
%     that you have chosen. 

% Original: JB - July 2015
% Adjusted: JB - March 2016
%   * made scripts useable for the lab (a lot of automatization and
%   generalized the code) 
% Adjusted: JB - April 2016
%   * leave-one-pair-out cross validation for classification and random 
%     permutations
%   * included the possibility to do generalization

%% (0) How to use this script.
% How do you want to work with this script? Type 'script' if you will
% adjust the variables yourself in the script. Type 'gui' if you want to
% use a GUI. If you opted for a GUI, just run the script after you typed
% 'gui' below. 
what_to_use = 'gui'; 

%% (1) Variables
% Adjust below the variables if you wanted to adjust them in the script 
% instead of working with a GUI. 
if strcmp(what_to_use, 'script')
    % *** A. Variables you need to change for every new analysis. 
    % which rois do want to analyze? 
    ROIs = 1:3;

    % Subjects to analyze: which groups do you want to differentiate? Use the
    % numbers from your excelfile. 
    SubjectGroup1 = 1;
    SubjectGroup2 = 4; 
    
    % Do you want to do generalization ('yes' or 'no')? If yes,
    % SubjectGroup1 will be used in training and testing. SubjectGroup2
    % and SubjectGroup3 will only be used in either training/testing. This
    % script will do the generalization in both ways and average across
    % both generalizations. 
    do_generalization = 'yes'; 
    SubjectGroup3 = 3; 

    % Do you want to do a permutation test? This takes a lot of time, so you
    % might want to do this only once. Decide 'yes' or 'no'; 
    do_permutation = 'yes'; 

    % What type of data do you want to work with? 'functional' for functional
    % data or 'anatomical' for anatomical data. 
    datatype = 'functional'; 
    
    % Do you want to do subject confusion? Aka, look at how often a subject
    % is confused with the other group? Type 'yes' or 'no'; Will not be
    % done if you're running a generalization classification. 
    do_subjectconfusion = 'no';     
        
    % *** B. Variables specific to your study, so probably you do not need to
    % change them every time. 
    % HomeDir: your main folder
    Dirs.HomeDir = 'C:\Users\u0069828\Google Drive\Research\Scripts\SubjectClassification\'; 

    % ResultDir: the results of the analysis are saved here. 
    Dirs.Results = [Dirs.HomeDir 'Results\'];
    if exist(Dirs.Results, 'dir') ~= 7
        mkdir(Dirs.Results);
    end

    % ScriptDir: where are the scripts that you need to perform this analysis? 
    Dirs.Scripts = [Dirs.HomeDir 'Scripts\'];

    % DataDir: where are your folder containing the folders for every subject
    % in which the beta's are localized? Or for anatomical data, the
    % folder containing all the wr-anatomical images. 
    Dirs.Data = 'C:\Users\u0069828\Google Drive\Research\Dyscalculie Studie\fMRI\Statistiek\';

    % if you have a subdirectory in your data folder of a subject, type here
    % the name or if you do not have a subdirectory, comment this line! For
    % anatomical analysis: comment the line. 
    Dirs.SubData = 'Univariaat\'; 

    % Where are the original masks for the ROIs? 
    Dirs.ROI = [Dirs.HomeDir 'ROIs\'];

    % conditionnames: the contrasts that you have modelled in your GLM, in
    % sequence of your spmT's for every subject. For example, my
    % conditionnames{1} is 'Dots', the spmT0001 of a subject is also the Dots.
    % For anatomical analysis: conditionnumbers = 1; conditionnames =
    % {'anatomical'}; ncond = 1; 
    conditionnumbers = [1 2]; 
    conditionnames = {'Dots' 'Symbols'};           
    ncond = size(conditionnames,2);

    % excel-file containing your subjectid's and groupnumbers 
    Dirs.ExcelDir = [Dirs.HomeDir  'SubjectIDs.xls'];

    % *** C. Parameters inherent to the analysis. 
    % how many random permutations do you want to do (min. 1000)? 
    nperm = 1000; 

    % Toolbox folder for classification 
    Dirs.libsvm = [Dirs.HomeDir 'libsvm\'];
    addpath(genpath(Dirs.libsvm));

%% (2A) Run GUI if requested
elseif strcmp(what_to_use, 'gui')
    % get the variables
    f = gui_variables;
    uiwait(f);
    load('temp_vars.mat');
    delete('temp_vars.mat');
    clear f; 
    
    % get the directories
    save('temp_dirs.mat');
    f = gui_dirs;
    uiwait(f);
    load('temp_dirs.mat');
    delete('temp_dirs.mat');
    clear f;
    addpath(genpath(Dirs.libsvm));
end    

%% (3) Get Subject Groups
% Get subjectID's for the groups you have selected above
if strcmp(do_generalization, 'no')
    [SubjectIDs, nsubj_gr1, nsubj_gr2, ~] = get_subjectids(Dirs, SubjectGroup1, SubjectGroup2, []);
elseif strcmp(do_generalization, 'yes')
    [SubjectIDs, nsubj_gr1, nsubj_gr2, nsubj_gr3] = get_subjectids(Dirs, SubjectGroup1, SubjectGroup2, SubjectGroup3);
    do_subjectconfusion = 'no'; 
end

%% (2B) Run GUI
if strcmp(what_to_use, 'gui')
    if strcmp(datatype, 'functional')
        [Dirs, conditionnames, conditionnumbers, ncond] = get_glm_and_conditions(SubjectIDs, Dirs);
    elseif strcmp(datatype, 'anatomical')
        [Dirs, conditionnames, conditionnumbers, ncond] = get_anatomical_SC_specifics(Dirs);
    end
end

%% (4) Do the analysis
clc;
for r = 1:size(ROIs,2)   % For each ROI
    % *** A. Load in ROI information
    % Get ROInr
    roi = ROIs(r);
    
    % Clear ROI from previous iteration 
    clear ROI;
        
    % Check if ROI is already coregistered to your volume, if not,
    % coregistration will be done. 
    coregister_mask(SubjectIDs, Dirs, roi, datatype); 
    
    % Check if the coregistered ROI nifti file is already in a mat-file, if
    % not, it will be transformed to a mat-file. 
    convert_nifti_to_mat(Dirs, roi) 
    
    % Load in ROI file and get number of voxels
    load([Dirs.ROI num2str(roi) '.mat']); 
    nrVoxels = makeROI.selected.number;

    % *** B. Start analyses
    for c = 1:ncond % For each condition modelled
        condition = conditionnumbers(c); 
        
        clearvars -except do_generalization SubjectGroup1 SubjectGroup2 nperm subjectIDsgroup c conditionnumbers condition ncond SubjectIDs datatype nrVoxels Dirs conditionnames makeROI r roi ROIs nsubj_gr1 nsubj_gr2 do_permutation;
        ROI.XYZ = makeROI.selected.anatXYZ;

        % *** C. Load in data for every subject
        remove_voxels = [];
        nsj1 = 0;
        nsj2 = 0;
        if exist('nsubj_gr3', 'var')
            nsj3 = 0;
        end

        for subject = 1:size(SubjectIDs,2)
            % Current Subject
            SubjectID = char(SubjectIDs(subject)); 

            % which group
            if strcmp(SubjectID(1:2), 'G1')
                group = 1;
                nsj1 = nsj1 + 1;
                subjectIDsgroup{group}(nsj1) = {SubjectID(4:end)};
            elseif strcmp(SubjectID(1:2), 'G2')
                group = 2;
                nsj2 = nsj2 + 1;
                subjectIDsgroup{group}(nsj2) = {SubjectID(4:end)};
            else
                group = 3;
                nsj3 = nsj3 + 1;
                subjectIDsgroup{group}(nsj3) = {SubjectID(4:end)};
            end
                        
            if strcmp(datatype, 'functional')
                %load in the SPM.mat file 
                data_Dir = [Dirs.Data SubjectID(4:end) filesep Dirs.SubData];
                SPM_all = load([data_Dir 'SPM.mat']);

                % load in beta-values
                alltogether = load_in_data(SPM_all, data_Dir, condition, nrVoxels, ROI, datatype, []);
            elseif strcmp(datatype, 'anatomical')
                data_Dir = Dirs.Data;
                alltogether = load_in_data([], data_Dir, condition, nrVoxels, ROI, datatype, SubjectID);
            end               

            % Find non-informative voxels
            remove_voxels = [remove_voxels; find(alltogether == 0)];
            remove_voxels = unique(remove_voxels);

            % Put in big structure
            if group == 1
                ROI.Group{group}.All(:,nsj1) = alltogether;
            elseif group == 2
                ROI.Group{group}.All(:,nsj2) = alltogether;
            else
                ROI.Group{group}.All(:,nsj3) = alltogether;
            end

            % Clear certain variables before going to next subject
            clear alltogether SPM_all;
        end
        
        %% Remove voxels and standardize
        ngroups = size(who('SubjectGroup*'),1);
        for group = 1:ngroups
            ROI.Group{group}.All(remove_voxels,:) = [];
            for subject = 1:size(ROI.Group{group}.All,2)
                 ROI.Group{group}.Keepers(:,subject) = (ROI.Group{group}.All(:,subject) - mean(ROI.Group{group}.All(:,subject)) ./ std(ROI.Group{group}.All(:,subject)));
            end
        end

        newNrVoxels =  size(ROI.Group{1}.Keepers,1);

        %% Do the classification
        % Predefine certain variables to store the results
        for group = 1:ngroups
            v = genvarname(['nsubj_gr' num2str(group)]);
            eval(['subjectconfusion{group}.correct_freq_subjects = zeros(1,' v ');']);
            eval(['subjectconfusion{group}.total_freq_subjects = zeros(1,' v ');']);            
        end
 
        % Do nperm iterations across a leave-one-pair-out cross validation.
        disp('Classification/Generalization has started... Please be patient.'); 
        for perm=1:nperm
            if nperm/2 == perm
                disp('Halfway the classification/Generalization.'); 
            end
            
            if strcmp(do_generalization, 'no')
                [classRateAll(perm), subjectconfusion] = classification_algo(nsubj_gr1, nsubj_gr2, ROI, 'no', subjectIDsgroup, subjectconfusion);
            elseif strcmp(do_generalization, 'yes')
                clear subjectconfusion; 
                [classRateAll(perm,:)] = generalization_algo(nsubj_gr1, nsubj_gr2, nsubj_gr3, ROI, 'no');
            end
        end
        
        disp(['ROI: ' num2str(roi) ' and condition: ' conditionnames{condition}]);
        disp(['Classification accuracy: ' num2str(mean(mean(classRateAll)))]);

        %% Do Permutation if requested
        disp('Random Permutations have started... Yup, a bit more patience is required.');         
        if strcmp(do_permutation, 'yes')
            for perm = 1:nperm
                if nperm/2 == perm
                    disp('Halfway the random permutations.'); 
                end                
                
                if strcmp(do_generalization, 'no')
                    [randclass(perm), ~] = classification_algo(nsubj_gr1, nsubj_gr2, ROI, 'yes', subjectIDsgroup, subjectconfusion);
                elseif strcmp(do_generalization, 'yes')
                    clear subjectconfusion; 
                    [randclass(perm, :)] = generalization_algo(nsubj_gr1, nsubj_gr2, nsubj_gr3, ROI, 'yes');
                end
            end
            
            if strcmp(do_generalization, 'yes')
                generalization1 = Shuffle(1:nperm); 
                generalization1(nperm/2+1:end) = []; 
                generalization2 = Shuffle(1:nperm);
                generalization2(nperm/2+1:end) = [];
                
                orig_randclass = randclass;
                randclass = [randclass(generalization1,1); randclass(generalization2,2)];
            end
                
            
            sorted_rndprm = sort(randclass);
            how_many_larger = find(sorted_rndprm > mean(mean(classRateAll)));
            if isempty(how_many_larger); a = 0;
            else a = size(how_many_larger,2);
            end
            p_value = a/nperm; 
            disp(['P-value of classification accuracy: ' num2str(p_value)]);
            disp(['Statistisch 95%: ' num2str(sorted_rndprm(ceil(0.95*nperm)))]);
            disp(['Gemiddelde random permutatie: ' num2str(mean(sorted_rndprm))]);
        end

       % Save all the working space variables
       bad_char = '~ # % | * { } \ : < > ? / + | " -'; 
       for i = 1:size(bad_char,2)
           conditionnames{c} = strrep(conditionnames{c}, bad_char(i), '');
       end
       save([Dirs.Results conditionnames{c} '_ROI_' num2str(roi) '.mat']);
       
       % Write away classification results
       write_results_to_excel; 
    end
end