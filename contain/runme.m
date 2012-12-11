%% RUNME Evaluate large-scale optimization algorithms
% RUNME runs optimization (parameter minimization) on two different test
% functions using 9 different algorithms

% algorithms: 
%   fminsearch (matlab)
%   fmincon    (matlab)
%   patternsearch (matlab- optimization toolbox)
%   genetic algorithm (matlab- optimization toolbox)
%   simulated annealing (matlab- optimization toolbox)
%   differential evolution (http://www1.icsi.berkeley.edu/~storn/code.html)
%   particle swarm (Clerc and Kennedy 2002)
%   Local Unimodal Sampling (LUS) Pedersen 2010
%   Covariance Matrix Adaptation Evolution Strategy CMA-ES

% test function 1
%   Michalewicz function. Variable dimensional test function for unconstrained optimization.
%   has n! local optima

% test function 2
%   Randomized Gaussian function. Variable dimensional test function for unconstrained optimization
%   has a single (global) optimum. includes two parameters a, b which
%   introduce random amplitude and parameter/position noise to the fitness
%   function. Tests noise robustness

% First tests indicate that particle swarm optimization (PSO) outperforms
% other algorithms in both speed and robustness. Additionally it allows for
% initial positions to be specified which can significantly speed up
% convergence if an estimate of good parameters is known.
%
%
%
%%
currdir=pwd;
path(path,currdir);
path(path,[currdir,filesep,'de']);path(path,[currdir,filesep,'PSO']);
path(path,[currdir,filesep,'SwarmOps']);

iterations=50;  % how many iterations to perform of each algorithm
n = 4           % number of dimensions
evals = 1200;   % max function evaluations
testfun=2;      % testfun=1 :Michalewicz function
                % testfun=2 :Randomized Gaussian function
dirname='n4_iter50';                
mkdir(dirname);
chdir(dirname);

%%

for k=1:iterations

% clear any pre-existing datafiles

if testfun==1, filename1=['mich',num2str(n),'_',num2str(k),'_*','.dat']; delete(filename1); end
if testfun==2, filename2=['gauss',num2str(n),'_',num2str(k),'_*','.dat']; delete(filename2); end

lb=0*ones(n,1);ub=pi*ones(n,1);
s=pi*rand(n,1);                     % initial guess is uniformly distributed in a hypercube of length pi

% Set options for various algorithms
options=optimset('display','iter','TolFun',0,'TolX',0,'MaxFunEvals',evals);
psoptions=psoptimset('display','iter','TolFun',0,'TolX',0,'MaxFunEvals',evals);
saoptions=psoptimset('display','iter','TolFun',0,'TolX',0,'MaxFunEvals',evals);
gaoptions=gaoptimset('display','iter','PopInitRange',[0;pi],'PopulationSize',10*n,'Generations',ceil(evals/10/n),'TolFun',0);
S_struct=struct('FVr_minbound',lb', 'FVr_maxbound',ub', 'I_D', n, 'I_NP',10*n, ...
    'F_weight',0.8, 'F_CR',1, 'I_bnd_constr',0, 'I_itermax',ceil(evals/10/n), 'F_VTR', -inf, ...
    'I_strategy', 3, 'I_refresh',10, 'I_plotting',0,'iter',k);
swarmoptions=PSOSET('MAX_FUN_EVALS',ceil(evals/12),'display','iter','SWARM_SIZE',10,'tolx',0,'tolfun',0);
lusoptions=struct('Dim',numel(s),'AcceptableFitness',-inf,'MaxEvaluations',evals,'LowerInit',zeros(size(s))','UpperInit',pi*ones(size(s))','gamma',3.0);
cmaesoptions=struct('LBounds',zeros(size(s)),'UBounds',pi*ones(size(s)),'MaxFunEvals',1200,'SaveVariables','off','LogModulo',0);

if testfun==1
    pout=fminsearch(@(x) mich(x,[num2str(k),'_fminsearch']),s,options);
    pout=fmincon(@(x) mich(x,[num2str(k),'_fmincon']),s,[],[],[],[],lb,ub,[],options);
    pout=patternsearch(@(x) mich(x,[num2str(k),'_patternsearch']),s,[],[],[],[],lb,ub,[],psoptions);
    pout=ga(@(x) mich(x,[num2str(k),'_ga']),numel(s),[],[],[],[],lb,ub,[],[],gaoptions);
    pout=simulannealbnd(@(x) mich(x,[num2str(k),'_simulannealbnd']),s,lb,ub,saoptions);
    pout=PSO('mich',s,lb,ub,swarmoptions,[num2str(k),'_swarm']);
    pout=lus('mich',lb,ub,lusoptions,[num2str(k),'_lus']);
    pout=deopt('michobj',S_struct);
    pout=cmaes('mich',s,[],cmaesoptions,[num2str(k),'_cmaes']);
end
if testfun==2
    pout=fminsearch(@(x) gauss(x,[num2str(k),'_fminsearch']),s,options);
    pout=fmincon(@(x) gauss(x,[num2str(k),'_fmincon']),s,[],[],[],[],lb,ub,[],options);
    pout=patternsearch(@(x) gauss(x,[num2str(k),'_patternsearch']),s,[],[],[],[],lb,ub,[],psoptions);
    pout=ga(@(x) gauss(x,[num2str(k),'_ga']),numel(s),[],[],[],[],lb,ub,[],[],gaoptions);
    pout=simulannealbnd(@(x) gauss(x,[num2str(k),'_simulannealbnd']),s,lb,ub,saoptions);
    pout=PSO('gauss',s,lb,ub,swarmoptions,[num2str(k),'_swarm']);
    pout=lus('gauss',lb,ub,lusoptions,[num2str(k),'_lus']);
    pout=deopt('gaussobj',S_struct);
    pout=cmaes('gauss',s,[],cmaesoptions,[num2str(k),'_cmaes']);
end

end

%% Plot results
clear fopt fval data fileslist
for k=1:iterations

    if testfun==1,filename=['mich',num2str(n),'_',num2str(k),'_*','.dat'];end
    if testfun==2,filename=['gauss',num2str(n),'_',num2str(k),'_*','.dat'];end
    
    files=dir(filename);

    for j=1:numel(files)
        data{k,j}=dlmread(files(j).name);
        fval{k,j}=data{k,j}(:,1);
        fopt{k,j}=fbest(fval{k,j}); fopt{k,j}(end:evals+10)=min(fopt{k,j});
        fileslist{j}=files(j).name;
    end

end

    subplot(4,1,[3,4])
colors=hsv(numel(files));
for j=1:numel(files);
    foptavg{j}=mean(cell2mat(fopt(:,j)));
    semilogx(foptavg{j},'color',colors(j,:),'linewidth',1);hold on;

end
set(gca,'xlim',[1,evals]);
h=legend(fileslist,'Location','SouthWest');
set(h, 'Interpreter', 'none','fontsize',8)
ylabel('function value');
xlabel('function evaluations');


    subplot(4,1,[1,2]);
    for k=1:iterations
for j=1:numel(files)
    
     semilogx(fopt{k,j},'color',colors(j,:),'linewidth',1);hold on;
    end
end
set(gca,'xlim',[1,evals],'xticklabel',[]);
ylabel('function value');

if testfun==1,title('Michalewicz function');end
if testfun==2,title('Gauss function with noise');end

set(gcf,'paperunits','centimeters');
set(gcf,'paperposition',[0,0,2*7,2*12]);
if testfun==1,print -depsc2 mich.eps;end
if testfun==2,print -depsc2 gauss.eps;end

chdir(currdir);
