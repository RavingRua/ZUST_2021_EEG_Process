clear all
close all
%% 1.故障轴承信号
load dataHHT1000hz.mat  %加载故障轴承信号，该信号相关信息参数见https://ww2.mathworks.cn/help/signal/ref/hht.html#mw_6f663078-e183-4279-835c-e1cd231f251d
                        %dataHHT10000hz为帮助文档中的数据
                        %其中dataHHT1000hz的数据为采样频率为1000时的数据，与帮助文档中的数值有所不同，设置该组数据是应为10000hz采样频率的数据长度较长，在使用第三方库文件运算时会报错
figure;plot(t,yBad);    %绘制原始信号图像
%% 2.绘制希尔伯特谱
imf = pEMDandFFT(yBad,fs);  %绘制emd分解图及其频谱,该函数的源码获取方式见"代码说明.docx"
data = imf(1,:);
hhtSpec(data,fs)    %该函数的源码获取方式见"代码说明.docx"
% 绘制信号希尔伯特谱
% 输入：
% data： 待分析信号
% fs：   采样频率，当fs未知时，可以将fs设置为空（[]），并将type设置为2。此时hht图纵轴将经过标准化
% type： 当type的值为1时，则优先采用MATLAB自带库中的hht函数进行画图，采用的绘图风格也与自带hht函数保持一致，此时hht函数的用法与MATLAB自带函数一致；
%        当type的值为2时，则强制采用第三方库文件中的希尔伯特谱函数进行画图，不过可能会存在内存不够无法顺利画图的可能
%        如果type没有传入参数，则该函数内将type设置为1

% 关于希尔伯特变换及希尔伯特谱更多资料请看这里：
% https://zhuanlan.zhihu.com/p/136447202
% https://zhuanlan.zhihu.com/p/124257081
%% 3.绘制边际谱
[mgS,f] = marginalSpec(imf,fs);  %该函数的源码获取方式见"代码说明.docx"
% 绘制边际谱
% 输入：
% imf：  imf分量，注意方向：imf是每行一个信号分量的矩阵
% fs：   采样频率
% type： 当type的值为1时，则优先采用MATLAB自带库中的函数进行运算；
%        当type的值为2时，则强制采用第三方库文件中的函数进行运算，不过可能会存在内存不够无法顺利画图的可能（数组超过预设的最大数组大小）
%        如果type没有传入参数，则该函数内将type设置为1
%        经测试由于算法不同，使用两种库函数做出的边际谱存在幅值差异
% 输出：
% mgS：  边际谱幅值。
% f：    边际谱的频率轴。
% %% 4.绘制包络谱
% clear %清空工作区
% load dataEnv.mat  %加载轴承故障信号，外环故障频率为83.33Hz
% %[envS,f,xEnv] = envSpec(yBad,fs);  %该函数的源码获取方式见"代码说明.docx"
% 
% % 求信号包络谱
% % 输入：
% % data： 待分析信号
% % fs：   采样频率
% % 输出：
% % envS： 包络谱数值
% % f：    包络谱频率轴
% % xEnv： 包络线
% %% 5.瞬时频率/幅值/相位
% %[insF,insP,insA] = InsFPA(yBad,fs);  %该函数的源码获取方式见"代码说明.docx"
% % 求信号的瞬时频率、瞬时相位和瞬时幅值
% % 输入：
% % data： 目标信号
% % fs：   目标信号的采样频率
% % 输出：
% % insF： 瞬时频率
% % insP： 瞬时相位
% % insA： 瞬时幅值
% 
% % 画图。注意InsFPA函数中是不包含画图程序的，如需画图可以参考下述写法：
% %figure('Color','white');plot(t,insF,'k');title('瞬时频率(khScience.cn)');
% %figure('Color','white');plot(t,insP,'k');title('瞬时相位(khScience.cn)');
% %figure('Color','white');plot(t,insA,'k');title('瞬时幅值(khScience.cn)');

