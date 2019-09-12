function sub = Compute_Sub(data,sub_dim)
% calculate subspaces with a fixed dim
num=length(data);
sub = cell(num,1);
for ind=1:num
    Y1=data{ind};
    y1_mu = mean(Y1,2);
    
    Y1 = Y1-repmat(y1_mu,1,size(Y1,2));
    Y1 = Y1*Y1'/(size(Y1,2)-1);
    lamda = 0.001*trace(Y1);
    Y1 = Y1+lamda*eye(size(Y1,1));
    
    [U, S, V] = svd(Y1);    
    sub{ind}= U(:,1:sub_dim);
       
end