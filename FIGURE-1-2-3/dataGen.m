%% DATA GENERATION
%% PILOT DESIGN - ORTHOGONAL QPSK PILOTS (Sp)
s1 = (1+1i)/sqrt(2);  % defining QPSK scheme
s2 = (-1+1i)/sqrt(2);
s3 = (-1-1i)/sqrt(2);
s4 = (1-1i)/sqrt(2);
s = [s1 s2 s3 s4];

if (K == 4)   % designs orthogonal pilots for 4 users
    %% ----------------------- K = 4 ---------------------------
    sPer = unique(nchoosek(repmat(s, 1,4), 4), 'rows')';  % all possible QPSK schemes for 4 users
    A = zeros(4,4,4);
    for n=1:4  
        A(:,1,n) = (sign(randi(0:1,K,1)-0.5)+ ...   % chooses a random QPSK pilot scheme for the first column of data symbols
                 1i*sign(randi(0:1,K,1)-0.5))/sqrt(2);
        for i=2:4   % for other columns we look for orthogonal QPSK schemes 
            for j=1:4^4
                z = zeros(1,i-1);
                for m = 1:i-1
                    z(m) = sPer(:,j)'*A(:,m,n); % checking orthogonality
                end
                if z==0
                    A(:,i,n) = sPer(:,j);
                end
            end
        end
    end
    Sp = [A(:,:,1) A(:,:,2) A(:,:,3) A(:,:,4)]; % as we devided 16 columns into 4 quad columns due to rank-4, at the end we put them together and still they are orthogonal
 
elseif (K == 8)   % designs orthogonal pilots for 8 users
    %% ----------------------- K = 8 ---------------------------
    sPer = unique(nchoosek(repmat(s, 1,8), 8), 'rows')'; % all possible QPSK schemes for 8 users
    err = 1;
    while (err == 1)  % checks whether all columns of the matrix are orthogonal or not
        A = zeros(8,8,2);
        err = 0;
        for n=1:2
             A(:,1,n) = (sign(randi(0:1,8,1)-0.5)+ ...        % chooses a random QPSK pilot scheme for the first column of data symbols
                        1i*sign(randi(0:1,8,1)-0.5))/sqrt(2); 
            for i=2:8    % for other columns we look for orthogonal QPSK schemes
                j=1;
                flag = 0;  % checks whether an orthogonal column's been found or not
                while(flag == 0)
                    z1 = zeros(1,i-1);
                    for m = 1:i-1
                        z1(m) = sPer(:,j)'*A(:,m,n); % checking orthogonality
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
    Sp = [A(:,:,1) A(:,:,2)];    % rank = 8 >>> separating 16 columns to two 8 columns and then putting them together at the end. still they are orthogonal.
end

%% DATA GENERATION
Sd = (sign(randi(0:1,K,N-L)-0.5)+ ...     % QPSK data symbols (different from pilot sequences)
      1i*sign(randi(0:1,K,N-L)-0.5))/sqrt(2);
S = [Sp Sd];  % pilots + QPSK data symbols
%% DATA GENERATION - GAUSSIAN
SdNorm = randn(K,N-L) + 1i*randn(K,N-L);  % Gaussian data symbols
SpNorm = Sp; % still pilot sequences have QPSK signalling
SNorm = [SpNorm SdNorm]; % pilots + normal data symbols

