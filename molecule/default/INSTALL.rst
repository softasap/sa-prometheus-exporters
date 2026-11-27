*******
Vagrant driver installation guide (libvirt)
*******

Requirements
============

* Vagrant
* libvirt / QEMU-KVM and the vagrant-libvirt plugin
* python-vagrant

Install
=======

.. code-block:: bash

    $ sudo pip install python-vagrant
    $ vagrant plugin install vagrant-libvirt

The default molecule scenario uses the libvirt provider. Any other
vagrant-supported provider (virtualbox, parallels, vmware_desktop, ...)
can be selected via the ``provider.name`` setting in
``molecule/default/molecule.yml``.
