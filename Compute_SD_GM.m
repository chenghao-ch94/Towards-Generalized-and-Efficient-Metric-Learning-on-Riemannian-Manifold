function[S D]=Compute_SD_GM(data,label)
    n=length(data{1,1});
    sum_s=0;
    sum_d=0;
    S=zeros(n,n);
    D=zeros(n,n);
    d=length(label);
    for i=1:d
        Y_i=data{i,1};
        yii=Y_i*Y_i';
        for j=1:d
            Y_j=data{j,1};
            yjj=Y_j*Y_j';
            if(label(i)==label(j))
                S=S+(yii-yjj)*(yii-yjj)';
                sum_s=sum_s+1;
            else
                D=D+(yii-yjj)*(yii-yjj)';
                sum_d=sum_d+1;
            end
        end
    end
    S=S/sum_s;
    D=D/sum_d;
end