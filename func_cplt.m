% Function file for CONSTANT PRICE LEVEL TARGETING RULE 
% Program for the article "Optimal and Simple Monetary Policy Rules
% with Zero Floor on the Nominal Interest Rate", 
% International Journal of Central Banking, Vol. 4(2), pages 73-127, June
% (C) Anton Nakov 
function [out1,out2,out3] = func_cplt(flag,s,xx,ep,e,sigma,rho,kappa,lx,beta,rnstst)

rn      = s(:,1);
p_lag   = s(:,2); 

n  = length(rn);

if ~isempty(ep)
   E_pi = ep(:,1);
   E_x  = ep(:,2);
end    
if ~isempty(xx)
   pi = xx(:,1);
   x  = xx(:,2);
   i  = xx(:,3);
   p = p_lag + pi/100;
end

switch flag

case 'b'; % BOUND FUNCTION

   out1(:,1) = -inf*ones(n,1);                            % pi low
   out1(:,2) = -inf*ones(n,1);                            % x  low
   out1(:,3) = zeros(n,1);                                % i  low
   
   out2(:,1) = inf*ones(n,1);                             % pi high
   out2(:,2) = inf*ones(n,1);                             % x  high
   out2(:,3) = inf*ones(n,1);                             % i  high
     
case 'f'; % EQUILIBRIUM FUNCTION

   out1(:,1) = pi - beta*E_pi - kappa*x;                  % f1 (NKPC)
   out1(:,2) = x - E_x + 1/sigma*(i  - E_pi - rn);        % f2 (NIS)
   out1(:,3) = i.*(p + lx/kappa*x);                       % f3 (ZB)

   out2(:,1,1) = ones(n,1);                               % f1pi
   out2(:,1,2) = -kappa*ones(n,1);                        % f1x
   out2(:,1,3) = zeros(n,1);                              % f1i
    
   out2(:,2,1) = zeros(n,1);                              % f2pi
   out2(:,2,2) = ones(n,1);                               % f2x
   out2(:,2,3) = 1/sigma*ones(n,1);                       % f2i

   out2(:,3,1) = i/100;                                   % f3pi   p = p_lag + pi/100;
   out2(:,3,2) = lx/kappa*i;                              % f3x
   out2(:,3,3) = p + lx/kappa*x;                          % f3i
     
   out3(:,1,1) = -beta*ones(n,1);                         % f1E_pi
   out3(:,1,2) = zeros(n,1);                              % f1E_x
   
   out3(:,2,1) = -ones(n,1)/sigma;                        % f2E_pi
   out3(:,2,2) = -ones(n,1);                              % f2E_x
   
   out3(:,3,1) = zeros(n,1);                              % f3E_pi
   out3(:,3,2) = zeros(n,1);                              % f3E_x
    
case 'g'; % STATE TRANSITION FUNCTION
    
   out1(:,1)  = rho*rn + (1-rho)*rnstst + e;              % g1
   out1(:,2)  = p;                                        % g2
        
   out2(:,1,1) = zeros(n,1);                              % g1pi
   out2(:,1,2) = zeros(n,1);                              % g1x
   out2(:,1,3) = zeros(n,1);                              % g1i
   
   out2(:,2,1) = ones(n,1)/100;                           % g2pi
   out2(:,2,2) = zeros(n,1);                              % g2x
   out2(:,2,3) = zeros(n,1);                              % g2i
   
case 'h'; % EXPECTATION FUNCTION
    
   out1(:,1) = pi;                                        % E_pi
   out1(:,2) = x;                                         % E_x
   
   out2(:,1,1) = ones(n,1);                               % E_pi_pi        
   out2(:,1,2) = zeros(n,1);                              % E_pi_x        
   out2(:,1,3) = zeros(n,1);                              % E_pi_i        

   out2(:,2,1) = zeros(n,1);                              % E_x_pi       
   out2(:,2,2) = ones(n,1);                               % E_x_x  
   out2(:,2,3) = zeros(n,1);                              % E_x_i   

   out3(:,1,1) = zeros(n,1);                              % E_pi_rn          
   out3(:,2,1) = zeros(n,1);                              % E_x_rn
   
   out3(:,1,2) = zeros(n,1);                              % E_pi_p   
   out3(:,2,2) = zeros(n,1);                              % E_x_p
   
end 