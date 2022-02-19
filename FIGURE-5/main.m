clear
clc
%% PARAMETERS
prm
%% DATA GENERATION
dataGen
%% TESTING FOR 20 CONSECUTIVE BLOCKS OF DATA
for experiments=1:dataBlocks
    %% COMPUTATIONS OF SYSTEM MODEL, ML ALGORITHMS AND THE RECEIVED SIGNAL
    preComputations
    %% EM ALGORITHM
    EMalgorithm
    %% SER (SYMBOL ERROR RATE) FOR EACH BLOCK
    SymbolErrorRate
end
%% TOTAL SER
SER(:,:) = squeeze(sum(errorsBuffer,3))/(dataBlocks*K*(N-L));    
%% PLOTS
figure()
semilogy(SNR,SER(1,:),'m--+','LineWidth',2);
hold on
semilogy(SNR,SER(2,:),'k:X','LineWidth',2);
hold on
semilogy(SNR,SER(3,:),'b-o','LineWidth',1.5,'MarkerFaceColor', 'b');
xlim([0,40])
ylim([1e-5 1])
title('Symbol error rate versus SNR with M = 64, K = 8, L = 16, and N = 512')
xlabel('SNR (dB)')
ylabel('Symbol Error Rate')
legend('ML Training','ML Full Data','EM')