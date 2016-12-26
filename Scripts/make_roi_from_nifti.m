%% Make ROI.mat file from nifti file 

for roi = 11:24
    % load in nifti file
    mask = spm_vol(['E:\Research\Dyscalculie Studie\fMRI\ROIs\Masks\' num2str(roi) '.nii']);

    % volume size 
    volumesize = [84 101 62];

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
    save(['E:\Research\Dyscalculie Studie\fMRI\SubjectClassification\ROIs\' num2str(roi) '.mat'], 'makeROI');
end