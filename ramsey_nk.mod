var y, pi, i, p, rr, rn; 
varexo e;
parameters beta, gamma, sigma, kappa, r, rho, lambda;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  gamma   = 0.9;                      % indexation to past inflation
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  lambda  = 0.003;                  % weight on output gap in loss function
  
% EXOGENOUS SHOCK PROCESS: NATURAL REAL RATE
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.95;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
pi-gamma*pi(-1) = beta*(pi(+1)-gamma*pi) + kappa*y;
rr = i - pi(+1);
pi = p - p(-1);
rn = r + rho*(rn(-1)-r) + e;
end;

planner_objective pi^2 + lambda*y^2; 

ramsey_model(planner_discount=1/1.005);

initval;
rn = -r;
end;

ramsey_constraints;
i > 0;
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
