export CRS_HOME=/opt/oracle/grid/11.2.0.2

RSC_KEY=$1
QSTAT=-u
AWK=/usr/bin/awk # if not available use /usr/xpg4/bin/awk

# Table header:echo ""

$AWK \
'BEGIN {printf "%-30s %-18s %-70s\n", "HA Resource", "Target", "State";
printf "%-30s %-18s %-70s\n", "-----------", "------", "-----";}'

# Table body:
$CRS_HOME/bin/crsctl status resource | $AWK \
'BEGIN { FS="="; state = 0; }
$1~/NAME/ && $2~/'$RSC_KEY'/ {appname = $2; state=1};
state == 0 {next;}
$1~/STATE/ && state == 2 {appstate = $2; state=3;}
$1~/TARGET/ && state == 1 {apptarget = $2; state=2;}
state == 3 {printf "%-30s %-18s %-70s\n", appname, apptarget, appstate; state=0;}'
echo ""
