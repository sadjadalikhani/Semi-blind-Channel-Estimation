% EM ALGORITHM REQUIREMENTS
% -------------------------
H = zeros(M,K); % small scale fading matrix
for k=1:K
    H(:,k) = randn(M,1)+1i*randn(M,1);
end
x0 = 0; % BS location
y0 = 0; 
t = 2*pi*rand(K,1);
r = R*sqrt(rand(K,1));
x = x0 + r.*cos(t);
y = y0 + r.*sin(t);
usersLoc = x+1i*y;  % random locations for users in cell
% Hata Propagation channel model 
c2 = 10^(0.1*(-46.3 - 33.9*log10(f) + 13.82*log10(hB) + ...  
     (1.1*log10(f)-0.7)*hR - (1.56*log10(f)-0.8)));
c1 = 10^(0.1*(10*log10(c2) - 15*log10(d1))); 
c0 = 10^(0.1*(10*log10(c1) - 20*log10(d0)));
betaTest = zeros(K,50);
beta = zeros(1,K);
for idx = 1:50   % trying to find quite stable beta as it effects the scaled MSE so much
    z = 10.^(0.1*randn(1,K)*sqrt(sigmaShad));
    for k=1:K
        if abs(usersLoc(k)) <= d0
            betaTest(k,idx) = c0;
        elseif (abs(usersLoc(k)) > d0 && abs(usersLoc(k)) <= d1)
            betaTest(k,idx) = c1/(abs(usersLoc(k))^2);
        else
            betaTest(k,idx) = c2*z(k)/(abs(usersLoc(k))^3.5);
        end
    end
    beta = beta + betaTest(:,idx)';
end
beta = beta/50;
B = diag(beta); % large scale fading matrix
G = H*sqrt(B); % channel matrix (the one which should be estimated)
sigmaNu = zeros(1,len); % variance of additive noise
nu = zeros(M,N,len); % additive noise
Y = zeros(M,N,len);  % received symbols at BS with QPSK scheme at transmitter
YNorm = zeros(M,N,len); % received symbols at BS with normal distribution at transmitter
MSE1 = zeros(1,len);  % MSE of ML Training-based estimator
MSE2 = zeros(1,len);  % MSE of ML Full data-based(genie aided) estimator
gHat1 = zeros(M,K,len); % estimated channed matrix with ML Training-based estimator
gHat2 = zeros(M,K,len); % estimated channed matrix with ML genie aided estimator
RN = randn(M,N)+1i*randn(M,N); % complex normal R.V. for generating noise
for k=1:len  % computing for all SNRs
        sigmaNu(k) = mean(beta)*(10.^(-0.1*SNR(k)));
        nu(:,:,k) = RN*sqrt(sigmaNu(k)); % additive noise
        for j=1:N % computing the effect of fading channel on QPSK and Gaussian received symbols at BS
            Y(:,j,k) = G*S(:,j);
            YNorm(:,j,k) = G*SNorm(:,j);
        end
        Y(:,:,k) = Y(:,:,k) + nu(:,:,k);  %fading + noise
        YNorm(:,:,k) = YNorm(:,:,k) + nu(:,:,k); %fading + noise
        gHat1(:,:,k) = (Y(:,1:L,k)*Sp')/(Sp*Sp');  % ML Training-based estimation
        gHat2(:,:,k) = (Y(:,:,k)*S')/(S*S');  % ML Full data-based(genie aided) estimation
        MSE1(k) = trace(abs((G-gHat1(:,:,k))'*(G-gHat1(:,:,k))))/mean(beta); % MSE of ML Training-based estimator
        MSE2(k) = trace(abs((G-gHat2(:,:,k))'*(G-gHat2(:,:,k))))/mean(beta); % MSE of ML Full data-based(genie aided) estimator
end
Yp = Y(:,1:L,:);  % the part corresponding to pilot sequences
YpNorm = YNorm(:,1:L,:); % the part corresponding to pilot sequences