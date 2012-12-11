function S_MSE = michobj(x,S_struct)
% 
% Michalewicz function 
% Variable dimensional test function for unconstrained optimization.

% Michalewicz, Z.: Genetic Algorithms + Data Structures = Evolution Programs. Berlin, Heidelberg, New York: Springer-Verlag, 1992.
%
% The Michalewicz function is a multimodal test function (owns n! local optima).
% The parameter m deﬁnes the “steepness” of the valleys or edges. Larger
% m leads to more difﬁcult search. For very large
% m the function behaves like a needle in
% the haystack (the function values for points in the space outside the narrow peaks
% give very little information on the location of the global optimum). 
% m is usually set to 10. Test area is usually restricted to a hypercube
% 0<=xy=pi. The global minimum for n=5 f=-4.687 and for n=10 f=-9.66

F_cost_tol = mich(x,[num2str(S_struct.iter),'_de']);

%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost_tol;