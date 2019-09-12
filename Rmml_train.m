function [trtime,A] = Rmml_train(S,D,Q_0,params)
%% Compute A with the closed-form solution
tic
lamda=params(1);
t=params(2);
M=inv(S+lamda*inv(Q_0));        
N=D+lamda*Q_0;
A=M^(1/2)*(M^(-1/2)*N*M^(-1/2))^t*M^(1/2);
trtime=toc
%% Also we can compute A in the following way.
%A=expm((-(1-t)*logm(M)+t*logm(N))/2);
end

