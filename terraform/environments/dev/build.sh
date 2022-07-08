cd `dirname $0`
if [ -e "./function.zip" ];then
  trash ./function.zip
fi
zip -r ./function.zip ./src
