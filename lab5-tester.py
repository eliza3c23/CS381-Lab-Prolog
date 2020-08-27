##########################
# CS 381 Project Tester  #
# Project 5              # 
##########################

# run in project root directory 
#    python lab5-tester.py 

import os
import sys
import time
import argparse
from collections import Counter 

# counter
passed=0
failed=0

# convert window line endings 
def convert_line_endings(file_path):
    WINDOWS_LINE_ENDING = b'\r\n'
    UNIX_LINE_ENDING = b'\n'
    with open(file_path, 'rb') as open_file:
        content = open_file.read()
    content = content.replace(WINDOWS_LINE_ENDING, UNIX_LINE_ENDING)
    with open(file_path, 'wb') as open_file:
        open_file.write(content)

def compare(out, myout):
    global passed
    global failed
    #open out and myout files
    with open (out, 'r') as outfile:
        outdata=outfile.readlines()[0]
    with open (myout, 'r') as myoutfile:
        myoutdata=myoutfile.readlines()[0]  
    
    # exact match
    if (outdata==myoutdata):
        print('Passed','\n')
        passed=passed+1
        return
    
    # clean
    outdata=outdata.replace('\n', '').replace('\'', '')
    myoutdata=myoutdata.replace('\n', '').replace('\'', '')
    
    # list case
    if (outdata[0]=='['):
        outdata=outdata.replace('[', '').replace(']', '')
        myoutdata=myoutdata.replace('[', '').replace(']', '')
        outlst = outdata.split(',')
        myoutlst = myoutdata.split(',')  
    
        #difference
        diff = list((Counter(outlst) - Counter(myoutlst)).elements()) 
        
        if (len(diff)==0):
            print('Passed','\n')
            passed=passed+1
            return
        else:
            print('Failed','\n')
            print('---------------------')
            print('File: ' + out)
            print('---------------------')
            print(outlst,'\n')
            print('------------------------')
            print('File: ' + myout)
            print('------------------------')
            print(myoutlst,'\n')
            print('-----------')            
            print('Difference: ')
            print('-----------')            
            print(str(diff),'\n')  
            failed=failed+1            
            return
    # single word case
    else:        
        if (outdata==myoutdata):
            print('Passed','\n')
            passed=passed+1
            return
        else:
            print('Failed','\n')
            print('---------------------')
            print('File: ' + out)
            print('---------------------')
            print(outdata,'\n')
            print('------------------------')
            print('File: ' + myout)
            print('------------------------')
            print(myoutdata,'\n')
            failed=failed+1
            return
        
def main(argv, arc):
    # make directory
    try:
        os.mkdir("./myouts")
    except OSError:
        pass
    try:    
        os.mkdir("./diff")
    except OSError:
        pass
    
    parser = argparse.ArgumentParser(description='CS 381 Lab5 Tester.')
    parser.add_argument(dest="file", nargs='?', help='file to run', default='lab5.pl')
    parser.add_argument('-t', action="store", dest="test", help='the test to run', type=str)
    args = parser.parse_args()    
    file = args.file
    test = args.test
    
    if (test==None):
        # run all tests
        for file_name in sorted(os.listdir('./tests')):
            if file_name.split('.')[1] == 'in':
                # run the script, save test.myout
                os.system('swipl -q ' + file + ' < ./tests/{} > ./myouts/{}.myout'.format(file_name,file_name.split('.')[0]))
                
                # set line endings to unix
                myout_file = './myouts/' + file_name.split('.')[0]+'.myout'
                convert_line_endings(myout_file)
                
                # compare test.out and test.myout
                print("#####################")
                print('Test', file_name.split('.')[0])
                print("---------------------")
                compare('./tests/{}.out'.format(file_name.split('.')[0]), './myouts/{}.myout'.format(file_name.split('.')[0]))
        print('#####################','\n')     
        print('You passed {} out of {} tests.'.format(passed, (passed+failed)), '\n')
        print('#####################')         
    else:
        # run one test
        os.system('swipl -q ' + file + ' < ./tests/{}.in > ./myouts/{}.myout'.format(test,test))
                
        # set line endings to unix
        myout_file = './myouts/' + test +'.myout'
        convert_line_endings(myout_file)
        
        # compare test.out and test.myout
        print("#####################")
        print('Test', test)
        print("---------------------")
        compare('./tests/{}.out'.format(test), './myouts/{}.myout'.format(test))
        
if __name__ == "__main__":
    # execute only if run as a script
    main(sys.argv, len(sys.argv))