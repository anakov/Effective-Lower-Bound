var y, pi, i, rr, rn; 
varexo e;
parameters beta, sigma, kappa, lambda, elb, r, rho;

% Program execution parameters

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 2;                      % relative risk aversion 
  kappa   = 0.024;                  % slope of the Phillips curve 
  lambda  = 0.003;                  % weight on output gap in loss function
  elb     = 0/4;                    % effective lower bound  
  
% EXOGENOUS SHOCK PROCESS 
  r   = 100*(1/beta-1);             % steady-state (quarterly x 100)  
  rho = 0.85;                       % persistence

model;      
y  = y(+1) - 1/sigma*(rr - rn);
pi = beta*pi(+1) + kappa*y;
0 = min(i-elb, -(pi + lambda/kappa*y));           
rr = i - pi(+1);
rn = r + rho*(rn(-1)-r) + e;
end;

initval;
rr = r;
rn = r;
i = r;
end;

steady; check;

initval;
rn = (-2/4-r)/rho + r;
%rn = r;
end;

endval;
rn = r;
end;

%shocks; 
%var e;
%periods  1:5  6:24  26:200 ; 
%values   0   -0.05     0;
%end;


simul(periods=200, maxit=500, stack_solve_algo=0);
do_irf;