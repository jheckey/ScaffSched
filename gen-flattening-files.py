import math
import argparse

def genFlattenModules(benchName):

    fn = benchName+'.out'
    print '====Processing',benchName
    f = open(fn,'r')
    r = f.read().split('\n')
    f.close()

    l = filter(lambda x: (len(x)>1), r)
    #print l

    m = map(lambda x: x.replace(':',''), l)
    m = map(lambda x: x.split(), m)
    #print m
    
    vals = map(lambda x: int(x[1]), m)
    #print vals 

    numVals = len(vals)
    print 'Total Num of Functions = ',numVals

    '''
    names = ['001k','005k','010k','050k','100k','150k','1M','2M','8M','20M']
    buckets = [(0,1000),(1000,5000),(5000,10000),(10000,50000),(50000,100000),
               (100000,150000),(150000,1000000),(1000000,2000000),
               (2000000,8000000),(8000000,20000000)]
    '''
    names = ['2M']
    buckets = [(1000000,2000000)]

    numBuckets = len(buckets)
    
    histVals = []

    for i in range(numBuckets):
        n = filter(lambda x: (int(x[1])>=buckets[i][0]) and (int(x[1])<buckets[i][1]), m)
        histVals.append(len(n))

    sumFunc = 0
    for i in range(numBuckets):
        print buckets[i][0],'-',buckets[i][1],' : ',histVals[i]
        sumFunc = sumFunc+histVals[i]

    print '>',buckets[-1][1] ,': ', numVals - sumFunc

    for i in range(numBuckets):
        can1k = filter(lambda x: (int(x[1])>=0) and (int(x[1])<buckets[i][1]), m)
        n1k = map(lambda x: x[0], can1k)
        fn = benchName+'_inline'+names[i]+'.txt'
    
        fout = open(fn,'w')
    
        for e in n1k:
            fout.write(e)
            fout.write('\n')

        fout.close()

    

parser = argparse.ArgumentParser(description='Generate flattened module list for this benchmark')

parser.add_argument("input")

args = parser.parse_args()

genFlattenModules(args.input)

