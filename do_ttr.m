% TRUNCATED TAYLOR RULE 
% (C) Anton Nakov 

% MODEL PARAMETERS 
  beta    = 1/1.005;                % quarterly time discount factor 
  sigma   = 3;                         % relative risk aversion 
  kappa   = 0.024;                     % slope of the Phillips curve 
  elb     = 0/4;                   % effective lower bound  
  
% EXOGENOUS SHOCK PROCESS 
  rnstst  = 100*(1/beta-1);            % steady-state (quarterly x 100)  
  stdrn   = 0.5;                       % standard deviation 
  rho     = 0.65;                      % persistence
  vare    = stdrn^2*(1-rho^2);         % variance of the innovations

% DECLARE MODEL FUNCTION
  model.func = 'func_ttr'; 
  
% DEFINE APPROXIMATION SPACE
  n      = 101;                        % number of grid points
  smin   = -2/4;                       % minimum states (quarterly x 100)
  smax   = +4/4;                       % maximum states (quarterly x 100)
  fspace = fundefn('lin',n,smin,smax); % function space
  scoord = funnode(fspace);            % state collocation grid coordinates
  snodes = gridmake(scoord);           % state collocation grid points
  
% SET OPTIONS 
  optset('remsolve','nres',1);
  optset('arbit','lcpmethod','minmax');
  
% INITIALIZE
  nn    = length(snodes);
  xinit = zeros(nn,2);   
  hinit = zeros(nn,2);
  
% GAUSSIAN QUADRATURE 
  [e,w]   = qnwnorm(3,0,vare);    
  model.e = e;                          % shocks
  model.w = w;                          % probabilities
  
% SOLVE RATIONAL EXPECTATIONS EQULIBRIUM 
  model.params = {sigma,rho,kappa,beta,rnstst,elb};  
  [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit,hinit);   
  
% HOMOTOPY
for rho = [];
  vare    = stdrn^2*(1-rho^2);         % variance of the innovation
  [e,w]   = qnwnorm(3,0,vare);         % GAUSSIAN QUADRATURE 
  model.e = e;                         % shocks
  model.w = w;                         % probabilities
  model.params = {sigma,rho,kappa,beta,rnstst,elb};  
  xinit = reshape(xx,nn,2);
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
  i_sim  = taylor(4*rnstst, pi_sim, x_sim,4*elb); 
  rn_sim = 4*(squeeze(ssim(:,1,:)));

% PLOT SIMULATED LIQUIDITY TRAP
  plot_paths