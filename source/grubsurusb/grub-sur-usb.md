Title: GRUB sur usb
Date: 2017-12-10
Authors: Sébastien Millet
Category: TI

Cette adresse était très utile :

[https://www.pendrivelinux.com/boot-multiple-iso-from-usb-via-grub2-using-linux](https://www.pendrivelinux.com/boot-multiple-iso-from-usb-via-grub2-using-linux)

------

1. Repartionner la clé USB, en y créant une partition *Linux* (type '83' dans la
   table des partitions).

2. Rendre la partition amorçable (fdisk : commande 'a')

3. Exemple avec fdisk, pour une clé de 4 GO vierge sur `/dev/sdb` :

```
# fdisk /dev/sdb
[...]
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-8058879, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-8058879, default 8058879): 

Created a new partition 1 of type 'Linux' and of size 3.9 GiB.

Command (m for help): a
Selected partition 1
The bootable flag on partition 1 is enabled now.

Command (m for help): p
Disk /dev/sdb: 3.9 GiB, 4126146560 bytes, 8058880 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xafcd074d

Device     Boot Start     End Sectors  Size Id Type
/dev/sdb1  *     2048 8058879 8056832  3.9G 83 Linux

Command (m for help):
```

4. Formatter le volume en ext2. Exemple pour notre clé :

```
mkfs.ext2 -L USBGRUB /dev/sdb1
```

**Note**

    L'URL donnée en haut fait formatter le volume en VFAT (type 'c' dans la
    table des partitions), cela fonctionne aussi. Je préfère ext2.

5. Monter le volume. Exemple :

```
mkdir /mnt/usbgrub
mount /dev/sdb1 /mnt/usbgrub
```

6. Exécuter la commande

```
grub-install --boot-directory=/mnt/usbgrub/boot /dev/sdb
```

7. La clé contient grub et peut démarrer un PC.

------

**Démarrage**

Le point délicat est de trouver le numéro de disque et le numéro de partition. A
priori, le disque principal du PC porte le numéro 1. Dans mon cas, la partition
Linux étant la numéro 3 (Linux démarre sur `/dev/sda3`), le volume de démarrage
pour Linux est `(hd1,3)`.

Et le volume de démarrage pour Windows, qui démarre sur mon PC depuis la
partition `/dev/sda1`, est `(hd1,1)`.

8. Démarrer Windows depuis la clé

À l'invite de grub, exécuter :

```
set root=(hd1,1)
chainloader +1
boot
```

9. Démarrer Linux depuis la clé

* **Important**

Une fois que `root` a été défini à la bonne valeur, il est possible d'utiliser
la touche de tabulation pour compléter automatiquement les noms de fichier.

* **Exemple pour une disbution Ubuntu 17.10 à jour**

À l'invite de grub, exécuter :

```
set root=(hd1,3)
linux /boot/vmlinuz-4.13.0-17-generic ro root=/dev/sda3
initrd /boot/initrd.img-4.13.0-17-generic
boot
```

