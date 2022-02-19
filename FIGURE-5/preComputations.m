
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

%% GENERATES DATA SYMBOLS + USES ORTHOGONAL PILOT SEQUENCES OF PREVOIUS PART
Sd = (sign(randi(0:1,K,N-L)-0.5)+ ...
          1i*sign(randi(0:1,K,N-L)-0.5))/sqrt(2);
S = [Sp Sd];

    %% EM ALGORITHM REQUIREMENTS

    H = zeros(M,K);
    for k=1:K
        H(:,k) = randn(M,1)+1i*randn(M,1);
    end
    x0 = 0;
    y0 = 0; 
    t = 2*pi*rand(K,1);
    r = R*sqrt(rand(K,1));
    x = x0 + r.*cos(t);
    y = y0 + r.*sin(t);
    usersLoc = x+1i*y;
    c2 = 10^(0.1*(-46.3 - 33.9*log10(f) + 13.82*log10(hB) + ...
         (1.1*log10(f)-0.7)*hR - (1.56*log10(f)-0.8)));
    c1 = 10^(0.1*(10*log10(c2) - 15*log10(d1))); 
    c0 = 10^(0.1*(10*log10(c1) - 20*log10(d0)));
    betaTest = zeros(K,30);
    beta = zeros(1,K);
    for idx = 1:50
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
    B = diag(beta);
    G = H*sqrt(B);
    sigmaNu = zeros(1,len);
    nu = zeros(M,N,len);
    Y = zeros(M,N,len);
    gHat1 = zeros(M,K,len);
    gHat2 = zeros(M,K,len);
    RN = randn(M,N)+1i*randn(M,N);
    for k=1:len
            sigmaNu(k) = mean(beta)*(10.^(-0.1*SNR(k)));
            for j=1:N
                nu(:,:,k) = RN*sqrt(sigmaNu(k));
                Y(:,j,k) = G*S(:,j);
            end
            Y(:,:,k) = Y(:,:,k) + nu(:,:,k);
            gHat1(:,:,k) = (Y(:,1:L,k)*Sp')/(Sp*Sp');
            gHat2(:,:,k) = (Y(:,:,k)*S')/(S*S');
    end
    Yp = Y(:,1:L,:);