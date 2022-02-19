
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

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
%%
%% PILOT DESIGN - ORTHOGONAL QPSK PILOTS (Sp)
s1 = (1+1i)/sqrt(2);
s2 = (-1+1i)/sqrt(2);
s3 = (-1-1i)/sqrt(2);
s4 = (1-1i)/sqrt(2);
s = [s1 s2 s3 s4];
sPer = unique(nchoosek(repmat(s, 1,8), 8), 'rows')';
err = 1;
while (err == 1)
        A = zeros(8,8,2);
        err = 0;
        for n=1:2
             A(:,1,n) = (sign(randi(0:1,8,1)-0.5)+ ...
                        1i*sign(randi(0:1,8,1)-0.5))/sqrt(2); 
            for i=2:8
                j=1;
                flag = 0;
                while(flag == 0)
                    z1 = zeros(1,i-1);
                    for m = 1:i-1
                        z1(m) = sPer(:,j)'*A(:,m,n);
                    end           
                    if z1==0
                        A(:,i,n) = sPer(:,j);
                        flag = 1;
                    end
                    j=j+1;
                    if (j == 4^8+1 && flag == 0)
                        err = 1;
                        break
                    end
                end
            end
        end
end
Sp = [A(:,:,1) A(:,:,2)];
Sd = (sign(randi(0:1,K,N-L)-0.5)+ ...
      1i*sign(randi(0:1,K,N-L)-0.5))/sqrt(2);
S = [Sp Sd];