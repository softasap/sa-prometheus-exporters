sa-prometheus-exporters
=======================

[![Build Status](https://travis-ci.org/softasap/sa-prometheus-exporters.svg?branch=master)](https://travis-ci.org/softasap/sa-prometheus-exporters)

Re-usable list of exporters usually used with Prometheus

Bundled exporters:

| Exporter | Description | Port | Example | Github |
| --- | --- | --- | --- | --- |
| node | Server params | 9100 | http://192.168.2.66:9100/metrics | [prometheus/node_exporter](https://github.com/prometheus/node_exporter/) |
| mysqld | Prometheus MySQL exporter | 9104 | http://192.168.2.66:9104/metrics | [prometheus/mysqld_exporter](https://github.com/prometheus/mysqld_exporter/) |
| elasticsearch | Elastic search | 9108 | http://192.168.2.66:9108/metrics | [justwatchcom/elasticsearch_exporter](https://github.com/justwatchcom/elasticsearch_exporter/) |
| blackbox | External services | 9115 | http://192.168.2.66:9115/metrics | [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter/) |
| redis | Redis exporter | 9121 | http://192.168.2.66:9121/metrics | [oliver006/redis_exporter](https://github.com/oliver006/redis_exporter/) |
| memcached | memcached health | 9150 | http://192.168.2.66:9150/metrics | [prometheus/memcached_exporter](https://github.com/prometheus/memcached_exporter/) |
| postgres | postgres exporter | 9187 | http://192.168.2.66:9187/metrics | [wrouesnel/postgres_exporter](https://github.com/wrouesnel/postgres_exporter/) |
| cadvisor | Google's cadvisor exporter | 9199 (configurable) | http://192.168.2.66:9199/metrics | [google/cadvisor](https://github.com/google/cadvisor/) |
| mongodb | Percona's mongodb exporter | 9216 | http://192.168.2.66:9216/metrics | [percona/mongodb_exporter](https://github.com/percona/mongodb_exporter/) |
| sql | custom sql exporter | 9237 | http://192.168.2.66:9237/metrics | [justwatchcom/sql_exporter](https://github.com/justwatchcom/sql_exporter) |

Example of usage:

Simple

```YAML

     - {
         role: "sa-prometheus-exporters"
       }


```

Each exporter gets configured via OPTIONS specified in environment file located at `/etc/prometheus/exporters/exportername_exporter`
Additionally, you have possibility to influence systemd service file itself, see advanced section

```shell
OPTIONS=" --some-exporter-params --some-exporter-params --some-exporter-params --some-exporter-params"

```

Advanced

```YAML

box_prometheus_exporters:
  - {
      name: some_exporter,
      exporter_configuration_template: "/path/to/template/with/console/params/for/exporter",
      exporter_user: prometheus,
      exporter_group: prometheus,
      startup: {
        env:
          - ENV_VAR1: "ENV_VAR1 value",
          - ENV_VAR2: "ENV_VAR1 value"          

        execstop: "/some/script/to/execute/on/stop",
        pidfile: "/if/you/need/pidfile",
        extralines:
          - "IF YOU WANT"
          - "SOME REALLY CUSTOM STUFF"
          - "in Service section of the systemd file"
          - "(see templates folder)"          
      }

    }
  - {
      name: blackbox
    }
  - {
      name: elasticsearch
    }
  - {
      name: postgres
    }
  - {
      name: cadvisor
    }
  - {
      name: mongodb
    }
  - {
      name: redis
    }
  - {
      name: sql
    }
  - {
      name: memcached
    }
  - {
      name: mysqld
    }

roles:

     - {
         role: "sa-prometheus-exporters",
         prometheus_exporters: "{{box_prometheus_exporters}}"
       }


```



Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa-prometheus-exporters` role using the command


`
   ansible-galaxy install softasap.sa-prometheus-exporters
`

the role will be available in the folder `library/softasap.sa-prometheus-exporters`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa-nginx"
       }

```




Copyright and license
---------------------

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html
