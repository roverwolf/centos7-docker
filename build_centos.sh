#!/bin/bash -xe

size=small
ver=7

[ $( id -u ) -eq 0 ] || { echo "must be root"; exit 1; }

tmpdir=$(mktemp -d)
trap "echo removing ${tmpdir}; rm -rf ${tmpdir}" EXIT

repo=$repoowner/centos-$size
appliance-creator -c container-$size-$ver.ks -d -v -t /tmp \
    -o ${tmpdir} --name "centos-$ver-$size" --release $ver \
    --format=qcow2 && 
  virt-tar-out -a ${tmpdir}/centos-$ver-$size/centos-$ver-$size-sda.qcow2 / - |
  xz -9e -T 0 > centos-${ver}-${size}.tar.xz
