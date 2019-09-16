#!/bin/bash

LOGFILE="/var/log/DEV_OPS_training.log"
GITPATH="/opt/DEV_OPS"
GITUSER="GimhanAkalanke"
GITEMAIL="myinbox.gm@gmail.com"
GITPW="Vcs_1234"

#####EXIT CODES#####
##100### Changing to a directory failed

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
  if [ ! -d "$GITPATH" ]
  then
      if mkdir -p $GITPATH
      then
        echo "[NORMAL] \"$GITPATH\" directory created" >> ${LOGFILE}
      else
        echo "[MAJOR] \"$GITPATH\" directory create failed" >> ${LOGFILE}
      fi
  else
    echo "[WARNING] \"$GITPATH\" directory already exsists" >> ${LOGFILE}
  fi
  
  if cd $GITPATH
  then
    echo "[NORMAL] Changed to $GITPATH"
  else
    echo "[CRITICAL] Changing to $GITPATH failed.. Exiting..100"
    exit 100
  fi
  
echo "[NORMAL] Making ENV for GIT repository Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] GIT repository configuration"  >> ${LOGFILE}
git config --global user.name $GITUSER
git config --global user.email $GITEMAIL
git init
git remote add origin https://github.com/GimhanAkalanke/DEV_OPS.git
echo "[NORMAL] GIT repository configuration Completed"  >> ${LOGFILE}

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Pulling sshd_config file"  >> ${LOGFILE}
git pull https://$GITUSER:$GITPW@github.com/GimhanAkalanke/DEV_OPS.git master
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
echo "Installing Java 1.8....."  >> ${LOGFILE}
  if yum install -y java-1.8*
  then
      echo "[NORMAL] Installing Java 1.8 Completed"  >> ${LOGFILE}
      java -version >> ${LOGFILE}
  else
      echo "[WARNING] Installing Java 1.8 Failed" >> ${LOGFILE}
  fi

echo "==================="  >> ${LOGFILE}
echo "===END OF SR======="  >> ${LOGFILE}
exit 0
