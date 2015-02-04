#!/bin/bash
########### INFOS ###########
# Author : Sébastien HUBER

# Log version
# 2015 : new release for omg 1.9 and new seafile version 4
#  2013/09 :
#    V.1.0-00 :   430 lignes qui fonctionnent
#    V.1.0-01 :   Amélioration de l'affichage des "echo" au client
#          Création de 'fonction' afin d'améliorer la clareté du script          
#          Diminution des pauses 'sleep' afin de réduire la durée du script
#          Augmentation du nombres de boucle 'if' notamment pour les téléchargements, afin d'améliorer les messages d'erreurs au client
#   V.1.0-02 :    Traduction du script en anglais uniquement à partir de maintenant
#   V.1.0-03 :    Monter en version 2 de seafile
#   V.1.0-04 :    Modification du script, erreur 64 récurrente à cause du nom du fichier 86_64 | Merci à Ionel

# Bug connus :
#      Aucun pour le moment

### Variables ###
scriptversion="1.0-04"
msgsarretscript="Faites CTRL+C pour arrêter le script - Do CTRL+C for stopping the script"
msgcongrats="All is fine, congrats!\n\n"
msgerrors1="Errors, ideas ? --> www.download-tutos.com <--"
ARCH=$(uname -m)
questionip="n"
ADRESSEIP="inconnue"
ADRESSEIP=$(netstat -ie | sed -n 's/^.*inet adr:\([0-9]*.\)\.\([0-9]*.\)\.\([0-9]*.\)\.\([0-9]*.\).*$/\1.\2.\3.\4/p')
adresseipchoiceuser="inconnue"
questioninstallpaquet="n"
INSTALLDIR="/opt/seafile"
questioninstalldir="n"
askuser="n"


set -u # dont let any variable without a value

############### FUNCTIONS ###############

# Function - Message : do CTRL+C for leaving the script
make_ctrl_c() {
  echo ""
  echo "Do CTRL+C for leaving the script"
}

# Function - message : header
msg_header() {
  clear
  echo "##################################################"
  echo "################## OMV Seafile ###################"
  echo "################  Version $scriptversion #################"
  echo "##################################################"
  echo "\n"
}

# Function - Message : Do you want to continue ?
msg_askuser() {
  askuser="no"
  while [ "$askuser" != "y" ] 
  do
    echo "This step requires action on your part." 
    echo "Would you like to continue?"
    echo -n "Enter [y] then press [ENTER] to continue:  "
    sleep 1
    read askuser
  done
}

# Function - Message : unknow (not listed in a function) error
msg_bug_report() {
  clear
  while [ "1" != "o" ] 
  do
    echo "\n"
    echo "##################################################"
    echo "####################  ERROR  #####################"
    echo "############# Please report this bug #############"
    echo "########### at www.download-tutos.com ############"
    echo "##################################################"
    echo "\n"
    make_ctrl_c
    sleep 25
    clear
  done
}

# Function - Message : unrecognized architecture machine for this script
msg_error_arch() {
  clear
  while [ "1" != "o" ] 
  do
    echo "####################  ERROR  ####################"
    echo "########### unrecognized architecture ###########"
    echo "\n"
    echo "Bug report : ARCH Error $ARCH"
    msg_bug_report
    sleep 30
    clear
  done
}

# Function - Message : Warning differents files and packages will be deleted
msg_uninstall_packages() {
  clear
  msg_header
  echo ""
    echo "............................................"
    echo "      Differents files will be deleted      "
    echo "             during this process            "
    echo "............................................"
  echo ""
  echo "WARNING : Some files and packages will be deleted"
  echo "\n"
}

# Function - Error: File (s) not downloaded (s)
error_download() {
  clear
  while [ "1" != "o" ] 
  do
    echo "_____________________________________________________"
    echo ""
    echo ""
    echo "ERROR: The files cannot be downloaded"
    echo "files for $ARCH"
    echo ""
    echo "______________________________________________________"
    echo "\n"
    msg_bug_report
    make_ctrl_c
    sleep 25
    clear
  done
}

# Function - Error : the file cannot be downloaded
error_download_setup_seafile() {
  clear
  while [ "1" != "o" ] 
  do
    echo "_____________________________________________________"
    echo ""
    echo ""
    echo "ERROR: The files cannot be downloaded"
    echo "Files for setup-seafile"
    echo ""
    echo "______________________________________________________"
    echo "\n"
    msg_bug_report
    make_ctrl_c
    sleep 25
    clear
  done
}

# Function - Delete: clean old files that may have been installed by a previous installation
delete_old_install() {
  rm /etc/init.d/seafile
  rm /etc/init.d/seahub
  rm -fvr /tmp/script/omv-seafile
  rm -fvr /opt/seafile
  mkdir /opt/seafile
  cd $INSTALLDIR
}

# Function - Download : seafile 32 bits
download_32_1() {
  cd /tmp/script/omv-seafile
  clear
  msg_header
  echo ""
    echo "............................................"
    echo "  The architecture 32 bits has been chosen  "
    echo "       Download and unpack the files        "
    echo "............................................"
    echo ""
  wget www.dl.hubtek.fr/data/public/9dda9d.php?dl=true
  if [ -e 9dda9d.php?dl=true ]
    then
         mv 9dda9d.php?dl=true seafile-serveur-i386.tar.gz
      tar -xzf seafile-serveur-i386.tar.gz
      mkdir archived
      mv seafile-serveur-i386.tar.gz archived/
      mv seafile-server-2.0.1 seafile-server
    else
      error_download
  fi
mv seafile-server /opt/seafile
}

# Function - Download : seafile 64 bits
download_64_1() {
  cd /tmp/script/omv-seafile
  clear
  msg_header
  echo ""
    echo "............................................"
    echo "  The architecture 64 bits has been chosen  "
    echo "       Download and unpack the files        "
    echo "............................................"
    echo ""
    wget www.dl.hubtek.fr/data/public/91d706.php?dl=true
    if [ -e 91d706.php?dl=true ]
      then
        mv d91d706.php?dl=true seafile-serveur-x64.tar.gz
        tar -xzf seafile-serveur-x64.tar.gz
        mkdir archived
        mv seafile-serveur-x64.tar.gz archived/
        mv seafile-server-2.0.1 seafile-server
      else
        error_download
    fi
    mv seafile-server /opt/seafile
}

# Function - Download : setup seafile
download_seafile_script() {
  clear
  msg_header
  echo ""
    echo "..........................................."
    echo "            seafile-setup starting          "
    echo "............................................"
    echo ""
    cd /opt/seafile/seafile-server
  chmod +x setup-seafile.sh
  ./setup-seafile.sh
}

loading_simulation() {
  echo ""
  echo "............................................"
  sleep 1
  echo "............................................"
  sleep 1
  echo ".............. PLEASE WAITING .............."
  sleep 4
  echo "............................................"
  sleep 1
  echo "............................................"
  sleep 1
  echo ""
}

uninstall_package() {
  clear
  msg_header
  echo ""
    echo "............................................"
    echo "          Uninstall some packages           "
    echo "............................................"
    echo ""
loading_simulation
  apt-get -fyqq update
   loading_simulation
  apt-get -fyqq remove python 2.7 python-setuptools python-simplejson python-imaging sqlite3
  loading_simulation
  apt-get -fyqq autoremove
  apt-get -fyqq clean
  echo ""
  loading_simulation
}

install_package() {
  clear
  msg_header
  echo ""
    echo "............................................"
    echo "       Download and install packages        "
    echo "............................................"
    echo ""
    echo ""
  echo "Download and installation in progress ... (1/3)"
  loading_simulation
  apt-get -fyqq install python 2.7 
  loading_simulation
  sleep 5
  loading_simulation
  echo "Download and installation in progress ... (2/3)"
  loading_simulation
  apt-get -fyqq install python-setuptools python-simplejson python-imaging
  loading_simulation 
  loading_simulation
  echo "Download and installation in progress ... (3/3)"
  loading_simulation
  apt-get -fyqq install  sqlite3
  loading_simulation
  apt-get -f clean
  clear
  msg_header
  echo "Done!"
  sleep 5
  clear
}

### Welcome ###

clear
msg_header # 30 secondes de messages  ||| 30 sec of messages
echo "After installation, your machine will automatically restart";
echo "So please make sure that all your services or loans";
echo "to be arrested in a few minutes";

### Delete old folders ###

clear
msg_header
echo "\n"
echo "REMOVING OLD FILES AND RECORDS"
echo ""
echo "WARNING"
echo "AN OLD INSTALLATION SEAFILE THROUGH THIS SCRIPT"
echo "DO NO MORE WORK."
echo "IF YOU STORE YOUR DATA IN /OPT/Seafile"
echo "THEY WILL BE DELETED"
echo "BE SURE TO WANT TO PROCEED"
echo "\n"
msg_askuser
loading_simulation
delete_old_install
sleep 1
clear

### DISPLAY AND RECOGNITION OF THE ARCHITECTURE ###

echo "Checking the architecture of your machine"
loading_simulation
echo "--------------- ARCHITECTURE ---------------"
uname -m 
echo "--------------------------------------------"
sleep 2

case "$ARCH" in
  i386)
    download_32_1
    ;;
  i686)
    download_32_1
    ;;
  x86_64)
    download_64_1
    ;;
  *)
    msg_error_arch
esac



### DELETE AND INSTALL PACKAGES ###

msg_uninstall_packages
msg_askuser
uninstall_package
install_package

### DOWNLOAD AND LAUNCH SEAFILE SEAHUB SCRIPT INSTALLATION ###

download_seafile_script
echo "done!"

# ADD THE AUTOSTART FOR SEAFILE
msg_header
echo "adding seafile on boot service"
sleep 1
echo '#!/bin/sh
### BEGIN INIT INFO
# Provides:    seafile-server
# Required-Start:  $all
# Required-Stop:  $all
# Should-Start:    $local_fs
# Should-Stop:    $local_fs
# Default-Start:  2 3 4 5
# Default-Stop:    0 1 6
### END INIT INFO

# Variables
user=root
seafile_dir=/opt/seafile
script_path=${seafile_dir}/seafile-server
seafile_init_log=${seafile_dir}/logs/seafile.init.log
seahub_init_log=${seafile_dir}/logs/seahub.init.log

# Change the value of fastcgi to true if fastcgi is to be used
fastcgi=false

case "$1" in
        start)
                sudo -u ${user} ${script_path}/seafile.sh start > ${seafile_init_log}
                if [  $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh start-fastcgi > ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh start > ${seahub_init_log}
                fi
        ;;
        restart)
                sudo -u ${user} ${script_path}/seafile.sh restart > ${seafile_init_log}
                if [  $fastcgi = true ];
                then
                        sudo -u ${user} ${script_path}/seahub.sh restart-fastcgi > ${seahub_init_log}
                else
                        sudo -u ${user} ${script_path}/seahub.sh restart > ${seahub_init_log}
                fi
        ;;
        stop)
                sudo -u ${user} ${script_path}/seafile.sh $1 > ${seafile_init_log}
                sudo -u ${user} ${script_path}/seahub.sh $1 > ${seahub_init_log}
        ;;
        *)
                echo "Usage: /etc/init.d/seafile {start|stop|restart}"
                exit 1
        ;;
esac
exit 0' > /etc/init.d/seafile
chmod +x /etc/init.d/seafile
update-rc.d seafile defaults
clear
msg_header
echo "!done"
sleep 2
clear
msg_header
echo "adding seafile on boot service"
sleep 2
echo '#! /bin/sh
### BEGIN INIT INFO
# Provides:          seahub
# Required-Start:    $remote_fs $syslog seafile
# Required-Stop:     $remote_fs $syslog seafile
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Seahub server
# Description:       Private storage solution, web server daemon
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Seafile web server"
NAME=seahub
DAEMON_PATH=/opt/seafile/seafile-server
DAEMON=$DAEMON_PATH/$NAME.sh
#DAEMON_ARGS="--options args"
#PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
  # Return
  #   0 if daemon has been started
  #   1 if daemon could not be started
  $DAEMON start >> $DAEMON_PATH/runtime/daemon.log
}

#
# Function that stops the daemon/service
#
do_stop()
{
  # Return
  #   0 if daemon has been stopped
  #   1 if daemon could not be stopped
  $DAEMON stop >> $DAEMON_PATH/runtime/daemon.log
}

case "$1" in
  start)
  [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
  do_start
  case "$?" in
    0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
    2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
  esac
  ;;
  stop)
  [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
  do_stop
  case "$?" in
    0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
    2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
  esac
  ;;
  restart|force-reload)
  #
  # If the "reload" option is implemented then remove the
  # 'force-reload' alias
  #
  log_daemon_msg "Restarting $DESC" "$NAME"
  do_stop
  case "$?" in
    0|1)
    do_start
    case "$?" in
      0) log_end_msg 0 ;;
      1) log_end_msg 1 ;; # Old process is still running
      *) log_end_msg 1 ;; # Failed to start
    esac
    ;;
    *)
      # Failed to stop
    log_end_msg 1
    ;;
  esac
  ;;
  *)
  #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
  echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
  exit 3
  ;;
esac

:'> /etc/init.d/seahub
chmod +x /etc/init.d/seahub
update-rc.d seahub defaults
clear
msg_header
echo "!done"
sleep 2


### MESSAGE DE FIN ###
clear
msg_header
echo "Thank you for choosing us."
sleep 5
echo "\n"
echo "The machine will restart in 1 minute"
sleep 25
clear
echo "After rebooting"
echo "\n"
echo "Go to the address of your nas on port 8000 to manage Seafile"
echo "\n"
echo "Have fun!"
mkdir /opt/seafile/logs
sleep 30
shutdown 0 -r
