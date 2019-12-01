var    c n y r pi yhat ghat g beta; 
varexo ub ug; 
 
parameters alpha gamma chi varphi epsilon betass rhog rhob gbar phipi phig; 
 
gamma       = 2; 
chi         = 11; 
varphi      = 1; 
epsilon     = 7; 
betass      = (1/1.04)^(1/12);
rhob        = 0.95;
rhog        = 0.9; 
alpha       = 0.9; 
gbar        = 0.07;
phipi       = 2;
phig        = 0;

model; 
# nu_u = gamma*STEADY_STATE(y)/STEADY_STATE(c);    
# nu_v = varphi*STEADY_STATE(y)/STEADY_STATE(n);    
# capgamma = nu_u/(nu_u + nu_v);
# kappa = (1-alpha)*(1-alpha*betass)/alpha*(nu_u + nu_v);
y = n; 
y = c + g;
yhat-ghat = yhat(+1)-ghat(+1) - 1/nu_u*(r - pi(+1) + log(beta(+1)));
yhat = log(y/STEADY_STATE(y));
ghat = (g-STEADY_STATE(g))/STEADY_STATE(y);
pi = beta(+1)*pi(+1) + kappa*(yhat-capgamma*ghat);
r = max(-log(betass) + phipi*pi + phig*log(g/gbar),0);
g/gbar = (g(-1)/gbar)^rhog*exp(ug);
beta/betass = (beta(-1)/betass)^rhob*exp(ub); 
end; 
 
shocks; 
var ug; stderr .01; 
var ub; stderr .01; 
end; 
 
yss = fsolve(@(y) epsilon/(epsilon-1)*chi*y^varphi*(y-gbar)^gamma - 1,0.5);

initval; 
beta   = betass;
g      = gbar;
r      = -log(beta);   
y      = yss; 
c      = y - g;    
n      = y;    
end; 

steady;

shocks; 
var ub;
periods  1:1; 
values  0.005;
end;

simul(periods=200, maxit=500, stack_solve_algo=0);

figure(1)
subplot(311)
plot(1200*r);
title('r')
hold on
xlim([0 50])
subplot(312)
plot(y/yss-1);
title('y/yss');
hold on
xlim([0 50])
subplot(313)
plot(pi);
title('pi');
hold on
xlim([0 50])



