% 主入口
% 每次使用前清除一次工作区防止变量名冲突
% 更改preProcess和featureExtract的参数来选择要处理的文件
% 要处理的mat文件放在同一个文件夹下

% 第一步：预处理，将每次实验的三个部分分开，并保存为mat
clear;
disp("pre process");
preProcess("2021_07_02_11_06_46-raw");

% 第二步，进行源数据预处理，筛选出有效部分并生成图表和最终数据矩阵
clear;
disp("e1");
featureExtract("2021_07_02_11_06_46-raw"+"-e1");    % 不要更改字符串连接的部分，即+"-e*"，更改前部文件名

clear;
disp("e2");
featureExtract("2021_07_02_11_06_46-raw"+"-e2");

clear;
disp("e3");
featureExtract("2021_07_02_11_06_46-raw"+"-e3");