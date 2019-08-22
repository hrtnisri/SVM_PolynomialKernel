clear all
clc

%$ import dataset
[FileName,PathName] = uigetfile('*/.xlsx','dataset');
cldata = xlsread([PathName FileName]);
[nrow,ncol]=size(cldata);

X = cldata(:, ncol-1);
Y = cldata(:, ncol);

%% the process
% initialize results matrix as 'hasil' matrix
hasil = zeros(10,6);
% evaluate SVM based on polynomial kernel using 10-fold cross validation
for q=1:10
    rng('default')
    SVMModel = fitcsvm(X,Y, 'KernelFunction', 'polynomial',...
    'PolynomialOrder', q, 'CrossVal', 'on', 'KFold', 10, ...
    'RemoveDuplicates', true, 'Standardize', true, ...
    'OutlierFraction', 0.1);
    tic
    label = kfoldPredict(SVMModel);
    cp = classperf(Y, label);

    hasil(i,6)=toc;
    hasil(i,1)=cp.CorrectRate*100; %accuracy
    hasil(i,2)=cp.Sensitivity*100; %sensitivity
    hasil(i,3)=cp.PositivePredictiveValue*100; %precision
    hasil(i,4)=cp.Specificity*100; %specificity
    F1_score = (2*cp.PositivePredictiveValue*cp.Sensitivity)/(cp.PositivePredictiveValue+cp.Sensitivity);
    hasil(i,5)=F1_score*100; %F1-Score
end

%% print the output
hasil
