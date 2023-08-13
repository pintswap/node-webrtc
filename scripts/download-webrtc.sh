#!/bin/bash

alias python='python2.7'

set -e

set -v

WRTC_TMPDIR=$(dirname $0)/tmp
rm -rf $WRTC_TMPDIR
mkdir $WRTC_TMPDIR
ln -s $(which python2.7) $WRTC_TMPDIR/python
PATH=$WRTC_TMPDIR:$PATH

export PATH=$DEPOT_TOOLS:$PATH

UPDATE_DEPOT_TOOLS_PATH=$(dirname $0)/../build/external/depot_tools/src/update_depot_tools
echo '#!/bin/bash' | tee $UPDATE_DEPOT_TOOLS_PATH
echo "echo \"skipping update\"" | tee -a $UPDATE_DEPOT_TOOLS_PATH
chmod +x $UPDATE_DEPOT_TOOLS_PATH
gclient config --unmanaged --spec 'solutions=[{"name":"src","url":"https://webrtc.googlesource.com/src.git"}]'

gclient sync --shallow --no-history --nohooks --with_branch_heads -r ${WEBRTC_REVISION} -R

python src/tools/clang/scripts/update.py

rm -f webrtc

ln -s src webrtc
