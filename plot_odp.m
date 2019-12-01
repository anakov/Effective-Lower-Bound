% PLOT OPTIMAL POLICY FUNCTIONS
  pi    = 4*xx(:,1);
  x     = 4*xx(:,2);
  i     = 4*xx(:,3); 
  s     = 4*s;
  xinit = 4*xinit;  % solution without zero lower bound

  figure
% inflation
  subplot(3,1,1)
  plot(s,pi)
  hold on
  plot(s,xinit(:,1),'k:');
  ylabel('\pi');
    
% output gap  
  subplot(3,1,2)
  plot(s,x)
  hold on
  plot(s,xinit(:,2),'k:');
  ylabel('x');

% nominal interest rate  
  subplot(3,1,3)
  plot(s,i)
  hold on
  plot(s,xinit(:,3),'k:');
  xlabel('r_t^n');
  ylabel('i');
