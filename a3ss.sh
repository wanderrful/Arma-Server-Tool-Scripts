# SYNTAX:
#   a3ss -m mod1 mod2 mod3



# associative array for getting workshop mod ID numbers
declare -A ModDict

# simple array of integers.  assigned only if mods are loaded!
GivenMods=""

# local server path to mods
ServerRootFolder="/home/arma3/arma3/"
ModFolder="steamapps/workshop/content/107410/"

# simple boolean integer flags
declare -i mFlag
declare -i errorFlag



# declare the supported mods
ModDict[cba]=450814997      #cba_a3
ModDict[stui]=498740884     #shacktac user interface
ModDict[tfr]=620019431      #task force radio
ModDict[enh]=333310405      #enhanced movement
ModDict[ifa3]=660460283     #IFA3 LITE (ww2 mod)
ModDict[cup_tc]=583496184   #Cup Terrains - Core



# figure out which mods to load
while getopts 'm:' OPTION
do
    case $OPTION in
	m) mFlag=1
	   ;;	
    esac
done

shift



# parse the given flags and arguments
if [ "$mFlag" ]
then
    for MOD in $*
    do
	echo "> loading ${MOD}..."
	mod_workshop_id="${ModDict[${MOD}]}"
	path_to_mod_folder="${ModFolder}${mod_workshop_id}"
	full_path_to_mod_folder="${ServerRootFolder}${path_to_mod_folder}"
	#echo "DEBUG: full_path_to_mod_folder=${full_path_to_mod_folder}"

	# verify that the mod is listed in the ModDict at the top of this file
	if grep -qe "${MOD}" <(echo "${!ModDict[@]}")
	then
	    # verify that the mod folder we're about to try and load actually exists
	    if [ -d "$full_path_to_mod_folder" ]
	    then 
		GivenMods="${GivenMods}${path_to_mod_folder};"
		#echo "*** ${MOD} loaded!"
	    else
		echo "*** ERROR: FolderNotFound (${MOD}) ... maybe steamcmd didn't download it properly?"
		errorFlag=1
	    fi
	else
	    echo "*** ERROR: KeyNotFound (${MOD}) ... (you'll need to update the ModDict at the top of this file)"
	    errorFlag=1
	fi
    done

    #echo "*** DEBUG: -mods=\"${GivenMods}\""
else
    echo "*** SYNTAX: a3ss -m mod1 mod2 mod3 ..."
    errorFlag=1
fi



if [ "$errorFlag" ]
then
    exit 1
else
    if [ "$(id -u)" == "1001" ]
    then
	echo "*** Server is now starting!"
	# INSERT START SERVER COMMAND WITH LAUNCH PARAMS HERE!

	cd $ServerRootFolder
	./arma3server -port=2302 -cfg=serverconfig/basic.cfg -config=serverconfig/server.cfg -name=server -random=public_ranking.txt -mod="${GivenMods}" -world=Empty -loadMissionToMemory -netLog -filePatching -noBenchmark -noSound -cpuCount=4 -exThreads=7 1>>"/home/arma3/arma3/rpt/server_$(date +%s).rpt" 2>>"/home/arma3/arma3/rpt/server_$(date +%s).rpt"
    else
	echo "*** ERROR: server only starts for the 'arma3' user!"
	exit 1
    fi
fi



exit 0
