#! /usr/bin/env python
'''Getmodule_HDL.py

author	: daviscao
date	: 20160425
version	: v2.6.6 or higher'''

import re
import sys
import os

def getmodule_innetlist(module,netlist_f):
    net_f      = open(netlist_f,'r')
    net_module = open(module+'.module.v','w')
    write_flag = 0

    while True:
	netline = net_f.readline()
	if len(netline) == 0:
	    continue

	if re.match('\s*module\s+'+module+'\s*\(',netline):
	    write_flag = 2
	elif re.match('\s*endmodule\s*',netline) and write_flag == 2:
	    write_flag = 1
	elif write_flag == 1:
	    write_flag = 0
	    break

	if write_flag:
	    net_module.write(netline)
    net_f.close()
    net_module.close()

if __name__ == '__main__':
    module = 'S3VDV'
    netlist = '/project/chx001/usr/daviscao_fv/snps/FV_FSO/net/S3VDV.vlg'
    getmodule_innetlist(module,netlist)

