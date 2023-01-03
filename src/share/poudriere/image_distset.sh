#!/bin/sh

#
# Copyright (c) 2023 Allan Jude <allan@klarasystems.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

distset_check()
{
}

distset_prepare()
{
}

distset_build()
{

	if [ -n "${MINIROOT}" ]; then
		mkminiroot
	fi
}

distset_generate()
{

	mkdir ${OUTPUTDIR}/${IMAGENAME}
	TAR_CMD="tar -C ${WRKDIR}/world"
	XZ_CMD="xz -T0 -c"

	${TAR_CMD} -cf - --exclude usr/lib/debug --exclude boot . | \
	    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/base.txz"

	#${TAR_CMD} -cLf - --exclude usr/lib/debug/boot/ usr/lib/debug | \
	#    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/base-dbg.txz"

	${TAR_CMD} -cf - --exclude usr/lib/debug --exclude boot ./usr/lib32 | \
	    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/lib32.txz"

	${TAR_CMD} -cf - --exclude '*.debug' ./boot | \
	    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/kernel.txz"

	#${TAR_CMD} -cf - ./usr/lib/debug/boot | \
	#    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/kernel-dbg.txz"

	${TAR_CMD} -C ${mnt} -cLf - --exclude .svn --exclude .zfs \
	    --exclude .git --exclude @ --exclude usr/src/release/dist usr/src | \
	    ${XZ_CMD} > "${OUTPUTDIR}/${IMAGENAME}/src.txz"

}
