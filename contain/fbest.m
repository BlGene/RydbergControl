function [ fbest ] = fbest( fval )
%FBEST Summary of this function goes here
%   Detailed explanation goes here

for j=1:numel(fval);
    fbest(j)=min(fval(1:j));    
end

