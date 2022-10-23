touch ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys

ssh-copy-id -p 22 salt@galaxy.digitastuces.com 

cat ~/.ssh/id_rsa.pub | ssh username@galaxy.digitastuces.com "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

