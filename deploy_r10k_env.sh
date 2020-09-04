#!/bin/bash
# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

TMP_DIR=/tmp/$(basename ${0})
LOG_FILE=${TMP_DIR}/$(basename ${0}).log
R10K_ENV_DIR=/etc/puppetlabs/code/environments/

# ------------------------------------------------------------------------------
# Fonctions
# ------------------------------------------------------------------------------

function on_error {
  echo -e "\033[91m[!] $@\033[0m"
  exit 1
}

function notify {
  echo -e "\033[96m[+] $@\033[0m"
}

function on_warning {
  echo -e "\033[93m[?] $@\033[0m"
}

function item {
  echo -e "\033[95m '-> $@\033[0m"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

notify "Création du répertoire temporaire ${TMP_DIR}" 
mkdir -p ${TMP_DIR}
RET_VAL=$?
if [ ! ${RET_VAL} -eq 0 ]; then
  on_error "Erreur lors de la création du répertoire temporaire" >> ${LOG_FILE}
fi

notify "Purge du répertoire temporaire ${TMP_DIR}" >> ${LOG_FILE}
rm -Rf ${TMP_DIR}/*
RET_VAL=$?
if [ ! ${RET_VAL} -eq 0 ]; then
  on_error "Erreur lors de la purge" >> ${LOG_FILE}
fi

notify "Sauvegarde des environnements dans ${TMP_DIR}" >> ${LOG_FILE}
find ${R10K_ENV_DIR} -maxdepth 1 -type d \( -not -name "production" -and -not -name "$(basename ${R10K_ENV_DIR})" \) -exec cp -R {} ${TMP_DIR} \;
if [ ! ${RET_VAL} -eq 0 ]; then
  on_error "Erreur lors de la copie des environnements" >> ${LOG_FILE}
fi

notify "Déploiement de l'environnement 'production'" >> ${LOG_FILE}
/usr/local/bin/r10k deploy environment production -pv
if [ ! ${RET_VAL} -eq 0 ]; then
  on_error "Erreur lors du déploiement" >> ${LOG_FILE}
fi

notify "Restauration des environnements depuis ${TMP_DIR}" >> ${LOG_FILE}
find ${TMP_DIR} -maxdepth 1 -type d -type d \( -not -name "production" -and -not -name "$(basename ${TMP_DIR})" \) -exec cp -R {} ${R10K_ENV_DIR} \;
if [ ! ${RET_VAL} -eq 0 ]; then
  on_error "Erreur lors de la copie des environnements" >> ${LOG_FILE}
fi
notify "Fin(0)" >> ${LOG_FILE}
