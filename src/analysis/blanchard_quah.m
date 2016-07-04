function [S, C1] = blanchard_quah(Xi,J,n,p,Sigma)
B1=J*inv(eye(n*p)-Xi)*J';   %reduced form long-run multiplier
temp=B1*Sigma*B1';
C1=chol(temp,'lower');  %structural long-run multiplier
S=B1\C1; %impact matrix
end

