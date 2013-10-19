# convert all args to base 64
# use:
# kyle@Host:~$ ./b16.sh 34 88 234234234 0
# 22 58 df6217a 0 


for i in $@; do
printf '%x' $i
echo -n " "
done
echo -e "\n"
