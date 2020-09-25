# prometheus for runtime clusters

These scripts deploy a Prometheus Operator installation (Prometheus, Alertmanager, Grafana)
that's pre-configured for Codefresh runtime clusters. It includes alerts and dashboards for monitoring
the runtime cluster, as well as configures exporters and cron jobs. What's included:

* [Prometheus Operator](https://github.com/coreos/prometheus-operator)
* [cluster-autoscaler-exporter](https://github.com/codefresh-io/cluster-autoscaler-exporter)
* `dind-volume-cleanup`, `dind-monitor`, `dind-exporter` and `event-exporter` (custom parts with source code not provided)

We create a `monitoring` namespace and put all the things there.

## Required
* kubectl
* helm
* [helmfile](https://github.com/roboll/helmfile)

## Configuration
If you want Slack or VictorOps notifications write a file: `values.yaml`.

It may specify:
* `slack_hook`: URL to Slack hook
* `slack_warnings`: channel name for warnings, full name like `#ops-warnings`
* `slack_errors`: channel name for errors, full name like `#ops-errors`
* `victorops_api_key`: API key to VictorOps
* `victorops_routing`: VictorOps routing policy name
* `affinity`: string to set up monitoring affinity/tolerations (see [template](https://github.com/codefresh-io/runtime-cluster-monitor/blob/master/templates/affinity.yaml.gotmpl) for more details)
* `prom_ram`: Prometheus memory requests and limits, defaults to `6Gi` for a 8GB instance  
   use `14Gi` if using a 16GB instance; use `24Gi` if using a 32GB instance
* `prom_cpu`: Prometheus CPU requests (defaults to `1`, you may want to increase it)  
  Prometheus CPU limits are twice this value
* `coredns: true` set this if using CoreDNS, not Kube-DNS

Please note that if you set `slack_hook`, you're reqiuired to set both `slack_warnings` and `slack_errors`.  
If you set `victorops_api_key`, `victorops_routing` is also required.

## Usage
* switch your k8s context to needed
* `helmfile [-e local] sync` to install or update your installation
* `helmfile destroy` to remove the deployment

use `-e local` if you have `values.yaml`, if you don't, just omit this part.

## Access services

### [prometheus](http://localhost:9090/prometheus/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-prometheus 9090`

### [alertmanager](http://localhost:9093/alertmanager/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-alertmanager 9093`

### [grafana](http://localhost:3000/grafana/)
`kubectl -n monitoring port-forward svc/cprom-grafana 3000:80`
