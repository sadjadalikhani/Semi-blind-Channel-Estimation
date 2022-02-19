a1 = zeros(1,e*K);  % EM algorithm capacity loss due to estimation errors
a2 = zeros(1,e*K);  % ML-Training estimator capacity loss
a3 = zeros(1,e*K);  % ML Full Data estimator capacity loss
% computes capacity loss for all 3 estimation schemes and for all 20 data
% blocks
for ww = 1:e  
    for idx =1:K
         a1(K*(ww-1)+idx) = log2((abs(G(:,idx,ww).'*conj(finalgHat(:,idx,snr,ww)))^2)/...
             ((norm(G(:,idx,ww))^2)*(norm(finalgHat(:,idx,snr,ww))^2)));
         a2(K*(ww-1)+idx) = log2((abs(G(:,idx,ww).'*conj(gHat1(:,idx,snr,ww)))^2)/...
             ((norm(G(:,idx,ww))^2)*(norm(gHat1(:,idx,snr,ww))^2)));
         a3(K*(ww-1)+idx) = log2((abs(G(:,idx,ww).'*conj(gHat2(:,idx,snr,ww)))^2)/...
             ((norm(G(:,idx,ww))^2)*(norm(gHat2(:,idx,snr,ww))^2)));
    end
end