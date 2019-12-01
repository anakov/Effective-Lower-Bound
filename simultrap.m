% Monte Carlo simulation of discrete time controlled Markov process
% Modified by Anton Nakov (2005)

% INPUTS
%   model   : model structure variable
%   ss      : k by d vector of initial states
%   nper    : number of simulated time periods
%   sres    : coordinates of the evaluation grid (from dpsolve)
%   xres    : optimal control function values 
%               at grid defined by sres
% OUTPUTS
%   ssim    : k by d by nper+1 vector of simulated states       
%   xsim    : k by d by nper+1 vector of simulated actions
% For finite horizon problems, xsim is k by d by nper
% If d=1, ssim and xsim are k by nper+1
%
% USES: DISCRAND

% Copyright (c) 1997-2002, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu


function [ssim,xsim] = simultrap(model,ss,nper,sres,xres)

  func = model.func;
  params = model.params;

  nrep = size(ss,1);
  ds   = size(ss,2);
  st   = gridmake(sres);

  dx = ds*length(xres(:))/length(st(:));

  ssim = zeros(nrep,ds,nper+1);  
  xsim = zeros(nrep,dx,nper+1);  

  nx = numel(xres)/dx;
  xres = reshape(xres,nx,dx);
  
  for t=1:nper+1
      xx = minterp(sres,xres,ss);
      ssim(:,:,t) = ss;      
      xsim(:,:,t) = xx;
      ee = 0;
      ss = feval(func,'g',ss,xx,[],ee,params{:});
  end 
 
 if ds==1; ssim=squeeze(ssim); end 
 if dx==1; xsim=squeeze(xsim); end