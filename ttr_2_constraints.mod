var y, pi, i, rr, rn, u; 
varexo e, eps;
parameters beta, sigma, kappa, elb, ub, r, rho, phi_pi, phi_y;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  elb     = 0/4;                    % effective lower bound  
  ub      = 3/4;                    % upper bound
  phi_pi  = 1.5;                    % reaction to inflation
  phi_y   = 0.5;                    % reaction to output gap
  
% EXOGENOUS SHOCK PROCESS: NATURAL REAL RATE
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.95;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
pi = beta*pi(+1) + kappa*y;
i  = min(max(elb, r + phi_pi*pi + phi_y*y + u),ub);                         
rr = i - pi(+1);
rn = r + rho*(rn(-1)-r) + e;
u  = rho*u(-1) + eps;
end;

initval;
rr = r;
rn = r;
i = r;
end;

steady; check;

initval;
%rn = (-2/4-r)/rho + r;
rn = r;
end;

endval;
rn = r;
end;

shocks; 
var e;
periods  1:1  2:10  11:21   22:200; 
values   0    0.1  -0.1   0;
end;

simul(periods=200, maxit=500, stack_solve_algo=0);
do_irf;