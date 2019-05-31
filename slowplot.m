function[] = slowplot(o_snr,p,dist)
b = 1:5:500;

figure(2)
clf
plot(o_snr(1,:),'r')
hold on
plot(o_snr(2,:),'b')
hold on
% plot(o_snr(3,:),'y')
% hold on
plot(p(:,1),'k--');
hold on
plot(p(:,2),'c--');
hold on
% plot(p(:,3),'g--');
% hold on
plot(b,dist,'r-');
legend('Ch 1','Ch 2');
% legend('Ch 1 Output','Ch 2 Output','Ch1 Salience','Ch 2 Salience');
% set(gca,'XLim',[0 500])
% set(gca,'XTick',[0:50:500])
% set(gca,'XTickLabel',['0 ';'  ';'1 ';'  ';'2 ';'  ';'3 ';'  ';'4 ';'  ';'5 '])
% set(gca,'YLim',[0 1])
% set(gca,'YTick',[0:0.1:1])
% set(gca,'YTickLabel',['0  ';'   ';'0.2';'   ';'0.4';'   ';'0.6';'   ';'0.8';'   ';'1  '])
