
% -------------------------------------------------------------------------
% NOTE: ALL THE PARAMETERS ARE EXPLAINED IN COMMENTS OF FIGURES 1,2,3 CODE
% -------------------------------------------------------------------------

% PILOT DESIGN - ORTHOGONAL QPSK PILOTS (Sp)  K =8
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