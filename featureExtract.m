function []=featureExtract(filename)
clc;close all;
% 采样频率
Fs = 125;
% 参数
V_count = 1.2* 8388607.0 * 1.5 * 51.0;

% 导入某个被试的实验数据
load(filename);        % events、sfreq、signals
% figure;
% 第一行是mark，第二行是干扰
% for i=3:17
%     plot(signals(i,:)-i*5+1);hold on;
% end
%% 数据预处理

% 默认读取的内容为signals
INPUT = zeros(15,length(signals));

% 滤波
for i=3:17
    % 该函数会去除0~45赫兹的信号
    imf0=pEMDandFFT(signals(i,:),Fs);close;
    INPUT(i-2,:)= (imf0(3,:))./V_count/1e-6;
end

% 截掉不需要的部分
tmp = find(signals(1,:)==12);
INPUT(:,1:tmp(1))=[];

% 平均重参考
REF = INPUT;
% REF(14,:) = []; % 去掉14通道，干扰太大了
for i=1:15
    INPUT_reref = INPUT-mean(REF,1);
end

% 1.4.删掉波动巨大的数据段
windowSize = 30;
CUTSIG = INPUT_reref;
oriLength = length(CUTSIG);
th = 10; % 界限,波动超过10的脑电信号需要被去除，是不正常的脑电信号
ALLCHCUT = []; %记录巨大干扰的采样点编号
for ch = [1,2,3,4,5,6,7,8,9,10,11,12,13,15]
    CUT = [];
    one_ch = CUTSIG(ch,:);
    one_ch = [one_ch,one_ch(end:-1:end-windowSize-1)]; % 镜像扩展一个窗口长度
    for i=1:oriLength %窗口步进一个采样点
        window = one_ch(i:i+windowSize-1);
        if max(abs(window))>th
            CUT = [CUT,i];
        end
    end
    ALLCHCUT = [ALLCHCUT,CUT];
end
CUTSIG(:,sort(unique(ALLCHCUT))) = [];

% 观察删除效果
figure;
for i=1:15
    plot(CUTSIG(i,:)-i*5+1);hold on;
end

%% 能量
win_width = Fs*20;  % 20s 一个窗口
win_step = 100; % 窗口步进点个数
INPUT = CUTSIG; %将预处理过的数据赋值给INPUT
win_N = floor((length(INPUT)-win_width)/win_step); %计算窗的个数
% 需要保存的变量
E5 = zeros(15,win_N,5);

for ch = 1:15
    disp(ch);
    res = INPUT(ch,:); % 拿出一个通道
    for i=1:win_N+1
        Sig = res((i-1)*win_step+1:(i-1)*win_step+win_width); % 截一窗数据epoch 保存为Sig
        [E5(ch,i,1),E5(ch,i,2),E5(ch,i,3),E5(ch,i,4),E5(ch,i,5)] =  myEwavelet(Sig); % 计算此通道的四个频率分量相对能量
        close all;
    end
end

%画图
figure(200);
plot(smooth(E5(2,:,2)),'k','linewidth',1);
saveas(gcf,filename+"-energy.fig");
hold on;
%% 熵
win_width = Fs*10; %窗口改为10s进行计算
fold = floor(0.8*win_width);
L = length(INPUT); % 总共的长度
t = 1:win_width-fold:L-win_width; % 划分窗
En_all_channels_ApEn = zeros(15,length(t));
for ch=1:15
    disp(ch);
    for i = 1:length(t)
        Sig = INPUT(ch,t(i):t(i)+win_width-1); %将某一窗的数据赋值给Sig
        En_all_channels_ApEn(ch,i) = ApEn(1,0.12*std(Sig(32:593)),Sig(32:593),1);%计算此通道的近似熵
        close all;
    end
end

%画图
figure(300);
plot(smooth(En_all_channels_ApEn(9,:)),'k','linewidth',1);

saveas(gcf,filename+"-entropy.fig");

save(filename+"-final.mat","E5");
end