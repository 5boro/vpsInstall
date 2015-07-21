echo "Changement du mot de passe"
passwd
apt-get update
apt-get upgrade -y
apt-get install fail2ban -y
echo "Nom d'utilisateur à ajouter:"
read user
useradd -D $user
passwd $user
mkdir /home/$user
mkdir /home/$user/.ssh
chmod 700 /home/$user/.ssh
test=0
while [ $test = 0 ]
do
  echo "Coller la clee ssh puis enter:"
  read key
  echo $key >> /home/$user/.ssh/authorized_keys
  echo "........................................."
  cat /home/$user/.ssh/authorized_keys
  echo "........................................."
  echo "ok?(0=non)"
  read test
done
chmod 400 /home/$user/.ssh/authorized_keys
chown $user:$user /home/$user -R
echo ".........................................
Ajouter '$user   ALL=(ALL) ALL' sous 'root    ALL=(ALL) ALL'
(fonctionnement de vi: 'i' pour editer 'echap : wq' pour enregistrer et quitter)
........................................."
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
echo "'daily' pour un rapport journalier, 'weekly' hebdomadaire ou 'monthly' mensuel (sans '')"
read frequence
echo "#!/bin/bash
test -x /usr/share/logwatch/scripts/logwatch.pl || exit 0
/usr/sbin/logwatch --output mail --mailto $mail --detail high" > /etc/cron.$frequence/00logwatch
