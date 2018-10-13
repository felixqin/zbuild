

listmenu_text()
{
	echo "========================" >&2
	echo $1 >&2
	INDEX=0
	while read ITEM; do
		if [ x"${ITEM}" != x"" ]; then
			((INDEX++))
			echo "  ${INDEX}. ${ITEM}" >&2
			eval "CONTENT_${INDEX}=\"${ITEM}\""
		fi
	done
	echo "------------------------" >&2
	echo -n "Please select: " >&2
	exec < /dev/tty; read SELECT
	eval "echo \${CONTENT_${SELECT}}"
	echo "------------------------" >&2
}

listmenu_dialog()
{
	DLG_CMD="dialog --output-fd 1 --title \"$1\" --no-items --menu \"Please Select:\" $2 $3 $4 "
	while read ITEM; do
		if [ x"${ITEM}" != x"" ]; then
			DLG_CMD="${DLG_CMD} \"${ITEM}\""
		fi
	done
	#echo "DLG_CMD=${DLG_CMD}" >&2
	eval ${DLG_CMD}
}


DIALOG=`which dialog`
if [ x"$DIALOG" = x"" ]; then
	listmenu_text "$1" "$2"
else
	listmenu_dialog "$1" "$2" "$3" "$4"
fi
