var    c n y yhat r pi pstar w D K F;
var    beta; 
varexo e; 
 
parameters b gamma chi phi eps rho alpha g lambda; 

b      = (1/1.04)^(1/12);
gamma  = 2; 
chi    = 11; 
phi    = 1; 
eps    = 7; 
rho    = 0.9;
alpha  = 0.10; 
g      = 0.07;
lambda = 0.003;
 
model; 
y = c + g;
y = n/D; 
yhat = log(y/STEADY_STATE(y));
w = chi*c^gamma*n^phi; 
1 = r*beta(+1)*(c(+1)/c)^(-gamma)/pi(+1); 
1 = alpha*pstar^(1-eps) + (1-alpha)*pi^(eps-1); 
D = alpha*pstar^(-eps)  + (1-alpha)*pi^(eps)*D(-1); 
K = c^(-gamma)*eps/(eps-1)*w*y + beta(+1)*(1-alpha)*pi(+1)^(eps)*K(+1); 
F = c^(-gamma)*y + beta(+1)*(1-alpha)*pi(+1)^(eps-1)*F(+1); 
pstar = K/F;
log(beta)= (1-rho)*log(b) + rho*log(beta(-1)) + e;
end; 

planner_objective (pi-1)^2 + lambda*yhat^2;  
% planner_objective -log(c) + chi*n^(1+phi)/(1+phi); 

ramsey_model(planner_discount=(1/1.04)^(1/12));

yss = fsolve(@(y) eps/(eps-1)*chi*y^phi*(y-g)^gamma - 1,0.475018591498115);

initval;
y     = yss; 
beta  = b;
r     = 1/beta;
pi    = 1;    
pstar = 1;    
D     = 1;    
c     = y - g;    
n     = y;    
w     = chi*n^phi*c^gamma; 
K     = c^(-gamma)*eps/(eps-1)*w*y/(1-beta*alpha); 
F     = c^(-gamma)*y/(1-beta*alpha); 
end; 

shocks; 
var e;
periods 1:1; 
values  0.02;
end;

ramsey_constraints;
r > 1;
end;

perfect_foresight_setup(periods=200);

options_.stack_solve_algo = 7;
options_.solve_algo = 10;

perfect_foresight_solver;

figure(1)
cut = [0 200];
subplot(311)
  plot(100*(r.^12-1));
  title('r')
  xlim(cut)
  hold on
subplot(312)
  plot(100*(yhat));
  title('yhat');
  xlim(cut)
  hold on
subplot(313)
  plot(100*(pi.^12-1));
  title('pi');
  xlim(cut)
  hold on