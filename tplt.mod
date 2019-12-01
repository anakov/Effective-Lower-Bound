var        y, pi, i, rr, rn, p, dy, u; 
varexo     eps, ups;
parameters beta, gamma, sigma, lambda, kappa, epsilon, rho, r;

beta    = 1/1.005;        % quarterly time discount factor 
gamma   = 0;              % indexation to past inflation
sigma   = 2;              % coefficient of relative risk aversion 
kappa   = 0.024;          % slope of the Phillips curve 
epsilon = 8;              % elasticity of substitution among varieties
rho     = 0.95;           % shock persistence parameter
r       = 100*(1/beta-1); % steady-state (net, quarterly, x100)  
lambda  = kappa/epsilon;  % weight on output gap in CB loss function 

model;      

rn-r = rho*(rn(-1)-r) + eps;
u = rho*u(-1) + ups;

pi = p - p(-1);
dy = y - y(-1);
rr = i - pi(+1);

y  = y(+1) - (rr-rn)/sigma;
pi-gamma*pi(-1) = beta*(pi(+1)-gamma*pi) + kappa*y + u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mcp = 'i > 0'] %% ALTERNATIVE RULES:
%0 = (pi + y/epsilon);                                       % IT
 0 = (p + y/epsilon);                                        % PLT
%  0 = (p + y/epsilon)*(p<0)     + (pi + y/epsilon)*(p>0);      % TPLT
% 0 = (p + y/epsilon)*(rn<0.25) + (pi + y/epsilon)*(rn>0.25); % XTPLT
% i = r + 800*p + 100*y;                                      % IRRRPL
% i = r + 2*p + 0.25*y;                                       % IRRRPL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end;

% planner_objective pi^2 + lambda*y^2; 
% ramsey_model(planner_discount=1/1.005);

initval;
rn = -r;
end;

shocks; 
var eps;
periods   1;
values    0;
end;

% ramsey_constraints;
% i > 0;
% end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver(lmmcp);

cut = [2 40];

color = 'r--';

figure(1)
set(gcf,'Name','Responses to natural real rate shock')

subplot(231)
plot(4*rn-2,color)
title('Natural real rate shock','FontSize',12)
hold on
xlim([1 cut(2)])

subplot(232)
plot(4*i,color)
title('Nominal interest rate','FontSize',12)
hold on
xlim(cut)

subplot(233)
plot(4*pi+2,color)
title('Inflation','FontSize',12)
hold on
xlim(cut)

subplot(234)
plot(4*rr-2,color)
title('Real interest rate','FontSize',12)
hold on
xlim(cut)
xlabel('Quarters')

subplot(235)
plot(y,color)
title('Output gap','FontSize',12)
hold on
xlim(cut)
xlabel('Quarters')

subplot(236)
trend = [1:(0.02/4):2.005]';
plot(p+trend,color)
title('Price level','FontSize',12)
hold on
xlim([1 cut(2)])
xlabel('Quarters')