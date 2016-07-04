clear
close all
filename=project_paths('OUT_DATA','us');
eval(['load ' filename]);
p=3;    % Lag of 3 suggested by BIC. AIC suggests 2.
% select time range
select=4*12+1;
cut_b=14*12+3;      % New Deal period
cut_e=2*12+5; 
cut_GDb=10*12+10;   % Great Depression
cut_GDe=6*12+9; 
cut_RTb=1*12+1;     % Roaring Twenties
cut_RTe=11*12;  

%yaxislabels = [0 50 100]

% short time range, April 1933 - June 1937  
CPIs=CPI(cut_b:end-cut_e,:); % s for short time range
IPs=Industrial_Production(cut_b:end-cut_e,:);
Months=Month(cut_b:end-cut_e,:);
% Great Depression, October 1929 - February 1933
CPI_GD=CPI(cut_GDb:end-cut_GDe,:);
IP_GD=Industrial_Production(cut_GDb:end-cut_GDe,:);
% Roaring Twenties, January 1920 - December 1928
CPI_RT=CPI(cut_RTb:end-cut_RTe,:);
IP_RT=Industrial_Production(cut_RTb:end-cut_RTe,:);
% long time range, January 1923 - December 1939
CPI=CPI(select:end,:);
Industrial_Production=Industrial_Production(select:end,:);
Month=Month(select:end,:);



%LONG 
lCPI=log(CPI);
lIndustrial_Production=log(Industrial_Production);
dCPI=lCPI(2:end)-lCPI(1:end-1);
dIP=lIndustrial_Production(2:end)-...
lIndustrial_Production(1:end-1);

data=[dIP';dCPI'];
Y=data(:,p+1:end);
const=1;
n=size(data,1);
[A,Sigma]=VAROLS(data,p,const);
Xi=VARcompanion(A,p,const);
J=jmat(n,p);
[S, C1]=blanchard_quah(Xi,J,n,p,Sigma);
h=30; %horizon: 30 years
epsilon=eye(n);
C_diff=impulse_response(Xi,J,S,epsilon,n,h);
C_level=cumsum(C_diff,3); %cumulative sum in the 3rd dimension, 3rd dimension because we want the horizon
variables={'y';'p'}; % cell structure with {} --> advantage: we can loop over that
epsilon={'$\epsilon_S$';'$\epsilon_D$'};
f1=figure(1);
screen_size=get(0,'ScreenSize');
set(f1, 'Position', [0 0 screen_size(3) screen_size(4)])
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(C_level(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
        
        set(gca, 'TickDir', 'out','fontsize',14)
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Response (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[C1(jj,kk) C1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        xlim([0 24])
        %ylim([])
        hh=hh+1; 
    end
end

theta=zeros(n,n,h);
theta(:,:,1)=(C_level(:,:,1).^2)./...
repmat(sum(C_level(:,:,1).^2,2),1,n);

for jj=1:h
    % numerator
    theta(:,:,jj+1)=sum(C_level(:,:,1:jj+1).^2,3)./... % ,3) in the end, because we sum up over the third dimension (grey arrow)
    repmat(sum(sum(C_level(:,:,1:jj+1).^2,3),2),1,n);
    % denumerator
end

t=(1:h+1)'; %horizontal axis: horizon
title1={'y','p'};
title2={'$\epsilon_S$','$\epsilon_D$'};
f2=figure(2); %figure one forecast variance decomposition
screen_size=get(0,'ScreenSize');
set(f2, 'Position', [0 0 screen_size(3) screen_size(4)])
theta1=C1.^2./repmat(sum(C1.^2,2),1,2);
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(theta(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
        
        set(gca, 'TickDir', 'out','fontsize',14)
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Contribution (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[theta1(jj,kk) theta1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        %ylim([0 1]) % for scaling of the plot
        xlim([0 24])
        hh=hh+1; 
    end
end


filename1=project_paths('OUT_FIGURES','impulse_response.pdf');
set(f1,'PaperOrientation','landscape');
set(f1,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f1, '-dpdf', filename1)

filename2=project_paths('OUT_FIGURES','fevd.pdf');
set(f2,'PaperOrientation','landscape');
set(f2,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f2, '-dpdf', filename2)



%SHORT New Deal period
lCPI=log(CPIs);
lIndustrial_Production=log(IPs);
dCPI=lCPI(2:end)-lCPI(1:end-1);
dIP=lIndustrial_Production(2:end)-...
lIndustrial_Production(1:end-1);

data=[dIP';dCPI'];
Y=data(:,p+1:end);
const=1;
n=size(data,1);
[A,Sigma]=VAROLS(data,p,const);
Xi=VARcompanion(A,p,const);
J=jmat(n,p);
[S, C1]=blanchard_quah(Xi,J,n,p,Sigma);
h=30; %horizon: 30 years
epsilon=eye(n);
C_diff=impulse_response(Xi,J,S,epsilon,n,h);
C_level=cumsum(C_diff,3); %cumulative sum in the 3rd dimension, 3rd dimension because we want the horizon
variables={'y';'p'}; % cell structure with {} --> advantage: we can loop over that
epsilon={'$\epsilon_S$';'$\epsilon_D$'};
f1=figure(1);
screen_size=get(0,'ScreenSize');
set(f1, 'Position', [0 0 screen_size(3) screen_size(4)])
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(C_level(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out','fontsize',14)
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Response (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[C1(jj,kk) C1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        xlim([0 24])
        %ylim([])
        hh=hh+1; 
    end
end

theta=zeros(n,n,h);
theta(:,:,1)=(C_level(:,:,1).^2)./...
repmat(sum(C_level(:,:,1).^2,2),1,n);

for jj=1:h
    % numerator
    theta(:,:,jj+1)=sum(C_level(:,:,1:jj+1).^2,3)./... % ,3) in the end, because we su up over the third dimension (grey arrow)
    repmat(sum(sum(C_level(:,:,1:jj+1).^2,3),2),1,n);
    % denumerator
end

t=(1:h+1)'; %horizontal axis: horizon
title1={'y','p'};
title2={'$\epsilon_S$','$\epsilon_D$'};
f2=figure(2); %figure one forecast variance decomposition
screen_size=get(0,'ScreenSize');
set(f2, 'Position', [0 0 screen_size(3) screen_size(4)])
theta1=C1.^2./repmat(sum(C1.^2,2),1,2);
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(theta(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out','fontsize',14)
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Contribution (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[theta1(jj,kk) theta1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        %ylim([0 1]) % for scaling of the plot
        xlim([0 24])
        hh=hh+1; 
    end
end


filename1=project_paths('OUT_FIGURES','impulse_response_ND.pdf');
set(f1,'PaperOrientation','landscape');
set(f1,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f1, '-dpdf', filename1)

filename2=project_paths('OUT_FIGURES','fevd_ND.pdf');
set(f2,'PaperOrientation','landscape');
set(f2,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f2, '-dpdf', filename2)



%SHORT Great Depression period
lCPI=log(CPI_GD);
lIndustrial_Production=log(IP_GD);
dCPI=lCPI(2:end)-lCPI(1:end-1);
dIP=lIndustrial_Production(2:end)-...
lIndustrial_Production(1:end-1);

data=[dIP';dCPI'];
Y=data(:,p+1:end);
const=1;
n=size(data,1);
[A,Sigma]=VAROLS(data,p,const);
Xi=VARcompanion(A,p,const);
J=jmat(n,p);
[S, C1]=blanchard_quah(Xi,J,n,p,Sigma);
h=30; %horizon: 30 years
epsilon=eye(n);
C_diff=impulse_response(Xi,J,S,epsilon,n,h);
C_level=cumsum(C_diff,3); %cumulative sum in the 3rd dimension, 3rd dimension because we want the horizon
variables={'y';'p'}; % cell structure with {} --> advantage: we can loop over that
epsilon={'$\epsilon_S$';'$\epsilon_D$'};
f1=figure(1);
screen_size=get(0,'ScreenSize');
set(f1, 'Position', [0 0 screen_size(3) screen_size(4)])
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(C_level(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out')
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Response (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14')
        line([0 h],[C1(jj,kk) C1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        xlim([0 24])
        %ylim([])
        hh=hh+1; 
    end
end

theta=zeros(n,n,h);
theta(:,:,1)=(C_level(:,:,1).^2)./...
repmat(sum(C_level(:,:,1).^2,2),1,n);

for jj=1:h
    % numerator
    theta(:,:,jj+1)=sum(C_level(:,:,1:jj+1).^2,3)./... % ,3) in the end, because we su up over the third dimension (grey arrow)
    repmat(sum(sum(C_level(:,:,1:jj+1).^2,3),2),1,n);
    % denumerator
end

t=(1:h+1)'; %horizontal axis: horizon
title1={'y','p'};
title2={'$\epsilon_S$','$\epsilon_D$'};
f2=figure(2); %figure one forecast variance decomposition
screen_size=get(0,'ScreenSize');
set(f2, 'Position', [0 0 screen_size(3) screen_size(4)])
theta1=C1.^2./repmat(sum(C1.^2,2),1,2);
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(theta(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out')
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Contribution (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[theta1(jj,kk) theta1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        %ylim([0 1]) % for scaling of the plot
        xlim([0 24])
        hh=hh+1; 
    end
end


filename1=project_paths('OUT_FIGURES','impulse_response_GD.pdf');
set(f1,'PaperOrientation','landscape');
set(f1,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f1, '-dpdf', filename1)

filename2=project_paths('OUT_FIGURES','fevd_GD.pdf');
set(f2,'PaperOrientation','landscape');
set(f2,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f2, '-dpdf', filename2)



%SHORT Roaring Twenties period
lCPI=log(CPI_RT);
lIndustrial_Production=log(IP_RT);
dCPI=lCPI(2:end)-lCPI(1:end-1);
dIP=lIndustrial_Production(2:end)-...
lIndustrial_Production(1:end-1);

data=[dIP';dCPI'];
Y=data(:,p+1:end);
const=1;
n=size(data,1);
[A,Sigma]=VAROLS(data,p,const);
Xi=VARcompanion(A,p,const);
J=jmat(n,p);
[S, C1]=blanchard_quah(Xi,J,n,p,Sigma);
h=30; %horizon: 30 years
epsilon=eye(n);
C_diff=impulse_response(Xi,J,S,epsilon,n,h);
C_level=cumsum(C_diff,3); %cumulative sum in the 3rd dimension, 3rd dimension because we want the horizon
variables={'y';'p'}; % cell structure with {} --> advantage: we can loop over that
epsilon={'$\epsilon_S$';'$\epsilon_D$'};
f1=figure(1);
screen_size=get(0,'ScreenSize');
set(f1, 'Position', [0 0 screen_size(3) screen_size(4)])
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(C_level(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out')
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Response (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[C1(jj,kk) C1(jj,kk)], 'Linestyle', ':', 'Color','k','LineWidth',2)
        xlim([0 24])
        %ylim([])
        hh=hh+1; 
    end
end

theta=zeros(n,n,h);
theta(:,:,1)=(C_level(:,:,1).^2)./...
repmat(sum(C_level(:,:,1).^2,2),1,n);

for jj=1:h
    % numerator
    theta(:,:,jj+1)=sum(C_level(:,:,1:jj+1).^2,3)./... % ,3) in the end, because we su up over the third dimension (grey arrow)
    repmat(sum(sum(C_level(:,:,1:jj+1).^2,3),2),1,n);
    % denumerator
end

t=(1:h+1)'; %horizontal axis: horizon
title1={'y','p'};
title2={'$\epsilon_S$','$\epsilon_D$'};
f2=figure(2); %figure one forecast variance decomposition
screen_size=get(0,'ScreenSize');
set(f2, 'Position', [0 0 screen_size(3) screen_size(4)])
theta1=C1.^2./repmat(sum(C1.^2,2),1,2);
hh=1;
for jj=1:n
    for kk=1:n
        subplot(n,n,hh)
        plot((0:h)', 100*reshape(theta(jj,kk,:), h+1,1),'LineWidth',2)
        axis tight
                
        set(gca, 'TickDir', 'out')
        box off
        xlabel('Horizon (months)','fontsize',14)
        ylabel('Contribution (%)','fontsize',14)
        title([epsilon{kk} ' $\rightarrow$ ' variables{jj}], 'interpreter','latex','fontsize',14)
        line([0 h],[theta1(jj,kk) theta1(jj,kk)], 'Linestyle',':', 'Color','k','LineWidth',2)
        %ylim([0 1]) % for scaling of the plot
        xlim([0 24])
        hh=hh+1; 
    end
end


filename1=project_paths('OUT_FIGURES','impulse_response_RT.pdf');
set(f1,'PaperOrientation','landscape');
set(f1,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f1, '-dpdf', filename1)

filename2=project_paths('OUT_FIGURES','fevd_RT.pdf');
set(f2,'PaperOrientation','landscape');
set(f2,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f2, '-dpdf', filename2)