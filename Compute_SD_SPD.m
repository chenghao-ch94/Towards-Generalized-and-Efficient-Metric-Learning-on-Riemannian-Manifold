function [S,D] = Compute_SD_SPD(LogC,labeltrain,n)
%% First Compute positive and negative sets S and D.
S=zeros(n,n);
D=zeros(n,n);
for i=1:size(LogC,3)
    for j=1:size(LogC,3)
        xx=LogC(:,:,i)-LogC(:,:,j);
        if(labeltrain(i)==labeltrain(j))
            S=S+xx'*xx;
        else
            D=D+xx'*xx;
        end
    end
end