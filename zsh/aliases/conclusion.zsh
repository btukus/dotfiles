# alias nsproxy='sshpass -p "BfNUWi3N8UMvFXruyLhmuW8V" ssh -f -N -q ns-m-ssh001.tux.m.ns.lan'
alias nsproxy='sshpass -p $CMC_PASSWORD ssh -f -N -q ns-m-ssh001.tux.m.ns.lan'
alias nscheck='ps aux | grep "ssh -f -N -q ns-m-ssh001.tux.m.ns.lan"'
alias enproxy='sshpass -p $ENECO_PASSWORD ssh -D 1080 -f -N -q eneco-m-ssh001.tux.m.eneco.lan'
