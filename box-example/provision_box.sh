# Static parameters
WORKSPACE=./
BOX_PLAYBOOK=$WORKSPACE/box.yml
BOX_NAME=sixteen
BOX_ADDRESS=3.208.192.250
BOX_USER=ubuntu
BOX_PWD=

prudentia ssh <<EOF
unregister $BOX_NAME

register
$BOX_PLAYBOOK
$BOX_NAME
$BOX_ADDRESS
$BOX_USER
$BOX_PWD

verbose 1
set box_address $BOX_ADDRESS

provision $BOX_NAME
EOF
