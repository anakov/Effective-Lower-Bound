var y, pi, i, rr, rn, phi1, phi2; 
varexo e;
parameters beta, sigma, kappa, lambda, elb, r, rho;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  lambda  = 0.003;                  % weight on output gap in loss function
  elb     = 0;                      % effective lower bound
  
% EXOGENOUS SHOCK PROCESS: NATURAL REAL RATE 
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.95;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
[mcp = 'pi < 0.01']
pi = beta*pi(+1) + kappa*y;
phi1 = (kappa/sigma+1)/beta*phi1(-1)+kappa*phi2(-1)-kappa*pi-lambda*y; 
phi2 = phi2(-1) + phi1(-1)/(beta*sigma) - pi;        
0 = min(i-elb, phi1);           
rr = i - pi(+1);
rn = r + rho*(rn(-1)-r) + e;
end;

initval;
rn = -0.5;
phi1 = 0;
end;

endval;
rn = r;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver(lmmcp);

do_irf;