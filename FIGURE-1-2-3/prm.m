% PARAMETERS
% -----------
M = 8; % number of antennas at BS
K = 4; % number of users at cell
L = 16; % length of pilot sequences for each user
N = 512; % length of all data symbols in a block containing pilots
R = 500; % raduis of cell
f = 1.9*1e9;  % carrier frequency 
hB = 15; % height of BS 
hR = 1.65; % heigth of users' devices
d0 = 0.01*1e3; % defined in system model
d1 = 0.05*1e3; % defined in system model
sigmaShad = 8; % shadow fading variance
SNR = 0:5:40; % investigated SNRs
len = length(SNR); % number of SNRs to be experimented
