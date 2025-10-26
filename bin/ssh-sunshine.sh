#!/bin/bash
set -e

# ssh_args="<user>@192.168.X.X" # Or use alias set in ~/.ssh/config
ssh_args=${1} # Or use alias set in ~/.ssh/config

check_ssh(){
  result=1
  # Note this checks infinitely, you could update this to have a max # of retries
  while [[ $result -ne 0 ]]
  do
echo "checking host..."
    ssh $ssh_args "exit 0" 2>/dev/null
    result=$?
    [[ $result -ne 0 ]] && {
      echo "Failed to ssh to $ssh_args, with exit code $result"
    }
    sleep 3
  done
echo "Host is ready for streaming!"
}

start_stream(){
  echo "Starting sunshine server on host..."
  echo "Start moonlight on your client of choice"
  # -f runs ssh in the background
  ssh -f $ssh_args "~/dotfiles/bin/sunshine.sh &"
}

check_ssh
start_stream
exit_code=${?}

sleep 3
exit ${exit_code}

