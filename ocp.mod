var y, pi, i, rr, rn, p, phi1, phi2; 
varexo e;
parameters beta, sigma, kappa, lambda, elb, r, rho;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  lambda  = 0.003;                  % weight on output gap in loss function
  elb     = -0.0/4;                % effective lower bound
  
% EXOGENOUS SHOCK PROCESS 
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.95;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
pi = beta*pi(+1) + kappa*y;
phi1 = (kappa/sigma +1)/beta*phi1(-1) + kappa*phi2(-1) - kappa*pi - lambda*y; 
phi2 = phi2(-1) + phi1(-1)/(beta*sigma) - pi;        
0 = min(i-elb, phi1);           
rr = i - pi(+1);
pi = p - p(-1);
rn = r + rho*(rn(-1)-r) + e;
end;

initval;
rr = r;
rn = r;
i = r;
phi1 = 0;
phi2 = 0;
end;

steady; check;

initval;
rn = - r;
phi1 = 0;
end;

endval;
rn = r;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver(lmmcp);

cut = [2 60];

figure(1)
set(gcf,'Name','Responses to natural real rate shock')

subplot(231)
plot(4*rn)
title('$r^n_t$','FontSize',14,'interpreter','latex')
hold on
xlim([1 cut(2)])

subplot(232)
plot(4*i)
title('$i_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(233)
plot(4*pi)
title('$\pi_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(234)
plot(4*rr)
title('$r_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(235)
plot(y)
title('$y_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(236)
plot(p)
title('$p_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)
