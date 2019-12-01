var y, pi, i, rr, rn; 
varexo e;
parameters beta, sigma, kappa, r, rho, phi_pi, pibar, R_bar;

% Program execution parameters

% MODEL PARAMETERS 
PI_bar  = 1.0^(1/4);
R_bar   = 1.04^(1/4);
pibar   = 100*(PI_bar - 1);
beta = PI_bar/R_bar;
theta	= 0.75;
epsilon = 6;
psi     = 1;
phi_pi  = 1.5;  
r       = 100*(1/beta-1); % steady-state natural real rate (quarterly x100)  
rho     = 0.9;
sigma   = 1;                      % relative risk aversion 
phi_pi  = 1.5;                    % reaction to inflation

%kappa   = (1-theta)*(1-theta*beta)/theta*(psi+sigma)/(1+psi*epsilon);
kappa   = (1-theta)*(1-theta*beta)/theta*(psi+sigma);
% slope of the Phillips curve 

model;      
y  = y(+1) - 1/sigma*(rr - rn);
pi-pibar = beta*(pi(+1)-pibar) + kappa*y;
i  = max(0, r + pibar + phi_pi*(pi-pibar));                         
rr = i - pi(+1);
rn = r + rho*(rn(-1)-r) + e;
end;

initval;
rn = r;
pi = pibar;
rr = r;
i = 100*(R_bar-1);
y = 0;
end;

steady; check;

shocks; 
var e;
periods  1:1  2:200 ; 
values  -0.9   0;
end;

simul(periods=200, maxit=500, stack_solve_algo=0);

figure(1)
subplot(211)
hold on
plot(((1+i/100).^4-1)*100)
xlim([0 50])
subplot(212)
hold on
plot(((1+pi/100).^4-1)*100)
xlim([0 50])
