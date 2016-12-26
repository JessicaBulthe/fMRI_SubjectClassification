%% Function to do the generalization
% Input:
%   - ROI: structure containing all the beta's for the subjects
%   - totest_group1: the sample of subjects of the group that will be used
%     in training AND testing
%   - totest_group2: the sample of subjects of the group that only will be
%     used in training OR testing.
%   - totest_group3: the sample of subjects of the group that only will be
%     used in training OR testing.
%   - permute: 'yes' if you want shuffled traininglabels, 'no' if you want
%     a normal classification

% Output:
%   - acc: the accuracy of the classification across the entire
%     leave-one-pair out iteration process

% JB - March 2016


function  [acc] = do_generalization_classification(ROI, totest_group1, totest_group2, totest_group3, permute)

nrep = size(totest_group1,2);

shuffled_totest_group1 = Shuffle(totest_group1);
shuffled_totest_group2 = Shuffle(totest_group2);
shuffled_totest_group3 = Shuffle(totest_group3);

% leave one pair out cross validation
for rep = 1:nrep
    % Clear variables every iteration
    clear trainingSamples trainingLabels testSamples testLabels
    
    % Divide training and test couples
    train_group1 = shuffled_totest_group1([1:rep-1 rep+1:end]);
    test_group1 = shuffled_totest_group1(rep);

    train_group2 = shuffled_totest_group2([1:rep-1 rep+1:end]);
    test_group2 = shuffled_totest_group2(rep); 
    
    train_group3 = shuffled_totest_group3([1:rep-1 rep+1:end]);
    test_group3 = shuffled_totest_group3(rep);    
    
    % FOR DIRECTION 1
        % Get out training data for both groups
        trainingSamples = [ROI.Group{1}.Keepers(:,train_group1) ROI.Group{2}.Keepers(:,train_group2)];
        trainingLabels = [ones(1,size(train_group1,2)) repmat(2,1,size(train_group2,2))];

        % Get test data for both groups
        testSamples = [ROI.Group{1}.Keepers(:,test_group1) ROI.Group{3}.Keepers(:,test_group3)];
        testLabels = [1 2];

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
        direction1(rep,:) = eq(x',testLabels);
        
    % FOR DIRECTION 2
        clear trainingSamples trainingLabels testSamples testLabels
        
        % Get out training data for both groups
        trainingSamples = [ROI.Group{1}.Keepers(:,train_group1) ROI.Group{3}.Keepers(:,train_group3)];
        trainingLabels = [ones(1,size(train_group1,2)) repmat(2,1,size(train_group3,2))];

        % Get test data for both groups
        testSamples = [ROI.Group{1}.Keepers(:,test_group1) ROI.Group{2}.Keepers(:,test_group2)];
        testLabels = [1 2];

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
        direction2(rep,:) = eq(x',testLabels);
end

acc1 = mean(mean(direction1)); 
acc2 = mean(mean(direction2)); 
acc = [acc1 acc2]; 

