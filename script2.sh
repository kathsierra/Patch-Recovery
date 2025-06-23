#!/bin/bash

set -e  # Arrêter le script dès qu'une commande échoue

mkdir -p unpack
cd unpack

echo "📦 Unpacking recovery.img..."
../magiskboot unpack ../recovery.img || { echo "❌ Échec du unpack"; exit 1; }

echo "📂 Extraction du ramdisk..."
../magiskboot cpio ramdisk.cpio extract || { echo "❌ Échec de l'extraction du ramdisk"; exit 1; }

echo "🛠️ Application des hexpatches..."
for patch in \
  "e10313aaf40300aa6ecc009420010034 e10313aaf40300aa6ecc0094" \
  "eec3009420010034 eec3009420010035" \
  "3ad3009420010034 3ad3009420010035" \
  "50c0009420010034 50c0009420010035" \
  "080109aae80000b4 080109aae80000b5" \
  "20f0a6ef38b1681c 20f0a6ef38b9681c" \
  "23f03aed38b1681c 23f03aed38b9681c" \
  "20f09eef38b1681c 20f09eef38b9681c" \
  "26f0ceec30b1681c 26f0ceec30b9681c" \
  "24f0fcee30b1681c 24f0fcee30b9681c" \
  "27f02eeb30b1681c 27f02eeb30b9681c" \
  "b4f082ee28b1701c b4f082ee28b970c1" \
  "9ef0f4ec28b1701c 9ef0f4ec28b9701c" \
  "9ef00ced28b1701c 9ef00ced28b9701c" \
  "2001597ae0000054 2001597ae1000054" \
  "24f0f2ea30b1681c 24f0f2ea30b9681c" \
  "41010054a0020012f44f48a9 4101005420008052f44f48a9"
do
  ../magiskboot hexpatch system/bin/recovery $patch
done

echo "📦 Réinjection du fichier patché dans le ramdisk..."
../magiskboot cpio ramdisk.cpio 'add 0755 system/bin/recovery system/bin/recovery'

echo "🧱 Repacking de l’image modifiée..."
../magiskboot repack ../recovery.img new-boot.img || { echo "❌ Échec du repack"; exit 1; }

if [ ! -f new-boot.img ]; then
  echo "❌ Fichier new-boot.img manquant"
  exit 1
fi

echo "📁 Copie finale : new-boot.img → ../recovery-patched.img"
cp new-boot.img ../recovery-patched.img
