
%------------------------ *** STOCHASTIC CRB *** ----------------------------

% NOTE: RUNNING THIS CODE TAKES A LONG TIME TO END ACCORDING TO THE
% EXPLANATIONS IN THE REPORT. A PRE-PREPARED RESULT IS PROVIDED IN A MAT 
% FILE WHICH IS UPLOADED IN A DRIVE WITH THE LINK BELOW:
% https://drive.google.com/drive/folders/1dvMg2tNGAthr8PLd7aFroPrNICCtdJPA?usp=sharing
% THIS MAT FILE CONTAINS CHANNEL MATRIX G, MATRIX BETA AND STOCHASTIC CRB
% MATRICES FOR ALL SNRs.
%% PARTIAL DERIVATION

% defines symbolic real and imaginary parts of G:channel matrix
syms 'A%d%d' [M K];
syms 'B%d%d' [M K];
% symbolic matrices of G partial derivatives
drvRe = sym(zeros(M,M,M,K));
drvIm = sym(zeros(M,M,M,K));
% partial derivations of channel matrix G
for idx1 = 1:M
    for idx2 = 1:K
        % real parts
        drvRe(:,:,idx1,idx2) = diff((A+1i*B)*(A+1i*B)',...
                               ['A' num2str(idx1) num2str(idx2)]);
        % imaginary parts                   
        drvIm(:,:,idx1,idx2) = diff((A+1i*B)*(A+1i*B)',...
                               ['B' num2str(idx1) num2str(idx2)]);
    end
end
% after derivation, symbolic elements needed to be replaced by actual
% elements in G
for idx1 = 1:M
    for idx2 = 1:K
        eval(['A' num2str(idx1) num2str(idx2) '= sym(real(G(idx1,idx2)))']);
        eval(['B' num2str(idx1) num2str(idx2) '= sym(imag(G(idx1,idx2)))']);
    end
end
% replacing G elements in the partial derivation matrix
for idx1 = 1:M
    for idx2 = 1:K
        drvRe(:,:,idx1,idx2) = subs(drvRe(:,:,idx1,idx2));
        drvIm(:,:,idx1,idx2) = subs(drvIm(:,:,idx1,idx2));
    end
end


%% COMPUTING STOCHASTIC CRB 

% defines matrix R according to corresponding formulas in the article 
R = zeros(M,M,len); 
for snr=1:len
    R(:,:,snr) = G*G' + sigmaNu(snr)*eye(M);
end
% making the actual derivation matrix according to the article format
drv = zeros(M,M,2*M*K);
for idx = 1:2*M*K
    if rem(floor((idx-1)/M),2) == 1
        drv(:,:,idx) = double(drvIm(:,:,rem((idx-1),M)+1,floor((idx-1)/M/2)+1));
    else
        drv(:,:,idx) = double(drvRe(:,:,rem((idx-1),M)+1,floor((idx-1)/M/2)+1));
    end
end
invStocCRB = zeros(2*M*K,2*M*K,len);  % inverse of all CRB elements
stocCRB = zeros(2*M*K,2*M*K,len); % Stochastic CRB
channelstocCRB = zeros(1,len); % scaled MSE
% computing scaled MSE of CRB matrix for all SNRs
for snr = 1:len
    for idx1 = 1:2*M*K
        for idx2 = 1:2*M*K
            invStocCRB(idx1,idx2,snr) = (N-L)*trace(inv(R(:,:,snr))*...
                drv(:,:,idx1)*inv(R(:,:,snr))*drv(:,:,idx2));
            if idx1 == idx2
                invStocCRB(idx1,idx2,snr) = invStocCRB(idx1,idx2,snr) +...
                                            2*L/sigmaNu(snr);
            end
            stocCRB(idx1,idx2,snr) = inv(invStocCRB(idx1,idx2,snr));
        end
    end
    channelstocCRB(snr) = trace(abs(stocCRB(:,:,snr)))/mean(beta); % scaled MSE
end