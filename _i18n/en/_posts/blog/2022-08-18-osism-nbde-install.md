---
layout: post
title: "SCS Infrastructure KeylessGo"
avatar:
  - "avatar-osism.png"
image: "blog/padlock.jpg"
author:
  - "Mathias Fechner"
---
## NBDE – *Network Bound Disk Encryption*

<figure class="figure mx-auto d-block" style="width:40%">
  <a href="{% asset "blog/clevis-tang-pin.png" @path %}">
    {% asset 'blog/clevis-tang-pin.png' class="figure-img w-100" %}
  </a>
</figure>

> As an Operator i want to be sure that storage's is encrypted, as
a DevOps i think it is hard to integrated with Automation.

That was the intention to integrate NBDE in OSISM.

Network Bound Disk Encryption is a method to automatically handle LUKS for
bare metal system in location such as data centers. It should protect
against unauthorized access to data on storage devices in case of loss or vendor
lifecycle management.

The involved components Luks, Clevis and Tang:

<figure class="figure mx-auto d-block" style="width:70%">
  <a href="{% asset "blog/clevis_boot_procedure.png" @path %}">
    {% asset 'blog/clevis_boot_procedure.png' class="figure-img w-100" %}
  </a>
</figure>

### [JOSE](https://jose.readthedocs.io/)
is the Javascript Object Signing and Encryption Framework.
In context of NBDE it uses an RSA based encryption. preconfigure
part to solve the hen and egg problem

### [Clevis](https://github.com/latchset/clevis)
is a JOSE based pluggable framework which is handled automated
luks encryption local inside the boot procedure an is able to
handle network base encryption or combine it other methods

### [Tang](https://github.com/latchset/tang)
is a small webserver with the JOSE library, which is able response
to clevis prepared encryption. chain and save it as a key answer
it with a signing request, Tang relies on the JSON Object Signing and
Encryption (JOSE) standards

### [Build a encrypted base image](https://docs.osism.tech/configuration/environments/infrastructure/nbde.html#build-an-encrypted-image)
A the first step, it is to build an image with a preconfigured LUKS encryption
and password. Inside the images is a dropbear-ssh server preconfigured with and
a now authorized_key file.


### Prebooting step

At the second step at th boot phase it easy to login the with preconfigured ssh server
and the sshkey this part will later remove from installation, because an co-existing
installation is not possible.

```bash

Listening on LPF/ens3/fa:16:3e:12:77:28
Sending on   LPF/ens3/fa:16:3e:12:77:28
Sending on   Socket/fallback
DHCPDISCOVER on ens3 to 255.255.255.255 port 67 interval 3 (xid=0xea981b1a)
DHCPOFFER of 10.8.8.20 from 192.168.8.1
DHCPREQUEST for 10.8.8.20 on ens3 to 255.255.255.255 port 67 (xid=0x1a1b98ea)
DHCPACK of 10.8.8.20 from 192.168.8.1 (xid=0xea981b1a)
bound to 10.8.8.20 -- renewal in 16380 seconds.

cryptsetup: luksroot: set up successfully
done.
```

### Init clevis and tang

the second step is install the clevis tang "pin"

that means clevis request an privat key from tang and sign it with a local blended key, which is new encryption key. this is uses as new Luks meta information to create a keyslot in Luks table.

```bash

$ osism apply clevis

PLAY [test] **********************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************
ok: [10.8.8.20]

TASK [clevis : Gather variables for each operating system] ***********************************************************************************************************
ok: [10.8.8.20]

TASK [clevis : Include distribution specific package tasks] **********************************************************************************************************
included: /ansible-collection-commons/roles/clevis/tasks/install-Debian.yml for 10.8.8.20

TASK [clevis : Wait for apt lock] ************************************************************************************************************************************
ok: [10.8.8.20] => (item=lock)
ok: [10.8.8.20] => (item=lock-frontend)

TASK [clevis : Install clevis packages] ******************************************************************************************************************************
changed: [10.8.8.20]

TASK [clevis : Install tang encryption] ******************************************************************************************************************************
included: /ansible-collection-commons/roles/clevis/tasks/create-tangcrypt.yml for 10.8.8.20

TASK [clevis : Remove dropbear ssh initramfs packages] ***************************************************************************************************************
changed: [10.8.8.20]

TASK [clevis : Remove dropbear artefacts] ****************************************************************************************************************************
ok: [10.8.8.20]

TASK [clevis : Check if disk /dev/sda6 already bind to tang] *********************************************************************************************************
fatal: [10.8.8.20]: FAILED! => {"changed": false, "cmd": ["clevis", "luks", "list", "-d", "/dev/sda6", "-s", "2"], "delta": "0:00:00.137538", "end": "2022-08-16 15:02:16.298475", "msg": "non-zero return code", "rc": 1, "start": "2022-08-16 15:02:16.160937", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
...ignoring

TASK [clevis : Prepare clevis environment] ***************************************************************************************************************************
changed: [10.8.8.20]

TASK [clevis : Get adv handshake from tang server] *******************************************************************************************************************
changed: [10.8.8.20]

TASK [clevis : Insert the keyfile for luks unlock] *******************************************************************************************************************
changed: [10.8.8.20]

RUNNING HANDLER [clevis : Update initramfs] **************************************************************************************************************************
ok: [10.8.8.20]

RUNNING HANDLER [clevis : Enable clevis-luks-askpass.path service] ***************************************************************************************************
ok: [10.8.8.20]

RUNNING HANDLER [clevis : Chain tang pin] ****************************************************************************************************************************
changed: [10.8.8.20]

RUNNING HANDLER [clevis : Enable tang boot environment] **************************************************************************************************************



```

*What is ongoing on the tang service ...*

```bash

Jul 20 11:53:10 tang-server tangd[54307]: 10.8.8.20 GET /adv => 200 (src/tangd.c:82)
Jul 20 11:53:10 tang-server systemd[1]: tangd@3-10.8.8.68:1080-10.8.8.20:34082.service: Succeeded.

```

*and on the baremetallserver ?*

```bash

$ cryptsetup luksDump dev /dev/sda1

2: tang '{"url":"http://192.168.16.5:1080"}'

        Tokens:
        0: clevis
        Keyslot:  2

```

this process is very familiar with ssh-rsa authentication. Now the "Pin" is bind to the tang service.
After reboot the Server will request with the clevis-initramfs embbed client the network tang service.
If clevis tang chain, short "pin" is valid the reboot will continue.

*Now the server is booting with NBDE, here is the tangserver successfull logs *
```bash

Aug 16 13:08:11 tang-server tangd[157304]: 10.8.8.20 POST /rec/ebTVn9gtMeD-RV6Ux4DeCiSpff0 => 200 (src/tangd.c:165)
Aug 16 13:08:11 tang-server systemd[1]: tangd@6-10.8.8.68:1080-10.8.8.20:40956.service: Succeeded.

```

in SCS Stacks it is now able to activate for bare metal nodes like control, compute, network and storage nodes
