from operator import mul,add
from random import Random,gauss
from math import exp,pi
import time
import os
import csv
import math

import matplotlib
matplotlib.use('Qt4Agg')

import inspyred

import numpy
import pylab


#global options, that are the same for all algorithms
param_dim = 3
max_evals = 1200
repeats = 1

def probWrap(inFkt):
    
    def fkt(*args,**kwargs):
        print args,kwargs
        return inFkt(*args,**kwargs)
    
    return fkt


class GaussNoise:
    def __init__(self,dim):
        self.lower_bound = 0.0
        self.upper_bound = pi
        self.param_dim = dim
        self.maximize = True
        self.bounder = inspyred.ec.Bounder(self.lower_bound,self.upper_bound)
    
    def evaluator(self,candidates, args):
        w = .25
        a = 0.2
        b = 0.2
        fitness = []
        for cs in candidates:
            #print 'x>',cs
            sl = [exp(-0.5*( (x-gauss(pi/2,a))/w )**2) for x in cs]
            #print sl
            fit = reduce(mul,sl)
            fit = fit*gauss(1,1)
            #print fit
            fitness.append(fit)
        return fitness
    
    
    def generator(self,random,args):
        return [random.uniform(self.lower_bound,self.upper_bound) for i in range(param_dim)]
        

def run(algo='DEA',prng=None, display=False):
    if prng is None:
        prng = Random()
        prng.seed(time.time()) 
    
    #problem = inspyred.benchmarks.Griewank(param_dim)
    problem = GaussNoise(param_dim)
    
    print 'Running:',algo,['minimizing','maximising'][int(problem.maximize)]
    
    kwargs = {
        'generator': problem.generator, 
        'evaluator': problem.evaluator,   
        'bounder': problem.bounder,
        'maximize': problem.maximize,
        'max_evaluations': max_evals,
        'pop_size ': param_dim*10,
        'num_elites':1,
        }
        

    
    if algo == 'DEA':
        ea = inspyred.ec.DEA(prng)
        evolove_algo_args = {
                        #the number of individuals to be selected (default 2)
                        'num_selected':param_dim*10,
                        #the tournament size (default 2)
                        #tournament_size = param_dim*10,
                        #the rate at which crossover is performed (default 1.0)
                        #crossover_rate = 0.8,
                        #the rate at which mutation is performed (default 0.1)
                        #mutation_rate = 0.1,
                        #the mean used in the Gaussian function (default 0)
                        #gaussian_mean = 0,
                        #the standard deviation used in the Gaussian function (default 1)
                        #gaussian_stdev = 1
                        }
                        
    elif algo == 'PSO':
        ea = inspyred.swarm.PSO(prng)
        ea.topology = inspyred.swarm.topologies.star_topology
        evolove_algo_args = {'neighborhood_size':15,'cognitive_rate':4.0}

    
    ea.terminator = inspyred.ec.terminators.evaluation_termination
    ea.observer = inspyred.ec.observers.file_observer
        
    kwargs.update(evolove_algo_args)
    
    startset = set(os.listdir('.'))
    final_pop = ea.evolve(**kwargs)   
    endset = set(os.listdir('.'))
    
    for fname in list(endset.difference(startset)):
        if(fname[:25] == "inspyred-statistics-file-"):
            inspyred.ec.analysis.generation_plot(fname)
        
        os.remove(fname)            
    
    if display:
        best = max(final_pop)
        print('Best Solution: {0}'.format(str(best)))
    return ea


if __name__ == '__main__':
    algo = 'PSO'
    for i in range(repeats):
        run(algo=algo,display=True)
        
        
