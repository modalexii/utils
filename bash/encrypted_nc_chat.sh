# client:
read -p "Enter Key:" key; read -p "Server address: " server; while true; do read -n30 ui; echo $ui |openssl enc -aes-256-cbc -a -k $key; done | nc $server 8877 | while read so; do decoded_so=`echo "$so"| openssl enc -d -a -aes-256-cbc -k $key`; echo ">>> $decoded_so"; done

# server:
read -p "Enter Key: " key; while true; do read -n30 ui; echo $ui |openssl enc -aes-256-cbc -a -k $key; done | nc -l 8877 | while read so; do decoded_so=`echo "$so"| openssl enc -d -a -aes-256-cbc -k $key`; echo ">>> $decoded_so"; done

# tweet-size version
# this is *even more* of a novelty and has many more quirks
# server expects password as first line, client expects password + space + server host

# client"
read k s;while true;do read u;openssl enc -a -bf -k $k<<<$u;done|nc $s 2|while read e;do d=`openssl enc -a -d -bf -k $k<<<$e`;echo \>$d;done

# server:
read k;while true;do read u;openssl enc -a -bf -k $k<<<$u;done|nc -l 2|while read e;do d=`openssl enc -a -d -bf -k $k<<<$e`;echo \>$d;done
