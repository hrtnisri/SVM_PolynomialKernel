clear all
clc

[FileName,PathName] = uigetfile('*/.xlsx','Schizophrenia dataset');
cldata = xlsread([PathName FileName]);
[nrow,ncol]=size(cldata);

X = cldata(:, ncol-1);
Y = cldata(:, ncol);

hasil = zeros(10,6);
kp = [1,2,3,4,5,6,7,8,9,10];
for i=1:size(kp, 2)
    q = kp(i);
    rng('default')
    SVMModel = fitcsvm(X,Y, 'KernelFunction', 'polynomial',...
    'PolynomialOrder', q, 'CrossVal', 'on', 'KFold', 10, ...
    'RemoveDuplicates', true, 'Standardize', true, ...
    'OutlierFraction', 0.1);
    tic
    label = kfoldPredict(SVMModel);
    cp = classperf(Y, label);
    
    hasil(i,6)=toc;
    hasil(i,1)=cp.CorrectRate*100;
    hasil(i,2)=cp.Sensitivity*100;
    hasil(i,3)=cp.PositivePredictiveValue*100;
    hasil(i,4)=cp.Specificity*100;
    F1_score = (2*cp.PositivePredictiveValue*cp.Sensitivity)/(cp.PositivePredictiveValue+cp.Sensitivity);
    hasil(i,5)=F1_score*100;
end
hasil