    
%% COMPUTES SER

% 3 ESTIMATION SCHEMES
for idx = 1:3 
        gHatSquare = zeros(K,K);  % converts a non-square matrix to a square one
        inverse = zeros(K,N); % uses for solving the equation
        estimatedSyms = zeros(K,N,len); % estimated symbols
        demodSyms = zeros(K,N,len); % QPSK demodulated symbols
        if idx == 1  % ML Training estimator
            gHatidx = gHat1;
            exp = 'ML Training';
        elseif idx == 2 % ML Full Data estimator
            gHatidx = gHat2;
            exp = 'ML Full Data';
        else % EM algorithm
            gHatidx = finalgHat;
            exp = 'EM';
        end
        % computes SER for all SNRs
        for snr = 1:len
           error = 0;
           receivedSyms = [];
           % Y = G*S + V  >>> estimation >>> inv(G) * Y >>> G needs to be a
           % square matrix. so we should turn to a square one by
           % multiplying both sides to G hermitian.
           gHatSquare = gHatidx(:,:,snr).' * gHatidx(:,:,snr);  % converting to a square matrix
           inverse = gHatidx(:,:,snr).' * Y(:,1:N,snr); % multiplying G hermitian to the left side 
           for idx2 = 1:N  % solves the equation with gmres function.
                receivedSyms = [receivedSyms gmres(gHatSquare,inverse(:,idx2))];
           end
           estimatedSyms(:,:,snr) = receivedSyms;  % saving estimated symbols
           % QPSK Demodulation and counting errors for all SNRs
           for row = 1:K
                for col = L+1:N
                    if     real(receivedSyms(row,col)) < 0 && imag(receivedSyms(row,col)) < 0
                        demodSyms(row,col,snr) = -1-1i;
                    elseif real(receivedSyms(row,col)) < 0 && imag(receivedSyms(row,col)) > 0
                        demodSyms(row,col,snr) = -1+1i;
                    elseif real(receivedSyms(row,col)) > 0 && imag(receivedSyms(row,col)) < 0
                        demodSyms(row,col,snr) = 1-1i;
                    elseif real(receivedSyms(row,col)) > 0 && imag(receivedSyms(row,col)) > 0
                        demodSyms(row,col,snr) = 1+1i;
                    end 
                    if demodSyms(row,col,snr) ~= S(row,col)*sqrt(2)  % counts errors
                        error = error + 1;  
                    end
                end
           end
           errorsBuffer(idx,snr,experiments) = error;
        end
        clc   
end  