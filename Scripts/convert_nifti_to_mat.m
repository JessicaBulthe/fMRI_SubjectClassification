%% Function to check if coregistered mask is already converted to a mat-file. 
% If not, it will do this.

% Input:
%   - Dirs: structure containing all the necessary directories
%   - roi: the current ROI

% Output:
%   None. 

% JB - March 2016

function convert_nifti_to_mat(Dirs, roi) 

% if file doesn't exist
if exist([Dirs.ROI num2str(roi) '.mat'], 'file') ~= 2
    % Display message
    disp(['ROI ' num2str(roi) ' is converted to a mat-file.']); 
    
    % load in coregistred nifti file
    mask = spm_vol([Dirs.ROI 'r' num2str(roi) '.nii']);

    % volume size 
    volumesize = mask.dim;

    % get out x y z coords
    [x,y,z] = ind2sub(size(mask.private.dat),find(mask.private.dat(:,:,:) == 1));

    % makeROI structure
    makeROI.selected.anatXYZ = [x y z]';

    % remove voxels outside scanned volume 
    for i = 1:3
        cols = find(makeROI.selected.anatXYZ(i,:) > volumesize(i));
        if size(cols,2) > 0
            makeROI.selected.anatXYZ(:,cols) = [];
        end
    end

    % number voxels
    makeROI.selected.number = size(makeROI.selected.anatXYZ,2);

    % save ROI
    save([Dirs.ROI num2str(roi) '.mat'], 'makeROI');
end
