var y, pi, i, rr, rn; 
varexo e;
parameters beta, sigma, kappa, elb, r, rho, lambda;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  lambda  = 0.003;                  % weight on output gap in loss function
  elb     = 0/4;                    % effective lower bound  
  
% EXOGENOUS SHOCK PROCESS: NATURAL REAL RATE
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.95;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
[mcp = 'pi < 0.01']
pi = beta*pi(+1) + kappa*y;
rr = i - pi(+1);
rn = r + rho*(rn(-1)-r) + e;
end;

planner_objective pi^2 + lambda*y^2; 

ramsey_model(planner_discount=1/1.005);

initval;
rn = -0.5;
end;

ramsey_constraints;
i > 0;
end;

perfect_foresight_setup(periods=200);

perfect_foresight_setup(periods=200);
// useful to check what lmmcp is doing
options_.lmmcp.Display = 'iter';
perfect_foresight_solver(lmmcp);

do_irf;
