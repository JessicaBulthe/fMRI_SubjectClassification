%% Function to check if coregistered mask already exists or not. 
% If so, it will check if the volumes match between mask and data. If not,
% it will do the coregistration. 
% If not, it will take out the first beta value from the first subject as 
% reference volume. 

% Input:
%   _ SubjectIDs: the subjectIDs
%   - Dirs: structure containing all the necessary directories
%   - roi: the current ROI

% Output:
%   None. 

% JB - March 2016


function coregister_mask(SubjectIDs, Dirs, roi, datatype) 

% check if there is a coregistred file, whether it is in the right volume.
% If not, the file will be deleted. 
if exist([Dirs.ROI 'r' num2str(roi) '.nii'], 'file') == 2
    % get the data-volume of first subject
    if strcmp(datatype, 'functional')
        data_img = dir([Dirs.Data SubjectIDs{1}(4:end) filesep Dirs.SubData 'beta_0001*']);
        loaded_file = spm_vol([Dirs.Data SubjectIDs{1}(4:end) filesep Dirs.SubData data_img(end).name]);
    elseif strcmp(datatype, 'anatomical')
        data_img = dir([Dirs.Data 'wr*' SubjectIDs{1}(4:end) '.nii']);
        loaded_file = spm_vol([Dirs.Data data_img(end).name]); 
    end
        
    data_dim = loaded_file.dim; 
    
    % get the coregistred mask 
    loaded_mask = spm_vol([Dirs.ROI 'r' num2str(1) '.nii']);
    mask_dim = loaded_mask.dim; 
    
    % if dimensions are not equal, delete this coregistred mask
    if isequal(data_dim, mask_dim) ~= 1
        warning('Volume between existing coregistred mask and your data do not match. Coregistration to the right volume will be done.'); 
        delete([Dirs.ROI 'r' num2str(1) '.nii']); 
    end     
end

% if file doesn't exist
if exist([Dirs.ROI 'r' num2str(roi) '.nii'], 'file') ~= 2
    clear matlabbatch;

    if strcmp(datatype, 'functional')
        % get first beta-image of first subject
        beta_img = dir([Dirs.Data SubjectIDs{1}(4:end) filesep Dirs.SubData 'beta_0001*']);
        % Display message
        disp(['ROI ' num2str(roi) ' is being coregistred to ' Dirs.Data SubjectIDs{1}(4:end) filesep Dirs.SubData beta_img(end).name]); 
        % Reference image
        matlabbatch{1}.spm.spatial.coreg.write.ref{1} = [Dirs.Data SubjectIDs{1}(4:end) filesep Dirs.SubData beta_img(end).name];
    elseif strcmp(datatype, 'anatomical')
        % get anatomical image of first subject
        anat_img = dir([Dirs.Data 'wr' SubjectIDs{1}(4:end) '.nii']);
        % Display message
        disp(['ROI ' num2str(roi) ' is being coregistred to ' Dirs.Data anat_img(end).name]); 
        % Reference image
        matlabbatch{1}.spm.spatial.coreg.write.ref{1} = [Dirs.Data anat_img(end).name];
    end        

    % the other coregistration parameters 
    matlabbatch{1}.spm.spatial.coreg.write.source{1} = [Dirs.ROI num2str(roi) '.nii'];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 1;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    
    % do the coregistration
    spm_jobman('run', matlabbatch);
end
