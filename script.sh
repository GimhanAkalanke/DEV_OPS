#!/bin/bash

LOGFILE="/var/log/DEV_OPS_training.log"

echo "DEV_OPS_Trainng Log"  > ${LOGFILE}
echo "==================="  >> ${LOGFILE}

echo "Installing GIT....."  >> ${LOGFILE}
  if yum install -y git
  then
      echo "[NORMAL] GIT Install Completed"  >> ${LOGFILE}
      git -version >> ${LOGFILE}
  else
      echo "[WARNING] GIT Installation Failed" >> ${LOGFILE}
  fi

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Making ENV for GIT repository"  >> ${LOGFILE}
mkdir /opt/DEV_OPS
cd /opt/DEV_OPS
echo "[NORMAL] Making ENV for GIT repository Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] GIT repository configuration"  >> ${LOGFILE}
git config --global user.name "GimhanAkalanke"
git config --global user.email myinbox.gm@gmail.com
git init
git remote add origin https://github.com/GimhanAkalanke/DEV_OPS.git
echo "[NORMAL] GIT repository configuration Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Pulling sshd_config file"  >> ${LOGFILE}
git pull https://GimhanAkalanke:Vcs_1234@github.com/GimhanAkalanke/DEV_OPS.git master
echo "[NORMAL] Pulling sshd_config file Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Replacing sshd_config file"  >> ${LOGFILE}
rm -rf /etc/ssh/sshd_config
cp -rf /opt/DEV_OPS/sshd_config /etc/ssh/sshd_config
echo "[NORMAL] Replacing sshd_config file Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Restarting sshd service"  >> ${LOGFILE}
  if systemctl restart sshd.service
  then
    echo "[NORMAL] Restarting sshd service Completed"  >> ${LOGFILE}
  else
    echo "[WARNING] Restarting sshd service Failed"  >> ${LOGFILE}
  fi

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Setting root password"  >> ${LOGFILE}
echo "vcs@1234" | passwd --stdin root
echo "[NORMAL] Setting root password Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "===END OF SR======="  >> ${LOGFILE}
exit 0
