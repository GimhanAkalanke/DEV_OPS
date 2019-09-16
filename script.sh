#!/bin/bash
echo "DEV_OPS_Trainng Log"  > /var/log/DEV_OPS_training.log
echo "==================="  >> /var/log/DEV_OPS_training.log

echo "Installing GIT....."  >> /var/log/DEV_OPS_training.log
yum install -y git
echo "GIT Install Completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "Making env for repository"  >> /var/log/DEV_OPS_training.log
mkdir /opt/DEV_OPS
cd /opt/DEV_OPS
echo "env setup completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "GIT repo config"  >> /var/log/DEV_OPS_training.log
git config --global user.name "GimhanAkalanke"
git config --global user.email myinbox.gm@gmail.com
git init
git remote add origin https://github.com/GimhanAkalanke/DEV_OPS.git
echo "GIT repo config completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "Getting sshd config"  >> /var/log/DEV_OPS_training.log
git pull https://GimhanAkalanke:Vcs_1234@github.com/GimhanAkalanke/DEV_OPS.git master
echo "sshd config downloaded"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "changing sshd config"  >> /var/log/DEV_OPS_training.log
rm -rf /etc/ssh/sshd_config
cp -rf /opt/DEV_OPS/sshd_config /etc/ssh/sshd_config
echo "changing sshd config completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "Restarting sshd service"  >> /var/log/DEV_OPS_training.log
systemctl restart sshd.service
echo "Restarting sshd service completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "Setting root passwd"  >> /var/log/DEV_OPS_training.log
echo "vcs@1234" | passwd --stdin root
echo "root passwd setting completed"  >> /var/log/DEV_OPS_training.log

echo "==================="  >> /var/log/DEV_OPS_training.log
echo "===END OF SR======="  >> /var/log/DEV_OPS_training.log
