function regionD = Com_Cov(theD,b,alpha)
%% calculate logarithm of SPD matrix with gaussian model.
% For  theoretical and technical details, please refer to the following paper:
% Qilong Wang, Peihua Li, Wangmeng Zuo, and Lei Zhang. RAID-G: Robust Estimation of 
% Approximate Infinite Dimensional Gaussian with Application to Material Recognition. 
% IEEE Conference on Computer Vision and Pattern Recognition Pattern Recognition (CVPR), 2016.

power=0.75; %0.75
for i=1:size(theD,2)
    theD(:,i)=sign(theD(:,i)).*abs(theD(:,i)).^power;
end
Rfeat_dim=size(theD,1);
shift = 1e-03.*eye(Rfeat_dim);
regionD = ones(size(theD,1)+1); 
gama = (1-alpha)/(2*alpha);
b2 = b^2;

COVD = cov(theD') + trace(cov(theD')).*shift;         % S hat

[U S V] = svd(COVD);
diag_S = diag(S);      
diag_S = sign(diag_S).*((gama.^2+abs(diag_S/alpha)).^(0.55)-gama);
COVD = U*(diag(diag_S))*U'; 

regionD(1:size(theD,1),1:size(theD,1)) = (COVD + b2.*(mean(theD,2)*mean(theD,2)')); 
regionD(1:size(theD,1),1+size(theD,1)) =  b.*mean(theD,2);
regionD(1+size(theD,1),1:size(theD,1)) =  b.*mean(theD,2)';

[U, S, V] = svd(regionD);         
diag_S = diag(S);
diag_S = diag_S + 1e-16;
log_diag_S = sign(diag_S).*abs(diag_S).^(0.9);
regionD = U*(diag(log_diag_S))*U'; 
