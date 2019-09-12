clear all
clc
%% RMML_SPD and RMML_GM for YouTube Celebrities Dataset (YTC)http://seqamlab.com/youtube-celebrities-face-tracking-and-recognition-dataset/
%YTC dataset used in this paper can be download from https://pan.baidu.com/s/16xbwYAosBt5eR4F8BahvVQ pwd: ji52
%ytcrdlist.mat is generated randomly for all evaluation methods.
load('youtube47')
load('ytcrdlist')

% For YTC, we choose 3 and 6 samples for each class on train and test.
num_train=3;
num_test=6;

class=1;
temp=1;
for i=1:47*3
    if(temp<=3)
        labeltrain(i,1)=class;
        temp=temp+1;
    end
    if(temp==4)
        temp=1;
        class=class+1;
    end
end
class=1;
temp=1;
for i=1:47*6
    if(temp<=6)
        labeltest(i,1)=class;
        temp=temp+1;
    end
    if(temp==7)
        temp=1;
        class=class+1;
    end
end

% regularized parameter lambda needs to be no less than 0. weight parameter t is pre-selected by cross-validation
% b and alpha is used for the Logarithm computation for SPD matrixes following RAID-G.
lam=0;
tt=0.4; 
% for RMML_SPD 0.1 RMML_GM  0.4
b=0.75;
alpha=0.7;

for time=1
   sum_train=1;
   sum_test=1;
   for i=1:47
      temp=youtube47{i};
      for j=1:num_train
          img=temp{rdlist(time,j)};
          img2=uint8(img);     
          img3=histeq(img2);
          img4=imresize(img3,[400 size(img3,2)]);
          tr_dat{sum_train}=im2double(img4);
          sum_train=sum_train+1;
      end
      for k=(j+1):num_train+num_test
          img=temp{rdlist(time,k)};
          img2=uint8(img);    
          img3=histeq(img2);
          img4=imresize(img3,[400 size(img3,2)]);
          tt_dat{sum_test}=im2double(img4);
          sum_test=sum_test+1;
      end
   end
   tr_dat=reshape(tr_dat',47*3,1);
   tt_dat=reshape(tt_dat',47*6,1);
   [ti(time),f(time)]=RMML(labeltrain,labeltest,tr_dat,tt_dat,b,lam,tt,alpha);
end
fprintf('Rate = %.4f percent , Train time = %f\n',mean(f),mean(ti));
