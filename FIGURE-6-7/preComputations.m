
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

    M = Antennas(ant); % number of antennas in each iteration
    H = zeros(M,K);
    for k=1:K
        H(:,k) = randn(M,1)+1i*randn(M,1);
    end
    G = H*sqrt(B);
    sigmaNu = zeros(1,len);
    nu = zeros(M,N,len);
    Y = zeros(M,N,len);
    MSE1 = zeros(1,len);
    MSE2 = zeros(1,len);
    gHat1 = zeros(M,K,len);
    gHat2 = zeros(M,K,len);
    RN = randn(M,N);
    for k=1:len
            sigmaNu(k) = mean(beta)*(10.^(-0.1*SNR(k)));
            for j=1:N
                nu(:,:,k) = RN*sqrt(sigmaNu(k));
                Y(:,j,k) = G*S(:,j);
            end
            Y(:,:,k) = Y(:,:,k) + nu(:,:,k);
            gHat1(:,:,k) = (Y(:,1:L,k)*Sp')/(Sp*Sp');
            gHat2(:,:,k) = (Y(:,:,k)*S')/(S*S');
            MSE1(k) = trace(abs((G-gHat1(:,:,k))'*(G-gHat1(:,:,k))))/mean(beta);
            MSE2(k) = trace(abs((G-gHat2(:,:,k))'*(G-gHat2(:,:,k))))/mean(beta);
    end
    Yp = Y(:,1:L,:);