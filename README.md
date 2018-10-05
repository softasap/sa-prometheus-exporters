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
| mongodb | Percona's mongodb exporter | 9216 | http://192.168.2.66:9216/metrics | [percona/mongodb_exporter](https://github.com/percona/mongodb_exporter/) |
| ecs | aws ecs exporter | 9222 | http://192.168.2.66:9222/metrics | [slok/ecs-exporter](https://github.com/slok/ecs-exporter) |
| sql | custom sql exporter | 9237 | http://192.168.2.66:9237/metrics | [justwatchcom/sql_exporter](https://github.com/justwatchcom/sql_exporter) |
| phpfpm | php fpm exporter via sock | 9253 | http://192.168.2.66:9253/metrics | [Lusitaniae/phpfpm_exporter](https://github.com/Lusitaniae/phpfpm_exporter) |
| cadvisor | Google's cadvisor exporter | 9280 (configurable) | http://192.168.2.66:9280/metrics | [google/cadvisor](https://github.com/google/cadvisor/) |
| monit | Monit exporter | 9388 (configurable) | http://192.168.2.66:9388/metrics | [commercetools/monit_exporter](https://github.com/commercetools/monit_exporter) |
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
      name: mysqld,
      parameters: "-config.my-cnf=/etc/prometheus/.mycnf -collect.binlog_size=true -collect.info_schema.processlist=true"
    }
  - {
      name: ecs,
      parameters: "--aws.region='us-east-1'"
    }
  - {
      name: monit,
      parameters: "--monit_user='monit' --monit_password='monit_password'"
    }


roles:

     - {
         role: "sa-prometheus-exporters",
         prometheus_exporters: "{{box_prometheus_exporters}}"
       }


```

mysqld exporter configuration
-----------------------------

Best served with grafana dashboards from percona https://github.com/percona/grafana-dashboards

For those you need to add parameter
`-collect.binlog_size=true -collect.info_schema.processlist=true`

additionally create exporter mysql user

```sql
CREATE USER 'prometheus_exporter'@'localhost' IDENTIFIED BY 'XXX' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'prometheus_exporter'@'localhost';
```

then either ensure environment variable in startup script (see configuration example in advanced)
```shell
export DATA_SOURCE_NAME='prometheus_exporter:XXX@(localhost:3306)/'
```

or

create  ~/.my.cnf

-config.my-cnf=/etc/prometheus/.mycnf -collect.binlog_size=true -collect.info_schema.processlist=true

```ini
[client]
user=prometheus_exporter
password=XXXXXX
```

For presentation, consider grafana dashboards , like

https://github.com/percona/grafana-dashboards



postgres exporter configuration
--------------------------------

Recommended approach - is to use dedicated user for stats collecting

create exporter `postgres_exporter` user

```sql
CREATE USER postgres_exporter PASSWORD 'XXXX';
ALTER USER postgres_exporter SET SEARCH_PATH TO postgres_exporter,pg_catalog;
```

As you are running as non postgres user, you would need to create views
to read statistics information

```sql

-- If deploying as non-superuser (for example in AWS RDS)
-- GRANT postgres_exporter TO :MASTER_USER;
CREATE SCHEMA postgres_exporter AUTHORIZATION postgres_exporter;

CREATE VIEW postgres_exporter.pg_stat_activity
AS
  SELECT * from pg_catalog.pg_stat_activity;

GRANT SELECT ON postgres_exporter.pg_stat_activity TO postgres_exporter;

CREATE VIEW postgres_exporter.pg_stat_replication AS
  SELECT * from pg_catalog.pg_stat_replication;

GRANT SELECT ON postgres_exporter.pg_stat_replication TO postgres_exporter;
```

in `/etc/prometheus/exporters/postgres_exporter`

```
OPTIONS="some parameters"
DATA_SOURCE_NAME="login:password@(hostname:port)/"
```

Assuming, you provided above exporter is ready to operate.

For presentation, consider grafana dashboards , like

https://grafana.com/dashboards/3300

https://grafana.com/dashboards/3742


Blackbox exporter notes
-----------------------

startup options should be kind of
```
OPTIONS="--config.file=/opt/prometheus/exporters/blackbox_exporter/blackbox.yml"
```

where blackbox.yml is

```yaml

modules:
  http_2xx:
    prober: http
    http:
  http_post_2xx:
    prober: http
    http:
      method: POST
  tcp_connect:
    prober: tcp
  pop3s_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^+OK"
      tls: true
      tls_config:
        insecure_skip_verify: false
  ssh_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^SSH-2.0-"
  irc_banner:
    prober: tcp
    tcp:
      query_response:
      - send: "NICK prober"
      - send: "USER prober prober prober :prober"
      - expect: "PING :([^ ]+)"
        send: "PONG ${1}"
      - expect: "^:[^ ]+ 001"
  icmp:
    prober: icmp
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
