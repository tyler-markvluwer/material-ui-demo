rm -rf roulette/www
rm -rf www
broccoli build www
mv www roulette/
cd roulette
cordova run android
cd ..