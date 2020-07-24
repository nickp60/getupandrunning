#  Configuring GCP machine

Here's how to make a new GCP dev machine:

- Go to the project's VM instances page
- make a new persistent disk; I make a 1.5Tb one for intermediate files.
- create a new VM, and attach that disk
-

##Installing stuff

Run the `reinstall.sh` script.  `reinstalling.org` is geared for desktop devices (i3, compton, etc)

The configure git
```
git config --global user.email "nickp60@gmail.com"
git config --global user.name "Nick Waters"
git config --global credential.helper cache
mkdir ~/GitHub && cd ~/GitHub
for repo in bioskryb_gcp_architecture bioskryb_docs bioskryb_research skrybutils bioskryb_scripts_and_workflows; do git clone https://github.com/bioskryb/${repo} ; done
```

Here's how to get that big persistent disk working.

```
#########  Big Disk Setup
sudo lsblk  # find attached disk
DISK_ID=sdb
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/${DISK_ID}  # reformat
sudo mkdir -p /mnt/disks/big-disk  # make mount point
sudo mount -o discard,defaults /dev/${DISK_ID} /mnt/disks/big-disk #mount
sudo chmod 777 /mnt/disks/big-disk  # set open permissions; TODO find better defaults

##  get that disk mounted at boot
sudo cp /etc/fstab /etc/fstab.backup
sudo blkid /dev/${DISK_ID}
ID_FROM_BLKID="4d581b61-316f-4263-a2e8-4be1f6ad5e49"  # set as needed
#edit /etc/fstab: add UUID=ID_FROM_BLKID /mnt/disks/big-disk ext4 discard,defaults,nofail 0 2
sudo echo "UUID=${ID_FROM_BLKID} /mnt/disks/big-disk ext4 discard,defaults,nofail 0 2" >> /etc/fstab

```
