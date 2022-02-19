%% EM ALGORITHMS

%% EM QPSK DATA SYMBOLS
nIter = 10; % iteration needed for convergence of EM algorithm
MSE = zeros(1,len); % MSE of EM algorithm
finalgHat = zeros(M,K,len); % buffer for channel estimation for all SNRs
MSE15dB = zeros(1,nIter); % MSE for SNR =15 dB
MSE30dB = zeros(1,nIter); % MSE for SNR =30 dB
for k=1:len % computing MSE of EM algorithm for all SNRs
    gHat = zeros(M,K); % initial state
    mu = zeros(K,N);  % initial state
    sigma = zeros(K,K);  % initial state
    for i=1:nIter
        gHat = (Yp(:,:,k)*Sp' + Y(:,L:N-1,k)*mu(:,L:N-1)')/ ...
               (Sp*Sp' + mu(:,L:N-1)*mu(:,L:N-1)' + (N-L)*sigma);
        if k == 15/(40/(len-1))+1
            MSE15dB(i) = trace(abs((G-gHat)'*(G-gHat)))/mean(beta)/K;
        elseif k == 30/(40/(len-1))+1
            MSE30dB(i) = trace(abs((G-gHat)'*(G-gHat)))/mean(beta)/K;
        end
        for j=1:N
             mu(:,j) = (gHat'*gHat + sigmaNu(k)*eye(K))\(gHat'*Y(:,j,k));
        end
        sigma = sigmaNu(k)*eye(K)/(gHat'*gHat + sigmaNu(k)*eye(K));
    end
    finalgHat(:,:,k) = gHat;
    MSE(k) = trace(abs((G-gHat)'*(G-gHat)))/mean(beta);  % Scaled MSE for all SNRs
end

%% EM GAUSSIAN DATA SYMBOLS
% here we use gaussian data symbols instead of QPSK 
MSENorm = zeros(1,len);
finalgHatNorm = zeros(M,K,len);
for k=1:len
    gHatNorm = zeros(M,K); % initial state
    muNorm = zeros(K,N);  % initial state
    sigmaNorm = zeros(K,K); % initial state
    for i=1:nIter
        gHatNorm = (YpNorm(:,:,k)*SpNorm' + YNorm(:,L:N-1,k)*muNorm(:,L:N-1)')/ ...
               (SpNorm*SpNorm' + muNorm(:,L:N-1)*muNorm(:,L:N-1)' + (N-L)*sigmaNorm);
        for j=1:N
             muNorm(:,j) = (gHatNorm'*gHatNorm + sigmaNu(k)*eye(K))\(gHatNorm'*YNorm(:,j,k));
        end
        sigmaNorm = sigmaNu(k)*eye(K)/(gHatNorm'*gHatNorm + sigmaNu(k)*eye(K));
    end
    finalgHatNorm(:,:,k) = gHatNorm;
    MSENorm(k) = trace(abs((G-gHatNorm)'*(G-gHatNorm)))/mean(beta);
end

%% EM ALGORITHM WITH CHANNEL PRIORS
% in this part channel prior B is added to the computations
MSEPrior = zeros(1,len);
for k=1:len
    AbsG = zeros(1,K);  % initial state
    BHat = eye(K)*(1+1i)*1e-40;  % initial state
    gHatPrior = zeros(M,K);  % initial state
    muPrior = zeros(K,N);  % initial state
    sigmaPrior = eye(K)*(1+1i)*1e-4;  % initial state
    for i=1:100
        gHatPrior = (Yp(:,:,k)*Sp' + Y(:,L:N-1,k)*muPrior(:,L:N-1)')*BHat / ...
               (Sp*Sp'*BHat + muPrior(:,L:N-1)*muPrior(:,L:N-1)'*BHat + ...
               (N-L)*sigmaPrior*BHat + sigmaNu(k)*eye(K));
        for j=1:N
             muPrior(:,j) = (gHatPrior'*gHatPrior + sigmaNu(k)*eye(K))\(gHatPrior'*Y(:,j,k));
        end
        sigmaPrior = sigmaNu(k)*eye(K)/(gHatPrior'*gHatPrior + sigmaNu(k)*eye(K));
        for j = 1:K
            AbsG(j) = (sum(abs(gHatPrior(:,j)).^2))/M;
        end
        BHat = diag(AbsG);
    end
    MSEPrior(k) = trace(abs((G-gHatPrior)'*(G-gHatPrior)))/mean(beta);
end

























