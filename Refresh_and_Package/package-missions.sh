#####################
#
#
#  Use this to package all missions in a given folder into the PBO format that Arma likes
#
#
#
#  Note:
#  *  The command 'pboconsole' is simply a symlink in /usr/local/bin to the PBOManager tool, 'PBOConsole.exe'
#
#
#####################



IFS='+' #because of the spaces in the folder pathnames, i need to change this!



MissionFolder='/cygdrive/d/docs/arma 3 - Other Profiles/sixtyfour/missions/'



for mission in $MissionFolder/*
do
	if [ -d $mission ]
	then
	    
	    MissionPath=$(cygpath -w $mission)
	    FileExtension=".pbo"
	    FullPBOPath=$MissionPath$FileExtension

	    echo "Packaging ${mission##*/}"
	    


	    # the 'pboconsole' command is just a symlink to PBOConsole.exe ...
	    # ... which can be found in your PBO Manager root folder
	    pboconsole -pack $MissionPath $FullPBOPath > /dev/null
	fi
done



echo 'Done!'
