clear 
clc
%% PARAMETERS
prm
%% DATA GENERATION
dataGen
%% COMPUTATIONS OF SYSTEM MODEL, ML ALGORITHMS AND THE RECEIVED SIGNAL AT BS
preComputations
%% EM ALGORITHM
EMalgorithm
%% DETERMINISTIC CRB
detCRB
%% STOCHASTIC CRB
% stochCRB        % Running this part takes a long time. I've provided the
                  % stochastic CRB  matrix and corresponding matrices G and beta
                  % in a mat file. If you want to run the code please
                  % uncomment it plus the part in the plots.
%% PLOTS
figure()
semilogy(SNR,MSE1,'m--+','LineWidth',1.5)
hold on
semilogy(SNR,MSE3Theory,'c--*','LineWidth',1.5)
hold on
% semilogy(SNR,channelstocCRB,'r--^','LineWidth',1.5,'MarkerFaceColor', 'r')
% hold on
semilogy(SNR,channelCRB,'g--v','LineWidth',1.5,'MarkerFaceColor', 'g')
hold on
semilogy(SNR,MSE,'b-o','LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(SNR,MSE2,'k:X','LineWidth',1.5)
% legend('ML Training, L = 16','ML Training, L = 128','CRB Stochastic, L = 16','CRB Deterministic, L = 16','EM, L = 16','ML Full Data, L = 16')
legend('ML Training, L = 16','ML Training, L = 128','CRB Deterministic, L = 16','EM, L = 16','ML Full Data, L = 16')
title('Figure (4), Scaled MSE versus SNR with M = 64, K = 8, and N = 512')
xlabel('SNR(dB)')
ylabel('MSE / E(\beta)')