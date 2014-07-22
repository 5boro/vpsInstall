passwd
apt-get update
apt-get upgrade -y
apt-get install fail2ban -y
echo "nom d'utilisateur :"
read user
useradd $user
passwd $user
mkdir /home/$user
mkdir /home/$user/.ssh
chmod 700 /home/$user/.ssh
test=0
while [ $test = 0 ]
do
  echo "clee ssh :"
  read key
  echo $key >> /home/$user/.ssh/authorized_keys
  echo "........................................."
  cat /home/$user/.ssh/authorized_keys
  echo "........................................."
  echo "ok(0=non)"
  read test
done
chmod 400 /home/$user/.ssh/authorized_keys
chown $user:$user /home/$user -R
echo "........................................."
echo "Commenter les lignes existantes et coller ceci a la place :"
echo "root    ALL=(ALL) ALL"
echo "$user  ALL=(ALL) ALL"
echo "........................................."
read ok
visudo
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
service ssh restart
apt-get install unattended-upgrades -y
echo "APT::Periodic::Update-Package-Lists "1";" >> /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::Download-Upgradeable-Packages "1";" >> /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::AutocleanInterval "7";" >> /etc/apt/apt.conf.d/10periodic
echo "APT::Periodic::Unattended-Upgrade "1";" >> /etc/apt/apt.conf.d/10periodic
apt-get install logwatch -y
echo "email pour logwatch"
read mail
echo "/usr/sbin/logwatch --output mail --mailto $mail --detail high" >> /etc/cron.weekly/00logwatch
