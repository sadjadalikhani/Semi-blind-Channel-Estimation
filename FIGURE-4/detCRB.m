
%------------------------- DETERMINISTIC CRB --------------------------

%% SMALL LAMBDA CALCULATIONS
C = zeros(K,K,len);
W = zeros(K,M,K,N,len);
lambda = zeros(K,K,len);
% computing Lambda (small lambda) matrix according to the formulations in the article
for j=1:N
    for k=1:K
        for i=1:K
            for snr =1:len
                C(:,:,snr) = inv(2/sigmaNu(snr)*G'*G);
                W(:,:,k,j,snr) = 2/sigmaNu(snr)*G'*S(k,j);
                lambda(k,i,snr) = 2/sigmaNu(snr)*sum(conj(S(k,1:N)).*S(i,1:N));
            end
        end
    end
end
%% CAPITAL LAMBDA CALCULATIONS
LAMBDA = zeros(2*M*K,2*M*K,len);
lambdaBar = real(lambda);
lambdaTilde = imag(lambda);
% computing Lambda (capital lambda) matrix according to the formulations in the article
for snr=1:len
    for k=1:K
        for i=1:K
            LAMBDA(2*M*(k-1)+1:2*M*k,2*M*(i-1)+1:2*M*i,snr) = ...
                  [lambdaBar(k,i,snr)*eye(M) -lambdaTilde(k,i,snr)*eye(M);...
                   lambdaTilde(k,i,snr)*eye(M)  lambdaBar(k,i,snr)*eye(M)];
        end
    end
end
%% OMEGA CALCULATIONS
omega = zeros(2*K,2*M*K,N-L,len);
WBar = real(W);
WTilde = imag(W);
% computing Omega matrix according to the formulations in the article
for snr=1:len
    for n=1:N-L
        for k=1:K
            omega(:,2*M*(k-1)+1:2*M*k,n,snr) = ...
                [WBar(:,:,k,n,snr) -WTilde(:,:,k,n,snr);...
                 WTilde(:,:,k,n,snr)  WBar(:,:,k,n,snr)];
        end
    end
end
%% DETERMINISTIC CRB CALCULATIONS
cMat = zeros(2*K,2*k,len);
crb = zeros(2*M*K,2*M*K,len);
channelCRB = zeros(1,len);
infCRB = zeros(1,len);   % CRB when number of antennas goes to infinity 
% (CRB infinity is optional and the calculations are done but I plot no
% figures for it. it actually fits the ML genie-aided estimator on the
% plot)
for snr=1:len
    cMat(:,:,snr) = [real(C(:,:,snr)) -imag(C(:,:,snr));...
                     imag(C(:,:,snr))  real(C(:,:,snr))];
    Sum = 0;             
    for q=1:N-L
        Sum = Sum + permute(omega(:,:,q,snr),[2 1 3 4])*...
             cMat(:,:,snr)*omega(:,:,q,snr);
    end
    crb(:,:,snr) = inv(LAMBDA(:,:,snr) - Sum);
    channelCRB(snr) = trace(crb(:,:,snr))/mean(beta);  % Deterministic CRB for all SNRs 
    infCRB(snr) = trace(inv(LAMBDA(:,:,snr)))/mean(beta);
end
