var y, pi, i, rr, rn, tr, p, phi_pi, phi_p; 
varexo e;
parameters beta, sigma, kappa, elb, r, rho, phi_y;

% Model Parameters
  beta    = 1/1.005;             % quarterly time discount factor 
  sigma   = 2;                   % relative risk aversion 
  kappa   = 0.024;               % slope of the Phillips curve 
  phi_y   = 0.5;                 % reaction to output gap
  elb     = 0/4;                 % effective lower bound    

% Natural Real Interest Rate Process 
  r   = 100*(1/beta-1);          % steady-state (quarterly x 100)  
  rho = 0.95;                    % persistence

model;      

y  = y(+1) - 1/sigma*(rr - rn);
pi = beta*pi(+1) + kappa*y;
i  = max(elb, tr);                         
tr = r + phi_pi*pi + phi_p*p + phi_y*y;

pi = p - p(-1);
rr = i - pi(+1);

rn = r + rho*(rn(-1)-r) + e;

% phi_pi = 1.5;
% phi_p  = 0;
phi_pi = 1.5*(rn>0.25);
phi_p  = 1.5*(rn<0.25);

end;

initval;
phi_p  = 1.5;
phi_pi = 1.5;
rr = r;
rn = r;
tr = r;
i  = r;
p  = 0;
pi = 0;
end;

steady; check;

initval;
rn = -r;
end;

endval;
rn = r;
end;

simul(periods=200, maxit=500, stack_solve_algo=0);

figure(1)
cut = [2 60];

subplot(231)
plot(4*rn)
title('$r^n_t$','FontSize',14,'interpreter','latex')
set(gcf,'Name','Responses to natural real rate shock')
hold on
xlim(cut)

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

