% ML ALGORITHM IN THEORY
% -----------------------
T = trace(inv(S*S'));
MSE1Theory = M*K/L*10.^(-SNR/10);  % ML Training-based estimation in theory
MSE2Theory = M*T*10.^(-SNR/10);  % ML Full data-based estimation in theory
MSE3Theory = 64*8/128*10.^(-SNR/10); % ML Training-based estimation in theory for K = 8 and M = 64
