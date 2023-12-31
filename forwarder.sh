read -p 'Enter Main Server IP: ' IP
echo "Your Main Server IP is: $IP"
sudo apt  install iptables iptables-persistent
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 2280 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 2280 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9011 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 9011 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -p tcp --match multiport --dports  80,443,8443,2082,2083,2053,2095,8080 -j MASQUERADE 
sudo iptables -t nat -A PREROUTING -p tcp --match multiport --dports  80,443,8443,2082,2083,2053,2095,8080 -j DNAT --to-destination $IP
sudo iptables -t nat -A POSTROUTING -p udp -j MASQUERADE 
sudo iptables -t nat -A PREROUTING -p udp -j DNAT --to-destination $IP

sudo mkdir -p /etc/iptables/ 
sudo iptables-save | sudo tee /etc/iptables/rules.v4
