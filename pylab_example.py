import matplotlib
matplotlib.use('Qt4Agg')

import numpy
import pylab

t = numpy.arange(0.0, 1.0+0.01, 0.01)
s = numpy.cos(2*2*numpy.pi*t)
pylab.plot(t, s)

pylab.xlabel('time (s)')
pylab.ylabel('voltage (mV)')
pylab.title('About as simple as it gets, folks')
pylab.grid(True)
#pylab.savefig('simple_plot')

pylab.show()

for i in range(100):
    print i
