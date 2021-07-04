function []=featureExtract(filename)
clc;close all;
% ����Ƶ��
Fs = 125;
% ����
V_count = 1.2* 8388607.0 * 1.5 * 51.0;

% ����ĳ�����Ե�ʵ������
load(filename);        % events��sfreq��signals
% figure;
% ��һ����mark���ڶ����Ǹ���
% for i=3:17
%     plot(signals(i,:)-i*5+1);hold on;
% end
%% ����Ԥ����

% Ĭ�϶�ȡ������Ϊsignals
INPUT = zeros(15,length(signals));

% �˲�
for i=3:17
    % �ú�����ȥ��0~45���ȵ��ź�
    imf0=pEMDandFFT(signals(i,:),Fs);close;
    INPUT(i-2,:)= (imf0(3,:))./V_count/1e-6;
end

% �ص�����Ҫ�Ĳ���
tmp = find(signals(1,:)==12);
INPUT(:,1:tmp(1))=[];

% ƽ���زο�
REF = INPUT;
% REF(14,:) = []; % ȥ��14ͨ��������̫����
for i=1:15
    INPUT_reref = INPUT-mean(REF,1);
end

% 1.4.ɾ�������޴�����ݶ�
windowSize = 30;
CUTSIG = INPUT_reref;
oriLength = length(CUTSIG);
th = 10; % ����,��������10���Ե��ź���Ҫ��ȥ�����ǲ��������Ե��ź�
ALLCHCUT = []; %��¼�޴���ŵĲ�������
for ch = [1,2,3,4,5,6,7,8,9,10,11,12,13,15]
    CUT = [];
    one_ch = CUTSIG(ch,:);
    one_ch = [one_ch,one_ch(end:-1:end-windowSize-1)]; % ������չһ�����ڳ���
    for i=1:oriLength %���ڲ���һ��������
        window = one_ch(i:i+windowSize-1);
        if max(abs(window))>th
            CUT = [CUT,i];
        end
    end
    ALLCHCUT = [ALLCHCUT,CUT];
end
CUTSIG(:,sort(unique(ALLCHCUT))) = [];

% �۲�ɾ��Ч��
figure;
for i=1:15
    plot(CUTSIG(i,:)-i*5+1);hold on;
end

%% ����
win_width = Fs*20;  % 20s һ������
win_step = 100; % ���ڲ��������
INPUT = CUTSIG; %��Ԥ����������ݸ�ֵ��INPUT
win_N = floor((length(INPUT)-win_width)/win_step); %���㴰�ĸ���
% ��Ҫ����ı���
E5 = zeros(15,win_N,5);

for ch = 1:15
    disp(ch);
    res = INPUT(ch,:); % �ó�һ��ͨ��
    for i=1:win_N+1
        Sig = res((i-1)*win_step+1:(i-1)*win_step+win_width); % ��һ������epoch ����ΪSig
        [E5(ch,i,1),E5(ch,i,2),E5(ch,i,3),E5(ch,i,4),E5(ch,i,5)] =  myEwavelet(Sig); % �����ͨ�����ĸ�Ƶ�ʷ����������
        close all;
    end
end

%��ͼ
figure(200);
plot(smooth(E5(2,:,2)),'k','linewidth',1);
saveas(gcf,filename+"-energy.fig");
hold on;
%% ��
win_width = Fs*10; %���ڸ�Ϊ10s���м���
fold = floor(0.8*win_width);
L = length(INPUT); % �ܹ��ĳ���
t = 1:win_width-fold:L-win_width; % ���ִ�
En_all_channels_ApEn = zeros(15,length(t));
for ch=1:15
    disp(ch);
    for i = 1:length(t)
        Sig = INPUT(ch,t(i):t(i)+win_width-1); %��ĳһ�������ݸ�ֵ��Sig
        En_all_channels_ApEn(ch,i) = ApEn(1,0.12*std(Sig(32:593)),Sig(32:593),1);%�����ͨ���Ľ�����
        close all;
    end
end

%��ͼ
figure(300);
plot(smooth(En_all_channels_ApEn(9,:)),'k','linewidth',1);

saveas(gcf,filename+"-entropy.fig");

save(filename+"-final.mat","E5");
end