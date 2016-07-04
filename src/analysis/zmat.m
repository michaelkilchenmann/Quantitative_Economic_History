function Z = zmat(data,p,const)% const if we want to include a function
n=size(data,1); % number of variables
T=size(data,2); % number of observations
Z=zeros(n*p,T-p); %predefine the Z matrix!

for jj=1:T-p %build Z matrix
    temp=data(:,jj:jj+p-1); % temp, because we only use it temporarily; take the relevant part out of the matrix
    temp=fliplr(temp); %reverse columns ordering
    Z(:,jj)=temp(:);
    %() stacks the columns on top of each other, create columns jj of Z
end
Z=[ones(const,T-p);Z];

end

