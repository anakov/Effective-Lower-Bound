% CONSTANT PRICE LEVEL TARGETING RULE 
% (C) Anton Nakov 

% MODEL PARAMETERS (quarterly frequency)
  beta    = 1/1.005;                   % quarterly time discount factor 
  sigma   = 2;                         % relative risk aversion 
  kappa   = 0.024;                     % slope of the Phillips curve 
  lx      = 0.003;                     % inflation weight in loss f-n
  
% EXOGENOUS SHOCK PROCESS (natural real interest rate)  
  rnstst  = 100*(1/beta-1);       % steady-state 
  stdrn   = 0.003;                  % standard deviation 
  rho     = 0.85;                 % persistence
  vare    = stdrn^2*(1-rho^2);    % variance of the innovation

% DECLARE MODEL FUNCTION
  model.func = 'func_cplt'; 

% DEFINE APPROXIMATION SPACE
  n      = [49 49];                       % number of grid points
  smin   = [-2 -0.05]/4;                 % minimum states (quarterly)
  smax   = [+4 +0.05]/4;                 % maximum states (quarterly)
  fspace = fundefn('lin',n,smin,smax);   % function space
  scoord = funnode(fspace);              % state collocation grid coordinates
  snodes = gridmake(scoord);             % state collocation grid points
 
% SET OPTIONS 
  optset('remsolve','nres',1);
  optset('arbit','lcpmethod','minmax');
  
% INITIALIZE
  nn    = length(snodes);
  xinit = [zeros(nn,2) snodes(:,1)];  
  hinit = zeros(nn,2);
  
% GAUSSIAN QUADRATURE 
  [e,w]   = qnwnorm(3,0,vare);    
  model.e = e;                          % shocks
  model.w = w;                          % probabilities
  
% SOLVE RATIONAL EXPECTATIONS EQULIBRIUM 
  model.params = {sigma,rho,kappa,lx,beta,rnstst};
  [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit); 

% HOMOTOPY
  for rho = [0.85];      
    vare    = stdrn^2*(1-rho^2);  % variance of the innovation
    [e,w]   = qnwnorm(3,0,vare);  % (number of grid points; mean; variance)
    model.e = e;                  % shocks
    model.w = w;  
    model.params = {sigma,rho,kappa,lx,beta,rnstst};  
    xinit = reshape(xx,nn,3);
    hinit = reshape(p,nn,2);
    [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit,hinit); 
  end

%%
% SIMULATE LIQUIDITY TRAP

  init = [-2/4 0];  % initial state 
  nper = 40;
  [ssim,xxsim] = simultrap(model,init,nper,scoord,xx);

  pi_sim     = 4*squeeze(xxsim(:,1,:));
  x_sim      = 4*squeeze(xxsim(:,2,:));
  i_sim      = 4*squeeze(xxsim(:,3,:));
  rn_sim     = 4*squeeze(ssim(:,1,:));

% PLOT SIMULATED LIQUIDITY TRAP
  plot_paths