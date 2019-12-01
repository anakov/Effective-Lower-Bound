var Y, mcHAT, yHAT, C, L, D, N, w, PI, PIstar, R, DP, mc, beta;  

varexo e;

parameters alpha, b, theta, epsilon, psi, lambda, PI_bar, R_bar, rho;

PI_bar  = 1^(1/4);
R_bar   = 1.04^(1/4);
b       = PI_bar/R_bar;
alpha   = 0.667;
theta	= 0.75;
epsilon = 6;
psi     = 1;
rho     = 0.9;
lambda  = 0.003;

model;
C = Y;
w = C*L^psi;
1 = beta(+1)*R*C/C(+1)/PI(+1);
N = mc*Y/C + theta*beta(+1)*PI(+1)^epsilon*N(+1);
D = PIstar*(Y/C + theta*beta(+1)*PI(+1)^(epsilon-1)/PIstar(+1)*D(+1));
N/D = (epsilon-1)/epsilon;
1  = theta*(PI)^(epsilon-1) + (1-theta)*(PIstar)^(1-epsilon);
DP = theta*(PI)^epsilon*DP(-1) + (1-theta)*(PIstar)^(-epsilon);
w*L = alpha*mc*Y*DP;
Y = L^alpha/DP;
mcHAT = log(mc/STEADY_STATE(mc));
yHAT = log(Y/STEADY_STATE(Y));
log(beta)= (1-rho)*log(b) + rho*log(beta(-1)) + e;
end;

initval;
beta = b;
PI = PI_bar;
R  = PI/beta;
PIstar = ((1 - theta*(PI)^(epsilon-1))/(1-theta))^(1/(1-epsilon));
DP = (1-theta)*PIstar^(-epsilon)/(1-theta*PI^(epsilon));
mc = (epsilon-1)/epsilon;         % approx.(assuming flex. markup)
L  = (alpha*mc*DP)^(1/(1+psi));   % approx.(assuming Y = C)
Y  = L^alpha/DP;
C  = Y;
w  = C*L^psi;
D  = PIstar*Y/C/(1-beta*theta*PI^(epsilon-1)/PIstar);
N  = (epsilon-1)*D/epsilon;
end;

  planner_objective - log(C) + L^(1+psi)/(1+psi); 
% planner_objective (PI-1)^2 + lambda*(mcHAT)^2; 

ramsey_model(planner_discount=1.0^(1/4)/1.04^(1/4));

shocks; 
var e;
periods 1:1; 
values  0.02;
end;

ramsey_constraints;
R > 1;
end;

perfect_foresight_setup(periods=200);

options_.stack_solve_algo = 7;
options_.solve_algo = 10;

perfect_foresight_solver;

figure(1)
cut = [0 200]
subplot(311)
    plot(100*(R.^4-1));
    title('R')
    xlim(cut)
    hold on
subplot(312)
    plot(100*(PI.^4-1));
    title('PI')
    xlim(cut)
    hold on
subplot(313)
    plot(100*(yHAT));
    title('yHAT')
    xlim(cut)
    hold on


