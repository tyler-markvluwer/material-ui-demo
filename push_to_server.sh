rm -r www
broccoli build www
scp -r www/* tylermar@login.engin.umich.edu:/home/tylermar/Public/html
rm -r www