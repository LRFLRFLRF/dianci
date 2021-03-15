function [forData,lower,upper] = Fun_ARIMA_Forecast(Y, EstMdl,step,figflag)



[forData,YMSE] = forecast(EstMdl,step,'Y0',Y);

lower = forData - 1.96*sqrt(YMSE); %95置信区间下限
upper = forData + 1.96*sqrt(YMSE); %95置信区间上限

% figure()
% plot(Y,'Color',[.7,.7,.7]);
% hold on
% h1 = plot(length(Y):length(Y)+step,[Y(end);lower],'r:','LineWidth',2);
% plot(length(Y):length(Y)+step,[Y(end);upper],'r:','LineWidth',2)
% h2 = plot(length(Y):length(Y)+step,[Y(end);forData],'k','LineWidth',2);
% legend([h1 h2],'95% 置信区间','预测值',...
% 	     'Location','NorthWest')
% title('Forecast')
% hold off

end