Script to help create new user. 
========================================================
Script add new user on docker group, and copy authorized_keys from current user or root to new user.  
After getting file change premission:  
`chmod +x add_user.sh`  

How to use:  
`./add_user.sh erigon`  
or  
`sudo ./add_user.sh erigon`  
(in this case new user will get rights to do sudo without password)
