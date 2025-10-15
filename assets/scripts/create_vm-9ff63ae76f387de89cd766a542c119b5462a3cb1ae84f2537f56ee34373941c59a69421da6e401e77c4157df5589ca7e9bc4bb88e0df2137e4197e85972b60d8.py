#!/usr/bin/env python3
# Create a VM on a diskless flavor
# (c) Kurt Garloff <garloff@osb-alliance.de>, 2023-08-20
# SPDX-License-Identifier: Apache-2.0

import openstack
import sys

# OS_CLOUD will be taken from environment
FLAVOR="SCS-1V-2"
NETWORK=""
IMAGE="Debian 12"
KEYNAME="SSHkey-gxscscapi"

def main(argv):
	"""
	Creates a server on a diskless flavor in a cloud env["OS_CLOUD"]
	(configured in clouds.yaml+secure.yaml) with flavor FLAVOR
	in network NETWORK (defaults to first if empty) with image IMAGE
	injecting keypair KEYNAME.
	"""
	# Connect and get token   
	conn = openstack.connect()
	conn.authorize()
	# Get flavor and image IDs
	flavor = conn.compute.find_flavor(FLAVOR)
	if not flavor:
		raise ValueError(f"No flavor {FLAVOR} found")
	image = conn.compute.find_image(IMAGE)
	if not image:
		raise ValueError(f"No image {IMAGE} found")
	# Determine network to connect to
	found_network = None
	for net in conn.network.networks():
		if not net.is_admin_state_up or net.is_router_external:
			continue
		if not NETWORK or net.name == NETWORK:
			found_network = net
			break
	if found_network is None:
		raise ValueError(f"No network {NETWORK} found")
	# Create VM instance
	vm = conn.compute.create_server(
		name="test-diskless",
		networks=[{"uuid": found_network.id}],
		flavor_id=flavor.id,
		key_name=KEYNAME,
		block_device_mapping_v2=[{'boot_index': 0,
			'uuid': image.id,
			'source_type': 'image',
			'volume_size': 12,
			'destination_type': 'volume',
			'delete_on_termination': True}
		]
	)

if __name__ == "__main__":
	main(sys.argv)
