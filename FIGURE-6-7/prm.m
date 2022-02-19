
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

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
SNR = [30 15];
len = length(SNR);
Antennas = [8 16 32 64 128 256 512 1024];
AntennaMSE1 = zeros(len,length(Antennas));
AntennaMSE2 = zeros(len,length(Antennas));
AntennaMSE = zeros(len,length(Antennas));
AntennaDetCRB = zeros(len,length(Antennas));