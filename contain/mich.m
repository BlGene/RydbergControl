function y = mich(x,algorithm)
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

m = 10;
s = 0;
n = length(x);
for i = 1:n;
    s = s+sin(x(i))*(sin(i*x(i)^2/pi))^(2*m);
end
y = -s;

filename=['mich',num2str(numel(x)),'_',algorithm,'.dat'];
dlmwrite(filename, [y,x(:)'],'delimiter',',','precision',6,'-append');