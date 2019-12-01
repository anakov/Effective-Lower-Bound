function [out1,out2,out3] = func_ttr2(flag,s,xx,ep,e,sigma,rho,kappa,beta,rnstst,elb)  
% FUNCTION FILE FOR TRUNCATED TAYLOR RULE 
% Program for the article "Optimal and Simple Monetary Policy Rules
% with Zero Floor on the Nominal Interest Rate", 
% International Journal of Central Banking, Vol. 4(2), pages 73-127, June
% (C) Anton Nakov 

rn    = s(:,1);
n     = length(rn);

if ~isempty(ep)
   E_pi = ep(:,1);
   E_x  = ep(:,2);
end  
if ~isempty(xx)
   pi = xx(:,1);
   x  = xx(:,2);
end

switch flag

case 'b'; % BOUND FUNCTION
  
   out1(:,1) = -inf*ones(n,1);                            % pi low
   out1(:,2) = -inf*ones(n,1);                            % x  low
   
   out2(:,1) = inf*ones(n,1);                             % pi high
   out2(:,2) = inf*ones(n,1);                             % x  high
   
case 'f'; % EQUILIBRIUM FUNCTION
   i = taylor(rnstst, pi, x, elb); 
   
   out1(:,1) = pi - (beta*(E_pi) + kappa*x);              % f1 (NKPC)
   out1(:,2) = x - E_x + 1/sigma*(i  - E_pi - rn);        % f2 (NKIS)
   
   out2(:,1,1) = (ones(n,1));                             % f1_pi
   out2(:,1,2) = -kappa/ones(n,1);                        % f1_x

   out2(:,2,1) = zeros(n,1);                              % f2_pi
   out2(:,2,2) = ones(n,1);                               % f2_x
 
   out3(:,1,1) = -beta/ones(n,1);                         % f1E_pi
   out3(:,1,2) = zeros(n,1);                              % f1E_x
   out3(:,2,1) = -ones(n,1)/sigma;                        % f2E_pi
   out3(:,2,2) = -ones(n,1);                              % f2E_x
   
case 'g'; % STATE TRANSITION FUNCTION
   out1(:,1) = rho*rn + (1-rho)*rnstst + e;               % g1
   out2(:,1,1) = zeros(n,1);                              % g1_pi
   out2(:,1,2) = zeros(n,1);                              % g1_x
    
case 'h'; % EXPECTATION FUNCTION
   out1(:,1) = pi;                                        % E(pi)
   out1(:,2) = x;                                         % E(x)

   out2(:,1,1) = ones(n,1);                               % E(pi)_pi        
   out2(:,1,2) = zeros(n,1);                              % E(pi)_x        

   out2(:,2,1) = zeros(n,1);                              % E(x)_pi       
   out2(:,2,2) = ones(n,1);                               % E(x)_x  

   out3(:,1,1) = zeros(n,1);                              % E(pi)_rn          
   out3(:,2,1) = zeros(n,1);                              % E(x)_rn
end 