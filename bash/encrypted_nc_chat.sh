# client:
read -p "Enter Key:" key; read -p "Server address: " server; while true; do read -n30 ui; echo $ui |openssl enc -aes-256-cbc -a -k $key; done | nc $server 8877 | while read so; do decoded_so=`echo "$so"| openssl enc -d -a -aes-256-cbc -k $key`; echo ">>> $decoded_so"; done

# server:
read -p "Enter Key: " key; while true; do read -n30 ui; echo $ui |openssl enc -aes-256-cbc -a -k $key; done | nc -l 8877 | while read so; do decoded_so=`echo "$so"| openssl enc -d -a -aes-256-cbc -k $key`; echo ">>> $decoded_so"; done
