function[]=preProcess(filename)

% 读取要进行实验内容分离处理的mat
load(filename);

index=1;

% 需要的内容的mark标记数值
need=12;

[~,n]=size(signals);

% 存放每个实验数据的变量，如需扩展在后方增加
e1=zeros(17,1);e2=zeros(17,1);e3=zeros(17,1);

isNew=false;
for i=1:1:n
    if signals(1,i)==need
        if isNew==false
            isNew=true;
        end
        switch index
            case 1
                e1=[e1(:,:),signals(:,i)];
            case 2
                e2=[e2(:,:),signals(:,i)];
            case 3
                e3=[e3(:,:),signals(:,i)];
        end
    elseif isNew==true
        disp("experiment processed");
        index=index+1;
        isNew=false;
    end
end

e1=[e1(:,:),zeros(17,1)];
e2=[e2(:,:),zeros(17,1)];
e3=[e3(:,:),zeros(17,1)];

% Feature_extract中需要处理的矩阵名为signals，因此此处保存该变量
% 之后使用Feature_extract时直接load e*.mat
signals=e1;
save(filename+"-e1.mat","signals");
signals=e2;
save(filename+"-e2.mat","signals");
signals=e3;
save(filename+"-e3.mat","signals");
clear;
end