function classify_PCAL1(dataset,iRep)
% Calculate the classification accuracy of PCA-L1. 
% 2022-6-26 00:34:45

% Laplacian matrix
tic;
load(sprintf('data/%s_Laplacian.mat',dataset),'L');

% load data
load(sprintf('data/%s_r%d.mat',dataset,iRep));

% PCA-L1, a speical case of RSSPCA when eta_1=0 and eta_2=0
nPV=30; % number of projection vectors
[W,iter]=RSSPCA(x_train,L,0,0,nPV);  

% reserve the projection results
x_train_reserve=W'*x_train;
x_test_reserve=W'*x_test;
t0=toc;

% classification
tic;
accuracy=zeros(nPV,1);
for iPV=1:nPV
    x_train_proj=x_train_reserve(1:iPV,:);
    x_test_proj=x_test_reserve(1:iPV,:);
    
    % nearest neighbor classifier
    dxx=pdist2(x_train_proj',x_test_proj');
    [~,ix]=min(dxx);
    label_predict=label_train(ix);
    
    accuracy(iPV)=mean(label_predict==label_test);
    perct(toc,iPV,nPV,10);
end
t1=toc;
time=(t0+t1)/60;

% save the classification accuracies
save(sprintf('result/classify_PCAL1_%s_iRep_%d.mat',dataset,iRep),'accuracy','iter','time');