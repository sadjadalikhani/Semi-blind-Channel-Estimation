
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

% PARAMETERS
M = 8*8;
K = 4*2;
L = 16;
N = 512;
R = 500;
f = 1.9*1e9;
H = zeros(M,K);
hB = 15;
hR = 1.65;
d0 = 0.01*1e3;
d1 = 0.05*1e3;
sigmaShad = 8;
SNR = [15 30];
len = length(SNR);
e = 20;
G = zeros(M,K,e);
finalgHat = zeros(M,K,len,e);
gHat1 = zeros(M,K,len,e);
gHat2 = zeros(M,K,len,e);