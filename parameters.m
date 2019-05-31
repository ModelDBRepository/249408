function[]  = parameters(R_w,p_h,p_s)
hs = 1: 0.1: 9;
hh = spline(R_w,p_h,hs);
ss = spline(R_w,p_s,hs);
figure(3)
clf
plot(R_w,p_h,'r*',R_w,p_s,'b.');
hold on
plot(hs,hh,'r',hs,ss,'b');
hold on
legend('Hard select','Soft select','Location','SouthEast');
axis([0 10 0 100])
xlabel('Weight Ratio');
ylabel('% fit with selection template');
set(gca,'XLim',[0 10])
set(gca,'XTick',[0:1:10])
set(gca,'XTickLabel',['  ';'  ';'  ';'  ';'  ';'5 ';'  ';'  ';'  ';'  ';'10'])
set(gca,'YLim',[0 100])
set(gca,'YTick',[0:10:100])
set(gca,'YTickLabel',['0  ';'   ';'   ';'   ';'   ';'50 ';'   ';'   ';'   ';'   ';'100'])
fprintf('\n%% Parameters %%\n');
fprintf('H(Max) = %2.2f\n',max(hh));
fprintf('S(Max) = %2.2f\n',max(ss));

