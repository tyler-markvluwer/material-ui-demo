rm -r www
broccoli build www
scp -r www/* pi@192.168.1.3:/home/pi/Documents/projects/rpi-webapp-express
rm -r www