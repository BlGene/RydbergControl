function S_MSE = gaussobj(x,S_struct)
% 
F_cost_tol = gauss(x,[num2str(S_struct.iter),'_de']);

%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost_tol;