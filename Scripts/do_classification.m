%% Function to do the classificaiton
% Input:
%   - ROI: structure containing all the beta's for the subjects
%   - totest_group1: the sample of subjects of group 1 (all of them with
%     equal groups, a subsample with unequal groups)
%   - totest_group2: the sample of subjects of group 2 all of them with
%     equal groups, a subsample with unequal groups)
%   - permute: 'yes' if you want shuffled traininglabels, 'no' if you want
%     a normal classification
%   - subjectIDsgroup: structure containing the IDs of subjects per group. 
%   - subjectconfusion: structure containing all the variables necessary to
%     calculate subjectconfusion.

% Output:
%   - acc: the accuracy of the classification across the entire
%     leave-one-pair out iteration process
%   - subjectconfusion: structure containing all the variables necessary to
%   calculate subjectconfusion.

% JB - March 2016


function  [acc, subjectconfusion] = do_classification(ROI, totest_group1, totest_group2, permute, subjectIDsgroup, subjectconfusion)

nrep = size(totest_group1,2);
shuffled_totest_group1 = Shuffle(totest_group1);
shuffled_totest_group2 = Shuffle(totest_group2);

% leave one pair out cross validation
for rep = 1:nrep
    % Clear variables every iteration
    clear trainingSamples trainingLabels testSamples testLabels
    
    % Divide training and test couples
    train_group1 = shuffled_totest_group1([1:rep-1 rep+1:end]);
    test_group1 = shuffled_totest_group1(rep);

    train_group2 = shuffled_totest_group2([1:rep-1 rep+1:end]);
    test_group2 = shuffled_totest_group2(rep); 
    
    % Get out training data for both groups
    trainingSamples = [ROI.Group{1}.Keepers(:,train_group1) ROI.Group{2}.Keepers(:,train_group2)];
    trainingLabels = [ones(1,size(train_group1,2)) repmat(2,1,size(train_group2,2))];

    % Get test data for both groups
    testSamples = [ROI.Group{1}.Keepers(:,test_group1) ROI.Group{2}.Keepers(:,test_group2)];
    testLabels = [1 2];
    TestSubjects = [subjectIDsgroup{1}(test_group1) subjectIDsgroup{2}(test_group2)];  % contains the ids per group

    % Train the model, if you want randperm, the labels of the trainingsamples
    % will be shuffled. 
    if strcmp(permute, 'no')
        model = svmtrain2(trainingLabels', trainingSamples', '-s 1 -t 0 -d 1 -g 1 -r 1 -c 1 -n 0.5 -p 0.1 -m 45 -e 0.001 -h 1 -q'); 
    elseif strcmp(permute, 'yes')
        model = svmtrain2(Shuffle(trainingLabels)', trainingSamples', '-s 1 -t 0 -d 1 -g 1 -r 1 -c 1 -n 0.5 -p 0.1 -m 45 -e 0.001 -h 1 -q');
    end

    % Test model 
    [x,~,~] = svmpredict2(testLabels', testSamples', model);

    % Get accuracy
    classRateAll(rep,:) = eq(x',testLabels);

    %% Get subjectconfusion
    correct_subjs = find([x'-testLabels]==0);
    correct_subjs = TestSubjects(correct_subjs); 

    for cs = 1:size(TestSubjects,2)
        % to which group does this subject belong and where in the matrix is this subject placed? 
        for g = 1:2
            [true_false, index] = ismember(TestSubjects(cs), subjectIDsgroup{g});
            if true_false
                group = g; 
                col = index;
            end
        end

        % add to the subjectconfusion measures
        if ismember(TestSubjects(cs), correct_subjs)
            subjectconfusion{group}.correct_freq_subjects(col) = subjectconfusion{group}.correct_freq_subjects(col) + 1;   
        end

        subjectconfusion{group}.total_freq_subjects(col) = subjectconfusion{group}.total_freq_subjects(col) + 1;
    end  
end

acc = mean(mean(classRateAll)); 

