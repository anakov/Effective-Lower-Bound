% OPTIMAL DISCRETIONARY POLICY WITH ZERO FLOOR ON THE NOMINAL INTEREST RATE
% (C) Anton Nakov 

% MODEL PARAMETERS (quarterly frequency)
  beta    = 1/1.005;                   % quarterly time discount factor 
  sigma   = 2;                         % relative risk aversion 
  kappa   = 0.024;                     % slope of the Phillips curve 
  lx      = 0.003;                     % inflation weight in loss f-n
  
% EXOGENOUS SHOCK PROCESS 
  rnstst  = 100*(1/beta-1);            % steady-state (quarterly x 100)  
  stdrn   = 0.5;                       % standard deviation 
  rho     = 0.65;                       % persistence
  vare    = stdrn^2*(1-rho^2);         % variance of the innovation
 
% DECLARE MODEL FUNCTION
  model.func = 'func_odp';  
  
% DEFINE APPROXIMATION SPACE
  n      = 101;                         % number of grid points
  smin   = -2/4;                        % minimum natural real interest rate 
  smax   = +4/4;                          % maximum natural real interest rate 
  fspace = fundefn('lin',n,smin,smax);   % function space
  scoord = funnode(fspace);              % state collocation grid coordinates
  snodes = gridmake(scoord);             % state collocation grid points
 
% SET OPTIONS 
  optset('remsolve','nres',1);           
  optset('arbit','lcpmethod','minmax');
  
% INITIALIZE
  nn    = length(snodes);
  xinit = [zeros(nn,1) zeros(nn,1) zeros(nn,1)+scoord];  % [inflation; output gap; nominal interest rate]
  hinit = zeros(nn,2);
  
% GAUSSIAN QUADRATURE 
  [e,w]   = qnwnorm(7,0,vare);           % (number of grid points; mean; variance)
  model.e = e;                           % shocks
  model.w = w;                           % probabilities

% SOLVE RATIONAL EXPECTATIONS EQULIBRIUM 
  model.params = {sigma,rho,kappa,lx,beta,rnstst};  
  [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit,hinit); 

% HOMOTOPY
for rho = []      
  vare    = stdrn^2*(1-rho^2);    % variance of the innovation
  [e,w]   = qnwnorm(3,0,vare);    % (number of grid points; mean; variance)
  model.e = e;                   
  model.w = w;  
  model.params = {sigma,rho,kappa,lx,beta,rnstst};  
  xinit = reshape(xx,nn,3);
  hinit = reshape(p,nn,2);
  [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit,hinit); 
end
  
%%
% SIMULATE LIQUIDITY TRAP
  init = -3/4;  % initial state (exog.)
  nper = 40;
  [ssim,xxsim] = simultrap(model,init,nper,scoord,xx);
  
  pi_sim = 4*(squeeze(xxsim(:,1,:)));
  x_sim  = 4*(squeeze(xxsim(:,2,:)));
  i_sim  = 4*(squeeze(xxsim(:,3,:)));
  rn_sim = 4*(squeeze(ssim(:,1,:)));
  
% PLOT SIMULATED LIQUIDITY TRAP
  plot_paths