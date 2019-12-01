var    c n y r pi yhat ghat g beta; 
varexo ub ug; 
 
parameters alpha gamma chi varphi epsilon b rhog rhob gbar lambda; 
 
gamma       = 2; 
chi         = 11; 
varphi      = 1; 
epsilon     = 7; 
b           = (1/1.04)^(1/12);
rhob        = 0.9;
rhog        = 0.9; 
alpha       = 0.9; 
gbar        = 0.07;
phipi       = 2;
phig        = 0;
lambda      = 0.003;

model; 
# nu_u = gamma*STEADY_STATE(y)/STEADY_STATE(c);    
# nu_v = varphi*STEADY_STATE(y)/STEADY_STATE(n);    
# capgamma = nu_u/(nu_u + nu_v);
# kappa = (1-alpha)*(1-alpha*b)/alpha*(nu_u + nu_v);
y = n; 
y = c + g;
yhat-ghat = yhat(+1)-ghat(+1) - 1/nu_u*(r - pi(+1) + log(beta(+1)));
yhat = log(y/STEADY_STATE(y));
ghat = (g-STEADY_STATE(g))/STEADY_STATE(y);
pi = beta(+1)*pi(+1) + kappa*(yhat-capgamma*ghat);
g/gbar = (g(-1)/gbar)^rhog*exp(ug);
beta/b = (beta(-1)/b)^rhob*exp(ub); 
end; 
 
yss = fsolve(@(y) epsilon/(epsilon-1)*chi*y^varphi*(y-gbar)^gamma - 1,0.5);

initval; 
beta   = b;
g      = gbar;
r      = -log(beta);   
y      = yss; 
c      = y - g;    
n      = y;    
end; 

planner_objective pi^2 + lambda*yhat^2; 

ramsey_model(planner_discount=(1/1.04)^(1/12));

shocks; 
var ub;
periods 1:1; 
values  0.02;
end;

ramsey_constraints;
r > 0;
%r < 0.005;
end;

perfect_foresight_setup(periods=200);

options_.stack_solve_algo = 7;
options_.solve_algo = 10;

perfect_foresight_solver;

figure(1)
cut = [0 200]
subplot(311)
  plot(100*(exp(r).^12-1));
  title('r')
  xlim(cut)
  hold on
subplot(312)
  plot(100*(yhat));
  title('yhat');
  xlim(cut)
  hold on
subplot(313)
  plot(100*(exp(pi).^12-1));
  title('pi');
  xlim(cut)
  hold on