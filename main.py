from subprocess import Popen, PIPE

process = Popen(['ps', '-eo' ,'pid,args'], stdout=PIPE, stderr=PIPE)
stdout, notused = process.communicate()
for line in stdout.splitlines():
    # pid, cmdline = line.split(' ', 1)
    print(line)