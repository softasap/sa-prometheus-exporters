init:
	pipenv install --python 3

vagrant-login:
	molecule login -s default

update-from-requirements:
	pipenv install -r ./molecule/requirements-dev.txt

molecule-docker-centos7:
	ansible-galaxy collection install community.docker
	MOLECULE_DISTRO=centos7 MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) molecule converge -s docker

molecule-docker-fedora33:
	ansible-galaxy collection install community.docker
	MOLECULE_DISTRO=fedora33 MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) molecule converge -s docker

molecule-docker-xenial:
	ansible-galaxy collection install community.docker
	MOLECULE_DISTRO=ubuntu1604 MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) molecule converge -s docker

molecule-docker-beaver:
	ansible-galaxy collection install community.docker
	MOLECULE_DISTRO=ubuntu1804 MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) molecule converge -s docker

molecule-docker-focal:
	ansible-galaxy collection install community.docker
	MOLECULE_DISTRO=ubuntu2004 MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) molecule converge -s docker
