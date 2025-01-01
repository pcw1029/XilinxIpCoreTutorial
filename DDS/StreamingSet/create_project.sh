rm -rf project_*
if [ -f Scripts/project_DDS_StreamingSet.tcl ]; then
	echo " "
	echo "##### CREATE ${D} PROJECT START #####"
	vivado -mode batch -source Scripts/project_DDS_StreamingSet.tcl
	echo "##### CREATE ${D} PROJECT DONE #####"
fi
