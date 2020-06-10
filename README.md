sa-prometheus-exporters
=======================

[![Build Status](https://travis-ci.org/softasap/sa-prometheus-exporters.svg?branch=master)](https://travis-ci.org/softasap/sa-prometheus-exporters)

Re-usable list of exporters usually used with Prometheus

Bundled exporters:

| Exporter | Description | Port | Grafana | Example | Github |
| --- | --- | --- | --- | --- | --- |
| node | Server params | 9100 | 1860  | http://192.168.2.66:9100/metrics | [prometheus/node_exporter](https://github.com/prometheus/node_exporter/) |
| mysqld | Prometheus MySQL exporter | 9104 | 7362 | http://192.168.2.66:9104/metrics | [prometheus/mysqld_exporter](https://github.com/prometheus/mysqld_exporter/) |
| elasticsearch | Elastic search | 9108 | 2322 | http://192.168.2.66:9108/metrics | [justwatchcom/elasticsearch_exporter](https://github.com/justwatchcom/elasticsearch_exporter/) |
| nginx | Nginx exporter | 9113 | 11199 | http://192.168.2.66:9115/metrics | [nginxinc/nginx-prometheus-exporter](https://github.com/nginxinc/nginx-prometheus-exporter) |
| blackbox | External services | 9115 | | http://192.168.2.66:9115/metrics | [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter/) |
| apache | Apache webserver | 9117 | | http://192.168.2.66:9117/metrics | [Lusitaniae/apache_exporter](https://github.com/Lusitaniae/apache_exporter/) |
| redis | Redis exporter | 9121 | 763  | http://192.168.2.66:9121/metrics | [oliver006/redis_exporter](https://github.com/oliver006/redis_exporter/) |
| proxysql | ProxySQL exporter | 42004 | | http://192.168.2.66:42004/metrics | [percona/proxysql_exporter](https://github.com/percona/proxysql_exporter) |
| memcached | memcached health | 9150 | 37 | http://192.168.2.66:9150/metrics | [prometheus/memcached_exporter](https://github.com/prometheus/memcached_exporter/) |
| postgres | postgres exporter | 9187 | | http://192.168.2.66:9187/metrics | [wrouesnel/postgres_exporter](https://github.com/wrouesnel/postgres_exporter/) |
| mongodb | Percona's mongodb exporter | 9216 | | http://192.168.2.66:9216/metrics | [percona/mongodb_exporter](https://github.com/percona/mongodb_exporter/) |
| ssl | ssl exporter | 9219 | | http://192.168.2.66:9219/metrics | [ribbybibby/ssl_exporter](https://github.com/ribbybibby/ssl_exporter) |
| ecs | aws ecs exporter | 9222 | | http://192.168.2.66:9222/metrics | [slok/ecs-exporter](https://github.com/slok/ecs-exporter) |
| sql | custom sql exporter | 9237 | | http://192.168.2.66:9237/metrics | [justwatchcom/sql_exporter](https://github.com/justwatchcom/sql_exporter) |
| phpfpm | php fpm exporter via sock | 9253 | 5579 | http://192.168.2.66:9253/metrics | [Lusitaniae/phpfpm_exporter](https://github.com/Lusitaniae/phpfpm_exporter) |
| cadvisor | Google's cadvisor exporter | 9280 (configurable) | | http://192.168.2.66:9280/metrics | [google/cadvisor](https://github.com/google/cadvisor/) |
| monit | Monit exporter | 9388 (configurable) | | http://192.168.2.66:9388/metrics | [commercetools/monit_exporter](https://github.com/commercetools/monit_exporter) |
| cloudwatch | Cloudwatch exporter | 9400 (configurable) | | http://192.168.2.66:9400/metrics | [ivx/yet-another-cloudwatch-exporter](https://github.com/ivx/yet-another-cloudwatch-exporter) |

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
      name: apache
    }
  - {
      name: blackbox
    }
  - {
      name: cadvisor
    }
  - {
      name: ecs,
      parameters: "--aws.region='us-east-1'"
    }
  - {
      name: elasticsearch
    }
  - {
      name: memcached
    }
  - {
      name: mongodb
    }
  - {
      name: monit,
      monit_user: "admin",
      monit_password: "see_box_example_for_example_)",
      listen_address: "0.0.0.0:9388"
    }
  - {
      name: mysqld,
      parameters: "-config.my-cnf=/etc/prometheus/.mycnf -collect.binlog_size=true -collect.info_schema.processlist=true"
    }
  - {
      name: node
    }
  - {
      name: nginx,
      parameters: "-nginx.scrape-uri http://<nginx>:8080/stub_status
    }
  - {
      name: proxysql
    }
  - {
      name: phpfpm,
      exporter_user: "www-data",
      parameters: "--phpfpm.socket-paths /var/run/php/php7.0-fpm.sock"
    }
  - {
      name: postgres
    }
  - {
      name: redis
    }
  - {
      name: sql
    }
  - {
      name: ssl
    }


roles:

     - {
         role: "sa-prometheus-exporters",
         prometheus_exporters: "{{box_prometheus_exporters}}"
       }


```

More exporters to consider:   https://prometheus.io/docs/instrumenting/exporters/

If you want some to be included into role defaults, open the issue or PR (preferable)

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

also option to do that via exporter environment file `/etc/prometheus/exporters/mysqld_exporter`
```
OPTIONS=""
DATA_SOURCE_NAME='prometheus_exporter:devroot@(localhost:3306)/'
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

For troubleshouting, must have grafana dashboard is  https://grafana.com/dashboards/456


apache exporter configuration
-----------------------------

apache	Server params	9117	http://192.168.2.66:9117/metrics	Lusitaniae/apache_exporter


prometheus.yml
```
  - job_name: "apache"
    ec2_sd_configs:
      - region: us-east-1
        port: 9117
    relabel_configs:
        # Only monitor instances with a non-no Prometheus tag
      - source_labels: [__meta_ec2_tag_Prometheus]
        regex: no
        action: drop
      - source_labels: [__meta_ec2_instance_state]
        regex: stopped
        action: drop
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Role]
        target_label: role
      - source_labels: [__meta_ec2_public_ip]
        regex: (.*)
        replacement: ${1}:9117
        action: replace
        target_label: __address__
```

Grafana dashboard compatible with this exporter is, for example  https://grafana.com/dashboards/3894

blackbox exporter configuration
-------------------------------

Blackbox exporter running on a monitoring host can, for example be used

Example: monitoring ssh connectivity for external boxes

prometheus.yml
```
  - job_name: 'blackbox_ssh'
    metrics_path: /probe
    params:
      module: [ssh_banner]
    ec2_sd_configs:
      - region: us-east-1
        port: 9100
    relabel_configs:
        # Only monitor instances with a non-no Prometheus tag
      - source_labels: [__meta_ec2_tag_Prometheus]
        regex: no
        action: drop
      - source_labels: [__meta_ec2_instance_state]
        regex: stopped
        action: drop
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Role]
        target_label: role
      - source_labels: [__meta_ec2_private_ip]
        regex: (.*)(:.*)?
        replacement: ${1}:22
        target_label: __param_target
      # Actually talk to the blackbox exporter though
      - target_label: __address__
        replacement: 127.0.0.1:9115

```

And in a result you can tune prometheus alert manager to alert if you got issues with ssh connectivity

/etc/prometheus/rules/ssh_alerts.yml
```
groups:
- name: ssh_alerts.rules
  rules:
  - alert: SSHDown
    expr: probe_success{job="blackbox_ssh"} == 0
    annotations:
      description: '[{{ $labels.env }}]{{ $labels.instance }} {{ $labels.name }} of job {{ $labels.job }} is not responding on ssh.'
      summary: 'Instance {{ $labels.instance }} has possible ssh issue'
    for: 10m
```


memcached exporter configuration
--------------------------------

memcached	memcached health	9150	http://192.168.2.66:9150/metrics	prometheus/memcached_exporter


prometheus.yml
```
  - job_name: "memcached"
    ec2_sd_configs:
      - region: us-east-1
        port: 9150
    relabel_configs:
        # Only monitor instances with a non-no Prometheus tag
      - source_labels: [__meta_ec2_tag_Prometheus]
        regex: no
        action: drop
      - source_labels: [__meta_ec2_instance_state]
        regex: stopped
        action: drop
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Role]
        target_label: role
      - source_labels: [__meta_ec2_public_ip]
        regex: (.*)
        replacement: ${1}:9150
        action: replace
        target_label: __address__
```

Compatible grafana dashboard
https://grafana.com/dashboards/37




node exporter configuration
---------------------------

node	Server params	9100	http://192.168.2.66:9100/metrics	prometheus/node_exporter

Auto discovery in aws cloud, with filtering

prometheus.yml
```
  - job_name: "node"
    ec2_sd_configs:
      - region: us-east-1
        port: 9100
    relabel_configs:
        # Only monitor instances with a non-no Prometheus tag
      - source_labels: [__meta_ec2_tag_Prometheus]
        regex: no
        action: drop
      - source_labels: [__meta_ec2_instance_state]
        regex: stopped
        action: drop
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Role]
        target_label: role
      - source_labels: [__meta_ec2_public_ip]
        regex: (.*)
        replacement: ${1}:9100
        action: replace
        target_label: __address__
```

Some reasonable set of linked prometheus alerts to consider

/etc/prometheus/rules/node_alerts.yml
```
groups:
- name: node_alerts.rules
  rules:
  - alert: LowDiskSpace
    expr: node_filesystem_avail{fstype=~"(ext.|xfs)",job="node"} / node_filesystem_size{fstype=~"(ext.|xfs)",job="node"}* 100 <= 10
    for: 15m
    labels:
      severity: warn
    annotations:
      title: 'Less than 10% disk space left'
      description: |
        Consider sshing into the instance and removing old logs, clean
        temp files, or remove old apt packages with `apt-get autoremove`
      runbook: troubleshooting/filesystem_alerts.md
      value: '{{ $value | humanize }}%'
      device: '{{ $labels.device }}%'
      mount_point: '{{ $labels.mountpoint }}%'
  - alert: NoDiskSpace
    expr: node_filesystem_avail{fstype=~"(ext.|xfs)",job="node"} / node_filesystem_size{fstype=~"(ext.|xfs)",job="node"}* 100 <= 1
    for: 15m
    labels:
      pager: pagerduty
      severity: critical
    annotations:
      title: '1% disk space left'
      description: "There's only 1% disk space left"
      runbook: troubleshooting/filesystem_alerts.md
      value: '{{ $value | humanize }}%'
      device: '{{ $labels.device }}%'
      mount_point: '{{ $labels.mountpoint }}%'

  - alert: HighInodeUsage
    expr: node_filesystem_files_free{fstype=~"(ext.|xfs)",job="node"} / node_filesystem_files{fstype=~"(ext.|xfs)",job="node"}* 100 <= 20
    for: 15m
    labels:
      severity: critical
    annotations:
      title: "High number of inode usage"
      description: |
        "Consider ssh'ing into the instance and removing files or clean
        temp files"
      runbook: troubleshooting/filesystem_alerts_inodes.md
      value: '{{ $value | printf "%.2f" }}%'
      device: '{{ $labels.device }}%'
      mount_point: '{{ $labels.mountpoint }}%'

  - alert: ExtremelyHighCPU
    expr: instance:node_cpu_in_use:ratio > 0.95
    for: 2h
    labels:
      pager: pagerduty
      severity: critical
    annotations:
      description: CPU use percent is extremely high on {{ if $labels.fqdn }}{{ $labels.fqdn
        }}{{ else }}{{ $labels.instance }}{{ end }} for the past 2 hours.
      runbook: troubleshooting
      title: CPU use percent is extremely high on {{ if $labels.fqdn }}{{ $labels.fqdn
        }}{{ else }}{{ $labels.instance }}{{ end }} for the past 2 hours.

  - alert: HighCPU
    expr: instance:node_cpu_in_use:ratio > 0.8
    for: 2h
    labels:
      severity: critical
    annotations:
      description: CPU use percent is extremely high on {{ if $labels.fqdn }}{{ $labels.fqdn
        }}{{ else }}{{ $labels.instance }}{{ end }} for the past 2 hours.
      runbook: troubleshooting
      title: CPU use percent is high on {{ if $labels.fqdn }}{{ $labels.fqdn }}{{
        else }}{{ $labels.instance }}{{ end }} for the past 2 hours.

```

Grafana dashboard might be   https://grafana.com/dashboards/22 (label_values(node_exporter_build_info, instance))

Consider:  https://grafana.com/dashboards/6014 or https://grafana.com/dashboards/718


nginx exporter configuration
----------------------------

Additional parameters for that might be passed for nginx-prometheus-exporter:
  -nginx.plus
        Start the exporter for NGINX Plus. By default, the exporter is started for NGINX. The default value can be overwritten by NGINX_PLUS environment variable.
  -nginx.retries int
        A number of retries the exporter will make on start to connect to the NGINX stub_status page/NGINX Plus API before exiting with an error. The default value can be overwritten by NGINX_RETRIES environment variable.
  -nginx.retry-interval duration
        An interval between retries to connect to the NGINX stub_status page/NGINX Plus API on start. The default value can be overwritten by NGINX_RETRY_INTERVAL environment variable. (default 5s)
  -nginx.scrape-uri string
        A URI for scraping NGINX or NGINX Plus metrics.
        For NGINX, the stub_status page must be available through the URI. For NGINX Plus -- the API. The default value can be overwritten by SCRAPE_URI environment variable. (default "http://127.0.0.1:8080/stub_status")
  -nginx.ssl-verify
        Perform SSL certificate verification. The default value can be overwritten by SSL_VERIFY environment variable. (default true)
  -nginx.timeout duration
        A timeout for scraping metrics from NGINX or NGINX Plus. The default value can be overwritten by TIMEOUT environment variable. (default 5s)
  -web.listen-address string
        An address to listen on for web interface and telemetry. The default value can be overwritten by LISTEN_ADDRESS environment variable. (default ":9113")
  -web.telemetry-path string
        A path under which to expose metrics. The default value can be overwritten by TELEMETRY_PATH environment variable. (default "/metrics")

Exported metrics

Exported Metrics
Common metrics:

nginxexporter_build_info -- shows the exporter build information.
For NGINX, the following metrics are exported:

All stub_status metrics.
nginx_up -- shows the status of the last metric scrape: 1 for a successful scrape and 0 for a failed one.
Connect to the /metrics page of the running exporter to see the complete list of metrics along with their descriptions.

For NGINX Plus, the following metrics are exported:

Connections.
HTTP.
SSL.
HTTP Server Zones.
Stream Server Zones.
HTTP Upstreams. Note: for the state metric, the string values are converted to float64 using the following rule: "up" -> 1.0, "draining" -> 2.0, "down" -> 3.0, "unavail" –> 4.0, "checking" –> 5.0, "unhealthy" -> 6.0.
Stream Upstreams. Note: for the state metric, the string values are converted to float64 using the following rule: "up" -> 1.0, "down" -> 3.0, "unavail" –> 4.0, "checking" –> 5.0, "unhealthy" -> 6.0.
Stream Zone Sync.
nginxplus_up -- shows the status of the last metric scrape: 1 for a successful scrape and 0 for a failed one.
Location Zones.
Resolver.
Connect to the /metrics page of the running exporter to see the complete list of metrics along with their descriptions. Note: to see server zones related metrics you must configure status zones and to see upstream related metrics you must configure upstreams with a shared memory zone.


You would need also activate

```
location /stub_status {
 	stub_status;
 	allow 127.0.0.1;	#only allow requests from localhost
 	deny all;		#deny all other hosts	
 }
```

phpfpm exporter configuration
-----------------------------

phpfpm	php fpm exporter via sock	9253	http://192.168.2.66:9253/metrics	Lusitaniae/phpfpm_exporter


Pay attention to configuration

First of all, exporter should work under user, that can read php-fpm sock (for example www-data if you used sa-php-fpm role),
Second - you should provide path to sock, like `--phpfpm.socket-paths /var/run/php/php7.0-fpm.sock`

```yaml
      exporter_user: "www-data",
      parameters: "--phpfpm.socket-paths /var/run/php/php7.0-fpm.sock"
```

Third, the FPM status page must be enabled in every pool you'd like to monitor by defining pm.status_path = /status


Auto discovery in aws cloud, with filtering

prometheus.yml
```
  - job_name: "phpfpm"
    ec2_sd_configs:
      - region: us-east-1
        port: 9253
    relabel_configs:
        # Only monitor instances with a non-no Prometheus tag
      - source_labels: [__meta_ec2_tag_Prometheus]
        regex: no
        action: drop
      - source_labels: [__meta_ec2_instance_state]
        regex: stopped
        action: drop
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Role]
        target_label: role
      - source_labels: [__meta_ec2_public_ip]
        regex: (.*)
        replacement: ${1}:9253
        action: replace
        target_label: __address__
```

Linked grafana dashboard:

https://grafana.com/dashboards/5579  (single pool)

https://grafana.com/dashboards/5714 (multiple pools)


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


cloudwatch exporter configuration
---------------------------------

You will need to give appropriate rights to your monitoring instance

```tf

resource "aws_iam_role" "monitoring_iam_role" {
  name = "monitoring_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
  role = "${aws_iam_role.monitoring_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchFullAccess" {
  role = "${aws_iam_role.monitoring_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}


resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
  role = "${aws_iam_role.monitoring_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchFullAccess" {
  role = "${aws_iam_role.monitoring_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy" "iam_role_policy_prometheuscloudwatch" {
  name = "iam_role_policy_prometheuscloudwatch"
  role = "${aws_iam_role.monitoring_iam_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "prometheuscloudwatchexporter",
            "Effect": "Allow",
            "Action": [
                "tag:GetResources",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

```

config.yml by default is scripted to give you idea about possibilities.
Amend it. You should adjust it's structure to your environment


```
discovery:
  exportedTagsOnMetrics:
    vpn:
      - Project
      - Name
    elb:
      - Project
      - Name
    rds:
      - Project
      - Name
    ec:
     - Project
     - Name
    lambda:
     - Project
     - Name
    alb:
     - Project
     - Name

  jobs:
  - region: {{ ec2_region }}
    type: "vpn"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: TunnelState
        statistics:
        - 'Maximum'
        period: 60
        length: 300
      - name: TunnelDataOut
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: TunnelDataIn
        statistics:
        - 'Sum'
        period: 60
        length: 300
  - region: {{ ec2_region }}
    type: "lambda"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: Throttles
        statistics:
        - 'Average'
        period: 60
        length: 300
      - name: Invocations
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: Errors
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: Duration
        statistics:
        - 'Average'
        period: 60
        length: 300
      - name: Duration
        statistics:
        - 'Minimum'
        period: 60
        length: 300
      - name: Duration
        statistics:
        - 'Maximum'
        period: 60
        length: 300
  - region: {{ ec2_region }}
    type: "ec"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: NewConnections
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: GetTypeCmds
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: SetTypeCmds
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: CacheMisses
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: CacheHits
        statistics:
        - 'Sum'
        period: 60
        length: 300
  - region: {{ ec2_region }}
    type: "rds"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: DatabaseConnections
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: ReadIOPS
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: WriteIOPS
        statistics:
        - 'Sum'
        period: 60
        length: 300
  - region: {{ ec2_region }}
    type: "elb"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: RequestCount
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: HealthyHostCount
        statistics:
        - 'Minimum'
        period: 60
        length: 300
      - name: UnHealthyHostCount
        statistics:
        - 'Maximum'
        period: 60
        length: 300
      - name: HTTPCode_Backend_2XX
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: HTTPCode_Backend_5XX
        statistics:
        - 'Sum'
        period: 60
        length: 300
      - name: HTTPCode_Backend_4XX
        statistics:
        - 'Sum'
        period: 60
        length: 300
  - region: {{ ec2_region }}
    type: "alb"
    searchTags:
      - Key: {{ prometheus_yace_tag_filter }}
        Value: {{ prometheus_yace_tag_value }}
    metrics:
      - name: RequestCount
        statistics:
        - 'Sum'
        period: 600
        length: 600
      - name: HealthyHostCount
        statistics:
        - 'Minimum'
        period: 600
        length: 600
      - name: UnHealthyHostCount
        statistics:
        - 'Maximum'
        period: 600
        length: 600
      - name: HTTPCode_Target_2XX
        statistics:
        - 'Sum'
        period: 600
        length: 600
      - name: HTTPCode_Target_5XX
        statistics:
        - 'Sum'
        period: 600
        length: 600
      - name: HTTPCode_Target_4XX
        statistics:
        - 'Sum'
        period: 60
        length: 60
```

ssl exporter configuration
--------------------------

Just like with the blackbox_exporter, you should pass the targets to a single instance of the exporter in a scrape config with a clever bit of relabelling. This allows you to leverage service discovery and keeps configuration centralised to your Prometheus config.

```yml

scrape_configs:
  - job_name: 'ssl'
    metrics_path: /probe
    static_configs:
      - targets:
        - example.com:443
        - prometheus.io:443
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9219  # SSL exporter.
```

Example Queries
Certificates that expire within 7 days, with Subject Common Name and Subject Alternative Names joined on:

```
((ssl_cert_not_after - time() < 86400 * 7) * on (instance,issuer_cn,serial_no) group_left (dnsnames) ssl_cert_subject_alternative_dnsnames) * on (instance,issuer_cn,serial_no) group_left (subject_cn) ssl_cert_subject_common_name
```

Only return wildcard certificates that are expiring:

```
((ssl_cert_not_after - time() < 86400 * 7) * on (instance,issuer_cn,serial_no) group_left (subject_cn) ssl_cert_subject_common_name{subject_cn=~"\\*.*"})
```

Number of certificates in the chain:

```
count(ssl_cert_subject_common_name) by (instance)

```
Identify instances that have failed to create a valid SSL connection:

```
ssl_tls_connect_success == 0
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


Ideas for more alerts:  https://awesome-prometheus-alerts.grep.to/


Copyright and license
---------------------

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html
