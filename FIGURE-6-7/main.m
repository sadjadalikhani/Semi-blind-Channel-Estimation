
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

clear 
clc
%% PARAMETERS
prm
%% DEFINES SYSTEM MODEL AND GENERATES DATA
systemModel_dataGen
%% TESTING FOR 8 DIFFERENT NUMBER OF ANTENNAS AT BS
for ant = 1:length(Antennas)
    %% COMPUTES SYSTEM MODEL, ML ALGORITHMS AND RECEIVED SIGNALS AT BS
    preComputations
    %% EM ALGORITHM
    EMalgorithm
    %% DETERMINISTIC CRB
    detCRB
    %% SCALED MSE / M
    % all obtained MSEs have to be divided by the number of antennas at
    % that experiment
    AntennaMSE1(:,ant) = MSE1/Antennas(ant);  % ML-Trainig estimator
    AntennaMSE2(:,ant) = MSE2/Antennas(ant);  % ML Full data estimator
    AntennaMSE(:,ant) = MSE/Antennas(ant);    % EM algorithm(semi-blind)
    AntennaDetCRB(:,ant) = channelCRB/Antennas(ant); % deterministic CRB of channel
end    
%% PLOTS
counter = 0:length(Antennas)-1;
figure()
Xaxis = {'8';'16';'32';'64';'128';'256';'512';'1024'};
semilogy(counter,AntennaMSE1(2,:),'m--+','LineWidth',1.5)
hold on
semilogy(counter,AntennaMSE2(2,:),'k:X','LineWidth',1.5)
hold on
semilogy(counter,AntennaMSE(2,:),'b-o','LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(counter(1:length(Antennas)-1),AntennaDetCRB(2,1:length(Antennas)-1),'g--v','LineWidth',1.5,'MarkerFaceColor', 'g')
set(gca,'xtick',[0:7],'xticklabel',Xaxis)
xlabel('M (Number of Antennas at BS)')
ylabel('MSE / (M * E(\beta))')
title('Figure (6) - MSE / M versus M with K = 8, L = 16, N = 512, and SNR = 15 dB')
legend('ML Training','ML Full Data','EM','CRB Deterministic')
ylim([1e-4 1e-1])
    
 
figure()
Xaxis = {'8';'16';'32';'64';'128';'256';'512';'1024'};
semilogy(counter,AntennaMSE1(1,:),'m--+','LineWidth',1.5)
hold on
semilogy(counter,AntennaMSE2(1,:),'k:X','LineWidth',1.5)
hold on
semilogy(counter,AntennaMSE(1,:),'b-o','LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(counter(1:length(Antennas)-1),AntennaDetCRB(1,1:length(Antennas)-1),'g--v','LineWidth',1.5,'MarkerFaceColor', 'g')
set(gca,'xtick',[0:7],'xticklabel',Xaxis)
xlabel('M (Number of Antennas at BS)')
ylabel('MSE / (M * E(\beta))')
title('Figure (7) - MSE / M versus M with K = 8, L = 16, N = 512, and SNR = 30 dB')
legend('ML Training','ML Full Data','EM','CRB Deterministic')  
    
    
    