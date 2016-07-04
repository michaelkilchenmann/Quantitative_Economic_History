clear
close all

filename=project_paths('OUT_DATA','us');
eval(['load ' filename]);

temp=not(isnan(CPI));

%CPI=CPI(temp,:);
%Industrial_Production=Industrial_Production(temp,:);
%Month=Month(temp,:);
select = (4*12)+1; % select the year you want to start from ( 0 = year 1 etc)
CPI=CPI(select:end,:);
Industrial_Production=Industrial_Production(select:end,:);
Month=Month(select:end,:);
clear temp


lCPI=log(CPI);
lIndustrial_Production=log(Industrial_Production);

dCPI=lCPI(2:end)-lCPI(1:end-1); %inflation
dIP=lIndustrial_Production(2:end)-...
    lIndustrial_Production(1:end-1);

data=[dIP';dCPI'];

titel={'Output Growth (%)','Inflation (%)'};
screen_size = get(0, 'ScreenSize');
f1=figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4)]);

for jj=1:2
    subplot(2,1,jj)
    plot(Month(2:end),100*data(jj,:)','LineWidth',2)
    axis tight
    set(gca,'TickDir','out','FontSize',18)
    %set(gca,'XTick',1:12:Month(end,1),'XTickLabel',{'Jan19' 'Jan20' ...
        %'Jan21' 'Jan22' 'Jan23' 'Jan24' 'Jan25' 'Jan26' 'Jan27' ... 
        %'Jan28' 'Jan29' 'Jan30' 'Jan31' 'Jan32' 'Jan33' 'Jan34'...
        %'Jan35' 'Jan36' 'Jan37' 'Jan38' 'Jan39'})
    set(gca,'XTick',select:24:Month(end,1),'XTickLabel',{'23' ... 
        '25' '27' '29' '31' '33' ... 
        '35' '37' '39'})
    box off
    xlabel('Year')
    ylabel(titel{jj})
    xlim([Month(1,1) Month(end,1)])
end

filename1=project_paths('OUT_FIGURES','data_plot.pdf');
set(f1,'PaperOrientation','landscape');
set(f1,'PaperUnits','normalized','PaperPosition',[0 0 1 1])
print(f1, '-dpdf', filename1)
