#!/bin/bash
set -e

testAlias+=(
	[neobytesd:trusty]='neobytesd'
)

imageTests+=(
	[neobytesd]='
		rpcpassword
	'
)
