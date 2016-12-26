%% Function to do one permutation generalization (train and test on different groups)
% Input:
%   - nsubj_gr1: number of subjects in group 1
%   - nsubj_gr2: number of subjects in group 2
%   - nsubj_gr3: number of subjects in group 3
%   - ROI: structure containing all the beta's for the subjects
%   - permute: 'yes' if you want shuffled traininglabels, 'no' if you want
%     a normal classification

% Output:
%   - classRateAll: the accuracy of the classification across the entire
%     leave-one-pair out iteration process. Average of the generalization
%     across both directions. 

% JB - March 2016

function [classRateAll] = generalization_algo(nsubj_gr1, nsubj_gr2, nsubj_gr3, ROI, permute)

% find the minimum group
sample = min([nsubj_gr1 nsubj_gr2 nsubj_gr3]);
% shuffle the subjects in each group
totest_group1 = Shuffle(1:nsubj_gr1);
totest_group2 = Shuffle(1:nsubj_gr2);
totest_group3 = Shuffle(1:nsubj_gr3);

% do the classification with each sample of the group (all
% subjects in the sample with equal group sizes, a subsample of
% the largest group size wit unequal group sizes)
[classRateAll] = do_generalization_classification(ROI, totest_group1(1,1:sample), totest_group2(1,1:sample), totest_group3(1,1:sample), permute);
