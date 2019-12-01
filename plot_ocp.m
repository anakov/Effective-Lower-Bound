% PLOT OPTIMAL POLICY FUNCTIONS

  PI = 4*xx(:,:,:,1); % optimal inflation
  X  = 4*xx(:,:,:,2); % optimal output gap
  I  = 4*xx(:,:,:,3); % optimal nominal interest rate
 
  rn     = 4*s{1};
  phi1   = 4*s{2};
  phi2   = 4*s{3}; 

  pi = reshape(PI(:,:,2),length(rn),length(phi1));
  x  = reshape(X(:,:,2),length(rn),length(phi1));
  i  = reshape(I(:,:,2),length(rn),length(phi1));
  
% PLOT OPTIMAL INFLATION  
  figure
  surf(phi1,rn,pi);
  title('Inflation Policy');
  xlabel('\phi_{t-1}');
  ylabel('r^{n}_{t}');
  zlabel('\pi_{t}');
  view(60,20);
  axis tight

% PLOT OPTIMAL OUTPUT GAP
  figure
  surf(phi1,rn,x);
  title('Output Gap');
  xlabel('\phi_{t-1}');
  ylabel('r^{n}_{t}');
  zlabel('x_{t}');
  view(60,20);
  axis tight
    
% PLOT OPTIMAL NOMINAL INTEREST RATE
  figure
  surf(phi1,rn,i);
  title('Nominal interest rate','FontSize',14,'interpreter','latex');
  xlabel('$\phi_{t-1}$','FontSize',14,'interpreter','latex');
  ylabel('$r^{n}_{t}$','FontSize',14,'interpreter','latex');
  zlabel('$i_{t}$','FontSize',14,'interpreter','latex');
  %view(60,20);
  axis tight
  
