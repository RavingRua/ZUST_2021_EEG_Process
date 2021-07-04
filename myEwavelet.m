function [E_delta,E_theta,E_alpha,E_beta,E_gamma] = myEwavelet(x)

order = 6;
wpt=wpdec(x,order,'db10'); %进行3层小波包分解

nodesNum = 2^(order+1)-2;  % 3阶为例：不算根节点  第二层 1 2  第三层 3 4 5 6 第三层 7 8 9 10 11 12 13 14
nodes = nodesNum-2^order+1:nodesNum;
nodes_ord = wpfrqord(nodes'); % 格雷码编码结果

E_wavelet = wenergy(wpt);
E_wavelet(:) = E_wavelet(nodes_ord(:)); % 顺序调整好

E_delta = sum(E_wavelet(1:2));
E_theta = sum(E_wavelet(3:4));
E_alpha = sum(E_wavelet(5:7));
E_beta = sum(E_wavelet(8:15));
E_gamma = sum(E_wavelet(15:24));

figure
% 0    1.9531    3.9063    5.8594    7.8125    9.7656   11.7188   13.6719   15.6250   17.5781   19.5313   21.4844   23.4375   25.3906   27.3438   29.2969   31.2500
% 31.2500   33.2031   35.1563   37.1094   39.0625   41.0156   42.9688   44.9219   46.8750 (24)  48.8281 这里可能有工频干扰了  50.7813   52.7344   54.6875   56.6406   58.5938   60.5469   62.5000
end

