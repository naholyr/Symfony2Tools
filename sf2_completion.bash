_sf2_completion()
{
	local cur opts cmds cmdopts console i tmp cmd

	console=${COMP_WORDS[0]}
	# FIX for Ubuntu:
	if uname -a | grep -i ubuntu > /dev/null; then
		console="php-cgi -q -d register_argc_argv=On $console"
	fi

	cur=${COMP_WORDS[$COMP_CWORD]}

	# Usage: console <options> <command> <command options>
	# Let's find the eventual command, first of COMP_WORDS not led by a dash
	cmd=""
	for i in $(seq $(($COMP_CWORD-1))); do
		tmp=${COMP_WORDS[$i]}
		if [ "${tmp:0:1}" != "-" ]; then
			cmd=$tmp
			break
		fi
	done

	if [ "$cmd" == "" ]; then
		# List commands and basic options
		tmp=""
		cmds="$($console list | grep -Po '^[a-z:\-]+|^  :.+? ' | while read c; do if [ "${c:0:1}" != ":" ]; then tmp=$c; elif [ "$tmp" != "" ]; then echo $tmp$c; fi; done)"
		opts="$($console  --help | grep -Po '^ --.*? \(-.*?\)' | tr ' ()' ' ')"
		COMPREPLY=( $(compgen -W "$cmds $opts" -- "$cur") )
	else
		# List options dedicated to current command
		cmdopts=$($console help $cmd | grep -Po '^ --?.*? ')
		COMPREPLY=( $(compgen -W "$cmdopts" -- "$cur") )
	fi

	COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
}
complete -o default -F _sf2_completion console symfony

