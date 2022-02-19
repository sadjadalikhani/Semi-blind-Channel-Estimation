clear 
clc
%% PARAMETERS
prm
%% DATA GENERATION
dataGen
%% TESTING FOR 20 DATA BLOCKS
for sss = 1:e  % e shows the number of data blocks
    %% SYSTEM MODEL, ML ALGORITHMS, MAKING RECEIVED SIGNAL AT BS
    preComputations
    %% EM ALGORITHM
    EMalgorithm
end 

%% COMPUTES CAPACITY LOSS FOR SNRs = 15 & 30 dB AND PLOTS FIGURES
for snr = 1:len
    %% CAPACITY LOSS ( LOG2(LAMBDA) )
    capacityLoss
    %% PLOTS CDFs
    figure();
    h(1) = cdfplot(a1);
    hold on;
    h(2) = cdfplot(a2);
    hold on;
    h(3) = cdfplot(a3);
    hold on
    xline(0,'g--','LineWidth',1.5)
    set( h(1),'LineWidth',1.5 ,'LineStyle', '-', 'Color', 'b');
    set( h(2),'LineWidth',1.5 , 'LineStyle', '--', 'Color', 'm');
    set( h(3),'LineWidth',1.5 , 'LineStyle', ':', 'Color', 'k');
    legend("EM","ML Training","ML Full Data","Perfect CSI")
    xlim ([-1 0])
    ylabel('CDF')
    xlabel('log_2 (\gamma) (Bits per second per hertz)')
    title(sprintf('CDF of log_2 (\\gamma) for different channel estimation schemes with M = 64, K = 8, L = 16, N = 512, and SNR = %d dB',SNR(snr)))
    if snr == 1
        xlim([-0.5 0])
    else
        xlim([-0.005 0])

    end
end





