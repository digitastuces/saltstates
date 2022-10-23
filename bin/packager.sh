#!/bin/bash

# Package saltstates and saltconfig from git master branch
# Useful for disconnected customers
#
# Generates an archive in /tmp/pkgr_out
#
# BUGS:
#   - when you have a file *${OPNAME}* in your current directory, salt archive is missing files

set -e

OPNAME=$1
[ -z $OPNAME ] && { 
	echo "Usage: packager.sh <opcode>"
	exit 255
}

# files generic exclusion and inclusion
SALTSTATES_EXCLUDE="Capfile .git* .kitchen* README.md CHANGELOG.md Gemfile* Jenkinsfile [dD]ocker* log bin config doc packer test tmp vendor lib ott sys ch tc misc testcalls clearinghouse openldap mongodb sb-dashboard tycoon dante redsocks"
SALTCONFIG_EXCLUDE="auth.yml"

# saltstates specific files removal
SALTSTATES_SPEC_RM="pillar/stack/fraudbuster/whitelists.yml pillar/stack/fraudbuster/passwords/postfix.yml pillar/stack/env/sb/passwords.yml"

# saltconfig generic inclusion
SALTCONFIG_INCLUDE="simbuster_user.py *${OPNAME}* stack.cfg credentials"

# output directory
TMP_DIR=`mktemp -d`
OUT_DIR='/tmp/pkgr_out'
DATE=$(date +%Y%m%d%H%M)
OUT_BASE_FILENAME=salt-${OPNAME}-${DATE}

mkdir -p ${OUT_DIR}

SALTSTATES_GIT=ssh://git@gitlab.fb.int:2230/team-system/saltstates
SALTCONFIG_GIT=ssh://git@gitlab.fb.int:2230/team-system/saltconfig

SALTSTATES_DIR=${TMP_DIR}/saltstates/${DATE}
SALTCONFIG_DIR=${TMP_DIR}/saltconfig/${DATE}

[ ! -d $SALTCONFIG_DIR ] && mkdir -p $SALTCONFIG_DIR
git clone $SALTCONFIG_GIT $SALTCONFIG_DIR
[ ! -d $SALTSTATES_DIR ] && mkdir -p $SALTSTATES_DIR
git clone $SALTSTATES_GIT $SALTSTATES_DIR

# installing open source formulas
cd ${SALTSTATES_DIR} && ./bin/install_formulas.sh

# removing specific files
echo
echo "removing specific files from saltstates"
for file in $SALTSTATES_SPEC_RM
do
	echo "rm -rf ${SALTSTATES_DIR}/${file}"
	rm -rf ${SALTSTATES_DIR}/${file}
done

# KLUDGE Move from saltconfig to saltstates
mv -v ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/users.yml ${SALTSTATES_DIR}/pillar/stack/fraudbuster/
mv -v ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/fb-cert.yml ${SALTSTATES_DIR}/pillar/stack/private/
mv -v ${SALTCONFIG_DIR}/pillar/stack/hosts/sb/_${OPNAME}/whitelists.yml ${SALTSTATES_DIR}/pillar/stack/fraudbuster/

find ${SALTSTATES_DIR}/pillar/files/ssh_keys -type f -and -not -name 'simbuster*' -and -not -name nagios.pub -delete

# copy simbuster pub ssh key
cp $SALTSTATES_DIR/pillar/files/ssh_keys/simbuster.pub $SALTSTATES_DIR/pillar/files/ssh_keys/fb1.pub
cp $SALTSTATES_DIR/pillar/files/ssh_keys/simbuster.pub $SALTSTATES_DIR/pillar/files/ssh_keys/fb2.pub
cp $SALTSTATES_DIR/pillar/files/ssh_keys/simbuster.pub $SALTSTATES_DIR/pillar/files/ssh_keys/fb3.pub
cp $SALTSTATES_DIR/pillar/files/ssh_keys/simbuster.pub $SALTSTATES_DIR/pillar/files/ssh_keys/backupretrieve.pub

# excluding files from saltstates
echo
echo "excluding files from saltstates"
for pattern in $SALTSTATES_EXCLUDE
do
	find $SALTSTATES_DIR -name $pattern | xargs rm -rf
done

# excluding files from saltconfig
echo
echo "excluding files from saltconfig"
for pattern in $SALTCONFIG_EXCLUDE
do
	find $SALTCONFIG_DIR -name $pattern | xargs rm -rf
done

# creating archive
tar -cf ${OUT_DIR}/${OUT_BASE_FILENAME}.tar -C ${TMP_DIR} saltstates

for pattern in $SALTCONFIG_INCLUDE
do
	find $SALTCONFIG_DIR -name $pattern -printf '%P\n' |xargs -I'{}' tar -rvf ${OUT_DIR}/${OUT_BASE_FILENAME}.tar -C ${TMP_DIR} saltconfig/${DATE}/{}
done
gzip ${OUT_DIR}/${OUT_BASE_FILENAME}.tar

# removing temporary files
rm -fr ${TMP_DIR}

# print archive filename
echo
echo "## Packaged archive for ${OPNAME} is stored at ${OUT_DIR}/${OUT_BASE_FILENAME}.tar.gz ##"

exit 0

