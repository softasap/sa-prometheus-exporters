import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_node_exporter_binary(host):
    f = host.file('/opt/prometheus/exporters/node_exporter/node_exporter')

    assert f.exists
    assert f.user == 'prometheus'


def test_redis_exporter_binary(host):
    path = '/opt/prometheus/exporters/redis_exporter/redis_exporter'
    binary = host.file(path)

    assert binary.exists
