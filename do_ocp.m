% OPTIMAL COMMITMENT POLICY WITH ZERO FLOOR ON THE NOMINAL INTEREST RATE
% (C) Anton Nakov 

% MODEL PARAMETERS (quarterly frequency)
  beta    = 1/1.005;                   % quarterly time discount factor 
  sigma   = 2;                         % relative risk aversion 
  kappa   = 0.024;                     % slope of the Phillips curve 
  lx      = 0.003;                     % inflation weight in loss f-n
  
% EXOGENOUS SHOCK PROCESS 
  rnstst  = 100*(1/beta-1);            % steady-state (quarterly x 100)  
  stdrn   = 0.5;                       % standard deviation 
  rho     = 0.65;                      % persistence
  vare    = stdrn^2*(1-rho^2);         % variance of the innovation

% DECLARE MODEL FUNCTION
  model.func = 'func_ocp';  

% DEFINE APPROXIMATION SPACE
  n      = [25     13      5];           % number of grid points
  %smin   = [-2  0.000  -0.03]/4;         % minimum states (quarterly)
  %smax   = [+4 +0.008  +0.01]/4;         % maximum states (quarterly)
  smin   = [-2  0.000  -0.05]/4;         % minimum states (quarterly)
  smax   = [+4 +0.015  +0.05]/4;         % maximum states (quarterly)
  
  fspace = fundefn('lin',n,smin,smax);   % function space
  scoord = funnode(fspace);              % state collocation grid coordinates
  snodes = gridmake(scoord);             % state collocation grid points
 
% SET OPTIONS 
  optset('remsolve','nres',1);
  optset('arbit','lcpmethod','minmax');
   
% INITIALIZE
  nn    = length(snodes);
  xinit = [zeros(nn,2) max(0,snodes(:,1))];  % [inflation; output gap; nominal interest rate]
  hinit = zeros(nn,2);
  
% GAUSSIAN QUADRATURE 
  [e,w]   = qnwnorm(3,0,vare);           % (number of grid points; mean; variance)
  model.e = e;                           % shocks
  model.w = w;                           % probabilities
  
% SOLVE RATIONAL EXPECTATIONS EQULIBRIUM 
  model.params = {sigma,0.35,kappa,lx,beta,rnstst};  
  [c,s,xx,p,f,resid] = remsolve(model,fspace,scoord,xinit,hinit); 

% HOMOTOPY
  for rho = [rho]  
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

% GET ERGODIC DISTRIBUTION OF ENDOGENOUS STATE
  init = [-3/4 0 0];  % initial state (exog. and endogenous)
  nper = 40;
    
  [ssim,xxsim] = simultrap(model,init,nper,scoord,xx);

  pi_sim = 4*(squeeze(xxsim(:,1,:)));
  x_sim  = 4*(squeeze(xxsim(:,2,:)));
  i_sim  = 4*(squeeze(xxsim(:,3,:)));
  rn_sim = 4*(squeeze(ssim(:,1,:)));
  
% PLOT SIMULATED LIQUIDITY TRAP
  plot_paths;
  
% figure(2)
% surf(4*scoord{2},4*scoord{1},squeeze(4*xx(:,:,1,3)))
% xlabel('\lambda')
% ylabel('r^n')
% zlabel('i')
  