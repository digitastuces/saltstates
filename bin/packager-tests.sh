#!/bin/bash

# Copy saltstates and saltconfig to ${TMP_DIR} in order to patch contents.
# Useful for disconnected customers, this script is a tests focused version of `packager.sh`.
# We don't need tarballs for that purpose.

set -e

OPNAME=$1
[ -z $OPNAME ] && {
	echo "Usage: packager-tests.sh <opcode>"
	exit 255
}

# files generic exclusion and inclusion
SALTSTATES_EXCLUDE="Capfile .git* .kitchen* README.md CHANGELOG.md Gemfile* Jenkinsfile [dD]ocker* log bin config doc packer vendor lib ott sys ch tc misc testcalls clearinghouse openldap mongodb sb-dashboard tycoon dante redsocks"
SALTCONFIG_EXCLUDE="auth.yml"

# saltstates specific files removal (don't remove whitelists atm)
#SALTSTATES_SPEC_RM="pillar/stack/fraudbuster/whitelists.yml pillar/stack/fraudbuster/passwords/postfix.yml pillar/stack/env/sb/passwords.yml"
SALTSTATES_SPEC_RM="pillar/stack/fraudbuster/passwords/postfix.yml pillar/stack/env/sb/passwords.yml"

# saltconfig generic inclusion
SALTCONFIG_INCLUDE="simbuster_user.py *${OPNAME}* stack.cfg credentials"

# output directory
TMP_DIR='./tmp/packager'
RSYNC_CMD='rsync -aq --exclude=tmp/ --exclude=.gitignore --exclude=.git/'
MKDIR_CMD='mkdir -p'

[ -d ${TMP_DIR} ] && rm -rf ${TMP_DIR}
mkdir -p ${TMP_DIR}

SALTSTATES_DIR=${TMP_DIR}/saltstates
SALTCONFIG_DIR=${TMP_DIR}/saltconfig

[ ! -d ${SALTCONFIG_DIR} ] && ${MKDIR_CMD} ${SALTCONFIG_DIR}

# if saltconfig is in the current directory
[ -d ./saltconfig ] && ${RSYNC_CMD} ./saltconfig/ ${SALTCONFIG_DIR}

# if saltconfig is in the parent directory
[ -d ../saltconfig ] && ${RSYNC_CMD} ../saltconfig/ ${SALTCONFIG_DIR}

[ ! -d ${SALTSTATES_DIR} ] && ${MKDIR_CMD} ${SALTSTATES_DIR}
${RSYNC_CMD} ./ ${SALTSTATES_DIR}

# installing open source formulas
cd ${SALTSTATES_DIR} && ./bin/install_formulas.sh

# KLUDGE Move from saltconfig to saltstates
mv -v ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/users.yml ${SALTSTATES_DIR}/pillar/stack/fraudbuster/
mv -v ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/fb-cert.yml ${SALTSTATES_DIR}/pillar/stack/private/

# Please Salt
echo -e "---\nFBConfig:\n  vagrant: true\n  test_mode: true" > ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/vagrant.yml
[ -f ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/apt.yml ] && rm -f ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/apt.yml
sed -i '/    mysqld:/d' ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/${OPNAME}*
sed -i '/      innodb_buffer_pool_size: 128G/d' ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/${OPNAME}*
sed -i 's/firewall: true/firewall: false/' ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/init.yml

pushd ./
cd ${SALTCONFIG_DIR}
[ ! -L ${SALTCONFIG_DIR}/ext_data ] && ln -s ../saltstates/test/fixtures/ext_data/ ./
popd

find ${SALTSTATES_DIR}/pillar/files/ssh_keys -type f -and -not -name 'simbuster*' -and -not -name nagios.pub -and -not -name vagrant.pub -delete

# copy simbuster pub ssh key
cp ${SALTSTATES_DIR}/pillar/files/ssh_keys/simbuster.pub ${SALTSTATES_DIR}/pillar/files/ssh_keys/fb1.pub
cp ${SALTSTATES_DIR}/pillar/files/ssh_keys/simbuster.pub ${SALTSTATES_DIR}/pillar/files/ssh_keys/fb2.pub
cp ${SALTSTATES_DIR}/pillar/files/ssh_keys/simbuster.pub ${SALTSTATES_DIR}/pillar/files/ssh_keys/fb3.pub
cp ${SALTSTATES_DIR}/pillar/files/ssh_keys/simbuster.pub ${SALTSTATES_DIR}/pillar/files/ssh_keys/backupretrieve.pub

# exclude various files from saltstates
echo
echo "excluding files from saltstates"
for pattern in $SALTSTATES_EXCLUDE
do
	find ${SALTSTATES_DIR} -name $pattern | xargs rm -rf
done

# exclude various files from saltconfig
echo
echo "excluding files from saltconfig"
for pattern in $SALTCONFIG_EXCLUDE
do
	find ${SALTCONFIG_DIR} -name $pattern | xargs rm -rf
done

# remove specific files
echo
echo "removing specific files from saltstates"
for file in $SALTSTATES_SPEC_RM
do
	echo "rm -rf ${SALTSTATES_DIR}/${file}"
	rm -rf ${SALTSTATES_DIR}/${file}
done

exit 0

