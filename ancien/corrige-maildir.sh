#!/bin/sh

#
# corrige-maildir.sh
#
# Ce script parcourt les fichiers de l'arborescence du répertoire courant et
# pour ceux qui commencent par
#   >From
# il supprime le premier caractère ('>')
# Le script ignore les fichiers dont le nom se termine par .cmeta, .index ou
# .data
# 
# Pourquoi ce script ?
#   Pour passer du client de messagerie Evolution à Thunderbird, j'ai effectué
#   la manipulation suivante :
#
#   I) Récupération des données d'Evolution
#     I.1) Archivage de la boîte aux lettres évolution avec le menu
#        Fichier | Archiver les données d'Evolution...
#        Cela produit un fichier de nom evolution-backup-aaaammjj.tar.gz
#     I.2) Extraction du fichier d'archivage
#     I.3) Conversion du répertoire extrait depuis l'archive
#          .local/share/evolution/mail/local
#          au format mbox avec le script maildir2mbox.py, disponible
#          ici : https://gist.github.com/1709069
#   II) Import dans Thunderbird
#     II.1) Installation du module complémentaire ImportExportTools
#     II.2) Import des données converties au format MBox avec le menu
#           Outils | Importer / Exporter au format .MBox | Importer un fichier
#           MBox
#           Puis sélection de l'action
#           Importer un ou plusieurs fichiers MBox, avec le(s) sous-dossier(s)
#           associé(s)
#   
# Cette méthode fonctionne bien sauf que certains emails sont affichés sans
# méta données - l'émetteur apparaît dans la liste comme "MAILER-DAEMON", il
# n'y a aucune information de destinataire, date, sujet, etc., et le contenu
# est affiché sous forme de texte plan sans aucune structure.
# Après quelques essais j'ai trouvé que la cause est la présence du caractère
# '>' précédant From au début d'un email.
# Le script enlève ce caractère, les emails corrigés peuvent alors être
# importés correctement, avec leurs méta données (en-têtes et structure de
# l'email.)
#
# Ce script doit être exécuté entre les étapes I.2 et I.3 décrites ci-dessus.
#
# Sébastien Millet, février 2013
#

if [ "$1" = "-h" -o "$1" = "-v" ]; then
  echo "corrige-maildir.sh v1.0"
  echo "Parcourt l'arborescence maildir pour corriger les emails qui s'y trouvent."
  echo "Copyright Sébastien Millet 2013"
  exit
elif [ -n "$1" ]; then
  echo "Option non reconnue."
  exit
fi

find . -type f ! -regex ".*\(\.cmeta\|\.index\|\.data\).*" | while read f; do
  R=`head -n 1 "$f" | egrep -i "^>From\s"`
  if [ -n "$R" ]; then
    sed -i '1s/^>//' "$f"
    echo "Modifié '$f'"
  fi
done

