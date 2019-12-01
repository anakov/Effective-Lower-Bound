nperirf = 40;
figure(2)
  subplot(1,3,1)
  plot(pi_sim);
  hold on
  title('Inflation')
  xlim([1 nperirf])
  subplot(1,3,2)
  plot(x_sim);
  hold on
  title('Output gap')
  xlim([1 nperirf])
  subplot(1,3,3)
  plot(i_sim);
  hold on
  title('Interest rate')
  hold on
  plot(rn_sim,'k:');
  legend('Nominal','Natural')
  xlim([1 nperirf])
  xlabel('Quarters')