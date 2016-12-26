%% Function to do one permutation classification (train and test on same groups)
% Input:
%   - nsubj_gr1: number of subjects in group 1
%   - nsubj_gr2: number of subjects in group 2
%   - ROI: structure containing all the beta's for the subjects
%   - permute: 'yes' if you want shuffled traininglabels, 'no' if you want
%     a normal classification
%   - subjectIDsgroup: structure containing the IDs of subjects per group. 
%   - subjectconfusion: structure containing all the variables necessary to
%     calculate subjectconfusion.

% Output:
%   - classRateAll: the accuracy of the classification across the entire
%     leave-one-pair out iteration process
%   - subjectconfusion: structure containing all the variables necessary to
%   calculate subjectconfusion.

% JB - March 2016

function [classRateAll, subjectconfusion] = classification_algo(nsubj_gr1, nsubj_gr2, ROI, permute, subjectIDsgroup, subjectconfusion)

% find the minimum group
sample = min([nsubj_gr1 nsubj_gr2]);
% shuffle the subjects in each group
totest_group1 = Shuffle(1:nsubj_gr1);
totest_group2 = Shuffle(1:nsubj_gr2);

% do the classification with each sample of the group (all
% subjects in the sample with equal group sizes, a subsample of
% the largest group size wit unequal group sizes)
[classRateAll, subjectconfusion] = do_classification(ROI, totest_group1(1,1:sample), totest_group2(1,1:sample), permute, subjectIDsgroup, subjectconfusion);
