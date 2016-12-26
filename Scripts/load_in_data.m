

function alltogether = load_in_data(SPM_all, dataDir, condition, nrVoxels, ROI, datatype, SubjectID)

% Directory to go back to
back_to_dir = cd; 

% Go to betaDir
cd(dataDir);

% Pre-allocation of a
if strcmp(datatype, 'functional')
    a = zeros(SPM_all.SPM.xCon(1).Vspm.dim(1), SPM_all.SPM.xCon(1).Vspm.dim(2), SPM_all.SPM.xCon(1).Vspm.dim(3));
end

% Read in all the volumes
if strcmp(datatype, 'functional')
    b = dir([dataDir 'spmT_000' num2str(condition) '*']);
elseif strcmp(datatype, 'anatomical')
    b = dir([dataDir 'wr' SubjectID(4:end) '.nii']);
end
imgfile = load_nii([dataDir b(1).name]);
matrix = flipdim(imgfile.img, 1);
a = matrix(:,:,:);

% make big matrix
alltogether = zeros(nrVoxels, 1);
for voxel=1:nrVoxels
    condSig = a(ROI.XYZ(1,voxel),ROI.XYZ(2,voxel),ROI.XYZ(3,voxel));
    alltogether(voxel,1) = condSig;
end

% Go back to start dir
cd(back_to_dir); 