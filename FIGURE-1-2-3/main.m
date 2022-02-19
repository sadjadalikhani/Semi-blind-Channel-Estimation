clear 
clc
%% PARAMETERS
prm
%% DATA GENERATION 
dataGen
%% ML ALGORITHM
MLAlg
%% EM ALGORITHM REQUIREMENTS
EMAlgReq
%% EM ALGORITHM
EMAlg
%% FIGURE 1 PLOT
figure()
semilogy(SNR,MSE1,'m--+','LineWidth',1.5)
hold on
semilogy(SNR,MSE2,'k:X','LineWidth',1.5)
hold on
semilogy(SNR,MSE,'b-o','LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(SNR,MSENorm,"g-^",'LineWidth',1.5,'MarkerFaceColor', 'g')
hold on
semilogy(SNR,MSEPrior,"r-d",'LineWidth',1.5,'MarkerFaceColor', 'r')
title('Figure (1) , Scaled MSE versus SNR with M = 8, K = 4, L = 16 and N = 512')
xlabel('SNR(dB)')
ylabel('MSE / E(\beta)')
legend('ML Training','ML Full Data','EM','EM Gaussian Data','EM With Prior')
%% FIGURE 2 PLOT
figure()
iter = 1:10;
semilogy(iter,MSE15dB(1:10),"b-o",'LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(iter,ones(1,10)*MSE1(15/(40/(len-1))+1),'m--+','LineWidth',1.5)
hold on
semilogy(iter,ones(1,10)*MSE2(15/(40/(len-1))+1),'k:X','LineWidth',1.5)
ylim([1e-3 1e0])
title('Figure (2) , SNR = 15dB')
xlabel('Number of iterations')
ylabel('MSE / E(\beta)')
legend('EM','ML Training','ML Full Data')
%% FIGURE 3 PLOT
figure()
semilogy(iter,MSE30dB(1:10),"b-o",'LineWidth',1.5,'MarkerFaceColor', 'b')
hold on
semilogy(iter,ones(1,10)*MSE1(30/(40/(len-1))+1),'m--+','LineWidth',1.5)
hold on
semilogy(iter,ones(1,10)*MSE2(30/(40/(len-1))+1),'k:X','LineWidth',1.5)
ylim([1e-5 1e-2])
title('Figure (3) , SNR = 30dB')
xlabel('Number of iterations')
ylabel('MSE / E(\beta)')
legend('EM','ML Training','ML Full Data')
%% FIGURE 2-1 PLOT
% figure()
% semilogy(SNR,MSE1,'m--+','LineWidth',1.5)
% hold on
% semilogy(SNR,MSE2,'k:X','LineWidth',1.5)
% hold on
% semilogy(SNR,MSE1Theory,"m-o",'LineWidth',1)
% hold on
% semilogy(SNR,MSE2Theory,"k-o",'LineWidth',1)
% title('Figure (1-2) , Scaled MSE versus SNR with M = 8, K = 4, L = 16 and N = 512')
% xlabel('SNR(dB)')
% ylabel('MSE / E(\beta)')
% legend('ML Training Sim','ML Full Data Sim','ML Training Theory','ML Full Data Theory')

    
















































