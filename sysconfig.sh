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
SetRootLogin ()
{
echo "==================="
echo "[NORMAL] Replacing sshd_config file"
rm -f /etc/ssh/sshd_config
cp -f $GITPATH/sshd_config /etc/ssh/sshd_config
echo "[NORMAL] Replacing sshd_config file Completed"

echo "==================="
echo "[NORMAL] Restarting sshd service"
  if systemctl restart sshd.service
  then
    echo "[NORMAL] Restarting sshd service Completed"
  else
    echo "[WARNING] Restarting sshd service Failed"
  fi

echo "===================" 
echo "[NORMAL] Setting root password"
echo "$1" | passwd --stdin root
echo "[NORMAL] Setting root password Completed"
}

#### Function 01 : Completed  ####

#### Function 02 : Installing JAVA  ####
InstallJava ()
{
echo "==================="
echo "[NORMAL] Installing Java 1.8....."
  if yum install -y java-1.8*
  then
      echo "[NORMAL] Installing Java 1.8 Completed"
      java -version >> ${LOGFILE}
  else
      echo "[WARNING] Installing Java 1.8 Failed"
      #return ()
  fi
}
#### Function 02 : Installing JAVA completed  ####

#### Function 03 : Jenknings repo configuration & jenkings configuration  ####
InstallJenkins ()
{
echo "===================" 
echo "[NORMAL] Configuring Jenkins repo"
  if wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
  then
    if rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    then
      echo "[NORMAL] Configuring Jenkins repo Completed"
    else
      echo "[WARNING] Jenkins key import Failed"
    fi
  else
    echo "[MAJOR] Configuring Jenkins repo Failed"
    #return ()
  fi
  
  
  if yum install -y jenkins
  then
     echo "[NORMAL] Installing Jenkins Completed"
     JnknPw=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
     
     if sed -i 's/JENKINS_PORT="8080"/JENKINS_PORT="8081"/g' /etc/sysconfig/jenkins
     then 
      echo "[INFO] Jenkins port changed!!! New port : 8081"
     else
      echo "[WARNING] Jenkins port changed Failed. Current port : 8080"
     fi
     
     if systemctl enable jenkins && systemctl start jenkins
     then
      echo "[NORMAL] Jenkins Service Status check Started"
      systemctl status jenkins
      echo "[NORMAL] Jenkins Service Status check Completed"
      echo "[INFO] Jenkins initial password : ${JnknPw}"
     else
      echo "[WARNING] Jenkins server start Failed"
      #return ()
     fi
     
  else
     echo "[WARNING] Installing Jenkins Failed"  
     #return ()
  fi
}
#### Function 03 : Completed ####

SetRootLogin $RTPW
InstallJava
InstallJenkins

echo "======================================================"
echo "==== System configuration sysconfig.sh completed ====="  
echo "======================================================"
exit 0
