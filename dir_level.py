'''
list hierachy of the path
'''
import os
def dirlevel(level,path):
  for dir in os.listdir(path):
    print('|  '*(level+1)+dir)
    if os.path.isdir(path+dir):
      dirlevel(level+1, path+dir)

path = os.getcwd()
dirlevel(0,path+os.sep)
