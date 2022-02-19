
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

M = 64;
K = 8;
L = 16;
N = 512;
R = 500;
f = 1.9*1e9;
hB = 15;
hR = 1.65;
d0 = 0.01*1e3;
d1 = 0.05*1e3;
sigmaShad = 8;
SNR = 0:5:40;
len = length(SNR);
dataBlocks = 20;
errorsBuffer= zeros(3,len,dataBlocks); % saves errors occured in each block 
SER = zeros(3,len); % symbol error rate for all SNRs