# https://askubuntu.com/a/159338/89663
#!/usr/bin/env bash

# Make sure that all text is parsed in the same language
export LC_MESSAGES=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LANG=en_US.utf8
export LANGUAGE=en_US:en
export LC_CTYPE=en_US.UTF-8

# Calculate how much memory and swap is free
free_data="$(free)"
mem_data="$(echo "$free_data" | grep 'Mem:')"
free_mem="$(echo "$mem_data" | awk '{print $4}')"
buffers="$(echo "$mem_data" | awk '{print $6}')"
cache="$(echo "$mem_data" | awk '{print $7}')"
total_free=$((free_mem + buffers + cache))
used_swap="$(echo "$free_data" | grep 'Swap:' | awk '{print $3}')"

echo -e "Free memory:\t$total_free kB ($((total_free / 1024)) MB)\nUsed swap:\t$used_swap kB ($((used_swap / 1024)) MB)"

# Do the work
if [ $used_swap -eq 0 ]; then
    echo "Congratulations! No swap is in use."
elif [ $used_swap -lt $total_free ]; then
    echo "Freeing swap..."
    swapoff -a
    swapon -a
else
    echo "Not enough free memory. Exiting."
    exit 1
fi
