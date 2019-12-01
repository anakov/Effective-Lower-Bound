var Y, C, L, D, N, w, PI, PIstar, R, DP, mc, beta;  

varexo e;

parameters alpha, beta_ss, theta, epsilon, psi, phi_pi, PI_bar, R_bar, rho;

PI_bar  = 1.0^(1/4);
R_bar   = 1.04^(1/4);
beta_ss = PI_bar/R_bar;
alpha   = 1;
theta	= 0.75;
epsilon = 6;
psi     = 1;
phi_pi  = 1.5;  
rho     = 0.9;

model;
C = Y;
w = C*L^psi;
1 = beta(+1)*R*C/C(+1)/PI(+1);
N = mc*Y/C +theta*beta(+1)*PI(+1)^epsilon*N(+1);
D = PIstar*(Y/C + theta*beta(+1)*PI(+1)^(epsilon-1)/PIstar(+1)*D(+1));
N/D = (epsilon-1)/epsilon;
1 = theta*(PI)^(epsilon-1) + (1-theta)*(PIstar)^(1-epsilon);
DP = theta*(PI)^epsilon*DP(-1) + (1-theta)*(PIstar)^(-epsilon);
w*L = alpha*mc*Y*DP;
Y = L^alpha/DP;
R = max(1, PI_bar/beta_ss + phi_pi*(PI-PI_bar)); 
log(beta)= (1-rho)*log(beta_ss) + rho*log(beta(-1)) + e;
end;

initval;
beta = beta_ss;
PI = PI_bar;
R  = PI/beta;
PIstar = ((1 - theta*(PI)^(epsilon-1))/(1-theta))^(1/(1-epsilon));
DP  = (1-theta)*PIstar^(-epsilon)/(1-theta*PI^(epsilon));
mc  = (epsilon-1)/epsilon;         % approximation (assuming flex. markup)
L   = (alpha*mc*DP)^(1/(1+psi));   % approximation (assuming Y = C)
Y  = L^alpha/DP;
C  = Y;
w = C*L^psi;
D  = PIstar*Y/C/(1-beta*theta*PI^(epsilon-1)/PIstar);
N = (epsilon-1)*D/epsilon;
end;

steady; check;

shocks; 
var e;
periods  1:1   2:200 ; 
values   0.01  0;
end;

simul(periods=200, maxit=500, stack_solve_algo=0);

figure(1)
subplot(211)
plot(100*(R.^4-1));
xlim([0 50])
subplot(212)
plot(100*(PI.^4-1));
xlim([0 50])

