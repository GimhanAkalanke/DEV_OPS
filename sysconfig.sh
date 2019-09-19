#!/bin/bash
LOGFILE="/var/log/DEV_OPS_training.log"
GITPATH="/opt/DEV_OPS"
#GITUSER="GimhanAkalanke"
#GITEMAIL="myinbox.gm@gmail.com"
#GITPW="Vcs_1234"
#GITREPO="https://github.com/GimhanAkalanke/DEV_OPS.git"
RTPW="vcs@1234"

#### Please run bootstrap.sh to set env for this script ####

#### Function 01 : Setting PW based Authentication and enabling root  ####

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Replacing sshd_config file"  >> ${LOGFILE}
rm -f /etc/ssh/sshd_config
cp -f $GITPATH/sshd_config /etc/ssh/sshd_config
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
echo "$RTPW" | passwd --stdin root
echo "[NORMAL] Setting root password Completed"  >> ${LOGFILE}

#### Function 01 : Completed  ####

#### Function 02 : Installing JAVA  ####

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Installing Java 1.8....."  >> ${LOGFILE}
  if yum install -y java-1.8*
  then
      echo "[NORMAL] Installing Java 1.8 Completed"  >> ${LOGFILE}
      java -version >> ${LOGFILE}
  else
      echo "[WARNING] Installing Java 1.8 Failed" >> ${LOGFILE}
  fi
  
#### Function 02 : Installing JAVA completed  ####

#### Function 03 : Jenknings repo configuration & jenkings configuration  ####

echo "==================="  >> ${LOGFILE}
echo "[NORMAL] Configuring Jenkins repo"  >> ${LOGFILE}
  if wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
  then
    if rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    then
      echo "[NORMAL] Configuring Jenkins repo Completed"  >> ${LOGFILE}
    else
      echo "[WARNING] Jenkins key import Failed"  >> ${LOGFILE}
    fi
  else
    echo "[MAJOR] Configuring Jenkins repo Failed"  >> ${LOGFILE}
  fi
  
  if yum install -y jenkins
  then
     echo "[NORMAL] Installing Jenkins Completed"  >> ${LOGFILE}
     JnknPw=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
     sed -i 's/JENKINS_PORT="8080"/JENKINS_PORT="80"/g' /etc/sysconfig/jenkins
     systemctl enable jenkins
     systemctl start jenkins
      echo
      {
      =====Jenkins Service Status check Started====
      systemctl status jenkins
      =====Jenkins Service Status check Completed====
      ${JnknPw} - Use this as initial password
      JENKINS_PORT:80
      } >> $LOGFILE  
  else
     echo "[WARNING] Installing Jenkins Failed"  >> ${LOGFILE}
  fi
#### Function 03 : Completed ####

echo "==================="  >> ${LOGFILE}
echo "==== System configuration sysconfig.sh completed ====="  >> ${LOGFILE}
exit 0
