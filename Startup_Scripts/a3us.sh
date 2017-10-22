#!/bin/bash
# WORK IN PROGRESS

# general script to update, validate, and install workshop mods for arma 3 server admins



# Declare the argument flags for this script
declare -i sFlag
declare -i lFlag
declare -i kFlag
declare -i mFlag
declare -i hFlag

# the mod folder in which all mods can be found
ServerRootFolder="/home/arma3/arma3"
ModFolder="${ServerRootFolder}/steamapps/workshop/content/107410"
KeysFolder="${ServerRootFolder}/keys"



# the general idea here is to construct a skeleton steamcmd params.txt
# and then add/remove the pieces we need based on the sFlag and/or mFlag
# after we're done constructing the pieces... we call steamCMD with the
# launch params that we just built!
# (probably will need to create a temporary file and remove it afterward)
# <DEFINE THE SKELETON STUFF HERE I GUESS?>
# after downloading the mods, we need to chmod a+rwx everything in the workshop folder so that there aren't any access issues whilst running the server



while getopts ':smlkh' OPTION
do
    case $OPTION in
	# use steamCMD to update/validate the client
	s) sFlag=1
	   ;;
	# use steamCMD to update/validate the mods
	m) mFlag=1
	   ;;
	# (requires sudo) go through all mods in the mods folder and turn them all to lower case because arma needs it that way to work properly
	l) lFlag=1
	   ;;
	# symlink all of the .bikey files in each of the mods folders into the main server's root keys folder
	k) kFlag=1
	   ;;
	h) hFlag=1
	   ;;
	\?) echo "Invalid option: -$OPTARG" >&2
	    exit 2
	    ;;
    esac
done



# handle the valid arguments
if [ "$hFlag" ]
then
    echo "*** SYNTAX: a3us -flags" >&2
    echo "> -s  use SteamCMD to update/validate the client" >&2
    echo "> -m  use SteamCMD to update/validate the mods" >&2
    echo "> -l  (requires sudo) set each mod folder's contents to all lowercase because Arma needs it that way for Linux stuff" >&2
    echo "> -k  symlink each .bikey file in every mod folder to the main server's root keys folder" >&2

    exit 2
fi

if [ "$sFlag" ]
then
    echo "> NOT YET IMPLEMENTED (-s)" >&2
fi

if [ "$mFlag" ]
then
    echo "> NOT YET IMPLEMENTED (-m)" >&2
fi

if [ "$lFlag" ]
then
    echo "> Making all mod folders and files lowercase..." >&2
    sudo find $ModFolder -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;
fi

if [ "$kFlag" ]
then
    echo "> Symlinking all mod .bikey files to the server's 'keys' folder..." >&2
    ln -sf $ModFolder/*/keys/* $KeysFolder
fi



echo "> Procedure complete!" >&2
exit 0
