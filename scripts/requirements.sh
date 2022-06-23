#dnsmaq
brew install dnsmasq

## Chose your local domain, or use the following: cluster.localnet
## Be careful not to use TLD that is actually a real TLD.
cat <<EOF | sudo tee -a /usr/local/etc/dnsmasq.conf
address=/cluster.localnet/192.168.1.4
server=8.8.8.8
server=8.8.4.4
EOF

cat <<EOF | sudo tee /etc/resolver/cluster.localnet
domain cluster.localnet
search cluster.localnet
nameserver 192.168.1.4
EOF

sudo brew services start dnsmasq