function [A,Sigma] = VAROLS(data,p,const)

Y=data(:,p+1:end);
Z=zmat(data,p,const);
T=size(data,2);
n=size(data,1);
A=Y*Z'/(Z*Z');
Sigma=(Y*Y'-(Y*Z'/(Z*Z'))*Z*Y')/(T-n*p-const);

end

