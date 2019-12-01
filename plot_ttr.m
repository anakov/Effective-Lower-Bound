% PLOT TRUNCATED TAYLOR RULE 

  figure
  subplot(3,1,1)
  plot(pi_sim);
  title('Inflation')
  xlim([1 nper])
  subplot(3,1,2)
  plot(x_sim);
  title('Output gap')
  xlim([1 nper])
  subplot(3,1,3)
  plot(i_sim);
  title('Interest rate')
  hold on
  plot(rn_sim,'k:');
  legend('Nominal','Natural')
  xlim([1 nper])