'''
walk through the path and get all dir path and file path
'''

import os
path = os.getcwd()

#get all dir and all file under path
for root,dirlist,filelist in os.walk(path):
    print root
    print dirlist
    print filelist

    if len(dirlist):
	for dir in dirlist:
	    print root+os.sep+dir  #return all dir path
    if len(filelist):
	for file in filelist:
	    print root+os.sep+file #return all file path
