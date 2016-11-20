#!/usr/bin/env bash

################################################################################
### prepare demo ###############################################################
################################################################################

tmuxinator wjax-2016-ethereum-demo

tmux set -g status on
tmux set -g status-style fg=white,bold,bg=green
tmux set -g status-right ""
tmux set -g status-left ""
tmux set -g status-justify centre

docker stop $(docker ps -a -q) ; docker rm $(docker ps -a -q)

rm -rf ethereum/{geth,history}

################################################################################
### drive demo #################################################################
################################################################################

(sleep 3 ; bash video-driver.sh) &

################################################################################
### record #####################################################################
################################################################################

asciinema rec -y \
  -c "tmux attach -t wjax-2016-ethereum-demo" \
  demo.json

################################################################################
### postprocess ################################################################
################################################################################

ASCIICAST=`asciinema upload demo.json`

APICAST=https://asciinema.org/api/asciicasts/${ASCIICAST:24}

asciinema2gif --size small --theme asciinema -o demo.gif ${APICAST}

gifsicle --colors 4 --resize 800x600 --use-colormap gray demo.gif >demo800x600.gif

rm demo.gif demo.json
