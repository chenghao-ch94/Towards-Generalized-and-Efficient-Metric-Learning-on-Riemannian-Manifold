function [trtime,fRate]=RMML(labeltrain,labeltest,trset,teset,b,lam,tt,alpha)
% filename=['result.txt'];
% fid=fopen(filename,'a+');
%%
% set gallery sets and probe sets
%tic
% calculate logarithm of SPD feature for RMML_SPD
% for i=1:size(trset,1)
%     LogC(:,:,i) = Com_Cov(trset{i,1},b,alpha);
% end
% for i=1:size(teset,1)
%     LogC_t(:,:,i) = Com_Cov(teset{i,1},b,alpha);
% end

% calculate subspace of Grassmann Manifold for RMML_GM
sub_dim = 10;
Sub = Compute_Sub(trset,sub_dim);
Sub_t = Compute_Sub(teset,sub_dim);
%toc
%% parameter setting and initialization

%n = size(LogC,1);
n = size(Sub{1,1},1);
params=[lam;tt];

% initialization of RMML model
Q_0 = eye(n);

% for RMML_SPD
% [S,D] = Compute_SD_SPD(LogC,labeltrain,n);

% for RMML_GM
[S D]=Compute_SD_GM(Sub,labeltrain');

% training code of RMML model
[trtime A] = Rmml_train(S,D,Q_0,params);
%% calculate similarity
% tic
sim_mat = zeros(length(labeltrain),length(labeltest));
% for RMML_SPD
% for i = 1 : length(labeltrain)
%     T1=LogC(:,:,i);
%     for j = 1 : length(labeltest)
%         T2=LogC_t(:,:,j);
%         T = T1-T2;
%         T = T'*T;
%         sim_mat(i,j) = trace(A*T);
%     end
% end

% for RMML_GM
for i = 1 : length(labeltrain)
    Yi=Sub{i,1};
    for j = 1 : length(labeltest)
        Yj=Sub_t{j,1};
        Q=Yi*Yi'-Yj*Yj';
        sim_mat(i,j) = trace(A*Q*Q');
    end
end

%% calculate accuracy
sampleNum = length(labeltest);
[sim ind] = sort(sim_mat,1,'ascend');
correctNum = length(find((labeltest-labeltrain(ind(1,:)))==0));
fRate = correctNum/sampleNum;
fprintf('fRate = %f \n', fRate);
% testtime=toc;
% fprintf(fid,'\n Rate = %.4f percent ,Time = %f\n',fRate,trtime);
% fclose('all');
end
