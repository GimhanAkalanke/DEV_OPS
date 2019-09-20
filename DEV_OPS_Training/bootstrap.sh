#!/bin/bash



LOGFILE="/var/log/DEV_OPS_training.log"

GITPATH="/opt/DEV_OPS"

GITUSER="GimhanAkalanke"

GITEMAIL="myinbox.gm@gmail.com"

GITPW="Vcs_1234"

GITREPO="https://github.com/GimhanAkalanke/DEV_OPS.git"

#RTPW="vcs@1234"



#####EXIT CODES#####

##100### Changing to a directory failed

##101### Config file download from GIT failed



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

git config --global user.name $GITUSER     ##No harm if failed at this point

git config --global user.email $GITEMAIL   ##No harm if failed at this point

  if git init

  then

    if git remote add origin $GITREPO

    then

      echo "[NORMAL] GIT repository configuration Completed"  >> ${LOGFILE}

    else

      echo "[MAJOR] GIT repository initializing Failed" >> ${LOGFILE}

    fi

  else

    echo "[CRITICAL] GIT repository configuration Failed" >> ${LOGFILE}

  fi





echo "==================="  >> ${LOGFILE}

echo "[NORMAL] Pulling config files"  >> ${LOGFILE}

  if git pull https://$GITUSER:$GITPW@github.com/GimhanAkalanke/DEV_OPS.git master

  then

    echo "[NORMAL] Pulling config files Completed"  >> ${LOGFILE}

  else

    echo "[CRITICAL] Pulling config files Failed.Cannot run further. Exiting....101" >> ${LOGFILE}

    exit 101

  fi



chmod +x $GITPATH/sysconfig.sh



  if $GITPATH/sysconfig.sh

  then

    echo "[NORMAL] System configuration completed successfully" >> ${LOGFILE}

  else

    echo "[WARNING] System configuration failed. Rerun sysconfig.sh or configure manually. GOOD LUCK" >> ${LOGFILE}

  fi