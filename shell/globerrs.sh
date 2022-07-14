#***********************************************************************#
#  Script:  config00.sh    Author:  Joe D Funk                          #
#*Script autoreps the entire Autosys job master and creates output file #
#                                                                       #
# Updatede: Neil Komorek                                                #
# Modified to use only local file filesystems                           #
#***********************************************************************#

# Old directory path used NFS mount
# autorep -J ALL -q > /var/nat/prd/int/working/boxes.dat

# New working path
autorep -J ALL -q > /var/autosys/prd/int/working/boxes.dat

