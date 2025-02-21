# As usual old tests

## First way to run startup:
```
# clone this repo:
git clone https://github.com/navajogit/vm_lin
cd vm_lin

# allow to execute
chmod +x startup
clear

# run 
./startup

```

## Seccond way to run startup with installing it to system scripts (sudo):

```
# clone this repo:
git clone https://github.com/navajogit/vm_lin
sudo mv vm_lin/startup /usr/local/bin/
rm -rf vm_lin/

# Allow execution:
sudo chmod +x /usr/local/bin/startup
clear

# Run the startup script:
startup

```
