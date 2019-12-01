var    c n y r pi pstar w Delta K F;
var    beta g;
varexo ub ug; 
 
parameters gamma betass chi varphi epsilon rhob rhog lambda gbar phir phipi phig; 

gamma       = 2; 
chi         = 11; 
varphi      = 1; 
epsilon     = 7; 
betass      = (1/1.04)^(1/12);
rhob        = 0.95;
rhog        = 0.9;
lambda      = 1/10; 
gbar        = 0.07;
phipi       = 2;
phig        = 0;
phir        = 0;
 
model; 
c^(-gamma)*w = chi*n^varphi; 
1 = r*beta(+1)*(c(+1)/c)^(-gamma)/pi(+1); 
n = y*Delta; 
y = c + g;
1 = lambda*pstar^(1-epsilon) + (1-lambda)*pi^(epsilon-1); 
Delta = lambda*pstar^(-epsilon) + (1-lambda)*pi^epsilon*Delta(-1); 
pstar = K/F; 
K = c^(-gamma)*epsilon/(epsilon-1)*w*y + beta(+1)*(1-lambda)*pi(+1)^epsilon*K(+1); 
F = c^(-gamma)*y + beta(+1)*(1-lambda)*pi(+1)^(epsilon-1)*F(+1); 
r = max((1/betass)*(r(-1)/(1/betass))^phir*((pi/1)^phipi*(g/gbar)^phig)^(1-phir),1);
g/gbar = (g(-1)/gbar)^rhog*exp(ug);
beta/betass = (beta(-1)/betass)^rhob*exp(ub); 
end; 
 
 
yss = fsolve(@(y) epsilon/(epsilon-1)*chi*y^varphi*(y-gbar)^gamma - 1, .3);

initval; 
y       = yss; 
g       = gbar;
c       = y - g;    
n       = y;    
beta    = betass;
r       = 1/beta;
pi      = 1;    
pstar   = 1;    
w       = chi*n^varphi*c^gamma; 
Delta   = 1;    
K       = c^(-gamma)*epsilon/(epsilon-1)*w*y/(1-beta*lambda); 
F       = c^(-gamma)*y/(1-beta*lambda); 
end; 

steady;

shocks; 
var ub;
periods  1:1 ; 
values   0.005;  
end;

simul(periods=200, maxit=500, stack_solve_algo=0);

figure(1)
subplot(311)
plot(1200*(r-1));
title('r')
hold on
xlim([0 50])
subplot(312)
plot(y/yss-1);
title('y/yss');
hold on
xlim([0 50])
subplot(313)
plot(pi-1);
title('pi');
hold on
xlim([0 50])




