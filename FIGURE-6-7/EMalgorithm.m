
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

nIter = 10;
    MSE = zeros(1,len);
    for k=1:len
        gHat = zeros(M,K);
        mu = zeros(K,N);
        sigma = zeros(K,K);
        for i=1:nIter
            gHat = (Yp(:,:,k)*Sp' + Y(:,L:N-1,k)*mu(:,L:N-1)')/ ...
                   (Sp*Sp' + mu(:,L:N-1)*mu(:,L:N-1)' + (N-L)*sigma);
            for j=1:N
                 mu(:,j) = (gHat'*gHat + sigmaNu(k)*eye(K))\(gHat'*Y(:,j,k));
            end
            sigma = sigmaNu(k)*eye(K)/(gHat'*gHat + sigmaNu(k)*eye(K));
        end
        MSE(k) = trace(abs((G-gHat)'*(G-gHat)))/mean(beta);
    end