function C = impulse_response(Xi,J,S,epsilon,n,h)
C=zeros(n,n,h+1);
for jj=0:h
  C(:,:,jj+1)=J*(Xi^jj)*J'*S*epsilon;  
end
end

