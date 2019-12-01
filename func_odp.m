% Function file for OPTIMAL DISCRETIONARY POLICY WITH ZERO FLOOR ON THE NOMINAL INTEREST RATE
% Program for the article "Optimal and Simple Monetary Policy Rules
% with Zero Floor on the Nominal Interest Rate", 
% International Journal of Central Banking, Vol. 4(2), pages 73-127, June
% (C) Anton Nakov 

function [out1,out2,out3] = func_odp(flag,rn,xx,ep,e,sigma,rho,kappa,lx,beta,rnstst)  
n  = length(rn);
pi = xx(:,1);
x  = xx(:,2);
i  = xx(:,3);

switch flag
case 'b'; % BOUND FUNCTION
   out1(:,1) = -inf*ones(n,1);                            % pi low
   out1(:,2) = -inf*ones(n,1);                            % x  low
   out1(:,3) = zeros(n,1);                                % i  low
   
   out2(:,1) = inf*ones(n,1);                             % pi high
   out2(:,2) = inf*ones(n,1);                             % x  high
   out2(:,3) = inf*ones(n,1);                             % i  high
     
case 'f'; % EQUILIBRIUM FUNCTION
   out1(:,1) = pi - beta*ep(:,1) - kappa*x;               % f1
   out1(:,2) = x - ep(:,2) + 1/sigma*(i  - ep(:,1) - rn); % f2
   out1(:,3) = -i.*(lx*x + kappa*pi);                     % f3
   
   out2(:,1,1) = ones(n,1);                               % f1pi
   out2(:,1,2) = -kappa*ones(n,1);                        % f1x
   out2(:,1,3) = zeros(n,1);                              % f1i

   out2(:,2,1) = zeros(n,1);                              % f2pi
   out2(:,2,2) = ones(n,1);                               % f2x
   out2(:,2,3) = 1/sigma*ones(n,1);                       % f2i
 
   out2(:,3,1) = -kappa*i;                                % f3pi
   out2(:,3,2) = -lx*i;                                   % f3x
   out2(:,3,3) = -(lx*x + kappa*pi);                      % f3i
   
   out3(:,1,1) = -beta*ones(n,1);                         % f1e1
   out3(:,1,2) = zeros(n,1);                              % f1e2
   out3(:,2,1) = -ones(n,1)/sigma;                        % f2e1
   out3(:,2,2) = -ones(n,1);                              % f2e2
   out3(:,3,1) = zeros(n,1);                              % f3e1
   out3(:,3,2) = zeros(n,1);                              % f3e2
   
case 'g'; % STATE TRANSITION FUNCTION
   out1 = rho*rn + (1-rho)*rnstst + e;                    % g
   out2(:,1,1) = zeros(n,1);                              % gpi
   out2(:,1,2) = zeros(n,1);                              % gx
   out2(:,1,3) = zeros(n,1);                              % gi
 
case 'h'; % EXPECTATION FUNCTION
   out1(:,1) = pi;                                        % e1
   out1(:,2) = x;                                         % e2

   out2(:,1,1) = ones(n,1);                               % e1pi        
   out2(:,1,2) = zeros(n,1);                              % e1x        
   out2(:,1,3) = zeros(n,1);                              % e1i        

   out2(:,2,1) = zeros(n,1);                              % e2pi       
   out2(:,2,2) = ones(n,1);                               % e2x  
   out2(:,2,3) = zeros(n,1);                              % e2i   

   out3(:,1,1) = zeros(n,1);                              % e1rn          
   out3(:,2,1) = zeros(n,1);                              % e2rn
end 