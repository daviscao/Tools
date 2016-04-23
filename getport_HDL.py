#! /usr/bin/env python
'''Getport_HDL.py.

author	: daviscao
date  	: 20160423
version	: v2.6.6 or higher'''
import re
import sys
import os

def getport(hdl_file,porttype):
    if porttype == 'input':
	pattern = re.compile('\s*input\s+')
    elif porttype == 'output':
	pattern = re.compile('\s*output\s+')
    elif porttype == 'inout':
	pattern = re.compile('\s*(input|output)\s+')
    else:
	print "pls select porttype in 'input','output' and 'inout'"
	sys.exit()

    hdl_f = open(hdl_file,'r')
    logic_line_l = list()
    logic_line = ''
    start = False
    for physical_line in hdl_f.readlines():
	physical_line = physical_line.strip() #remove '\n'

	if pattern.match(physical_line):
	    start = True
	if start:
	    logic_line += physical_line
	    if re.search(';$',physical_line):
		start = False
		logic_line_l.append(logic_line)
		print logic_line
		logic_line = ''
    hdl_f.close()
    ####
    print '==========================================='
    print '          Total %s number: %d '%(porttype,len(logic_line_l))
    print '==========================================='

    return logic_line_l


if __name__ == '__main__':
    hdl_file = 'S3VDV.module'

    logic_line_list = getport(hdl_file,'inout')

    print logic_line_list
