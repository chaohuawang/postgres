echo 'standby_mode = "on"' > ./data/standby.signal
sed -i 's/^port/#port/' ./data/postgresql.conf
echo "Please restart docker-compose...."
