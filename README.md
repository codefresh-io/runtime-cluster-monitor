# prometheus for runtime clusters

## Required
* kubectl, helm
* Ruby and `gem install rake erubis`

## Configuration
If you want Slack or VictorOps notifications write a file: `env/prod.yaml`.

It may specify:
* `slack_hook`: URL to Slack hook
* `slack_warnings`: channel name for warnings, full name like `#ops-warnings`
* `slack_errors`: channel name for errors, full name like `#ops-errors`
* `victorops_api_key`: API key to VictorOps
* `victorops_routing`: VictorOps routing policy name

Please note that if you set `slack_hook`, you're reqiuired to set both `slack_warnings` and `slack_errors`.  
If you set `victorops_api_key`, `victorops_routing` is also required.

## Usage
* switch your k8s context to needed
* `rake cluster=... [env=prod] [args=...]` to install or update your installation
* `rake destroy` to remove the deployment

`cluster` could be any helpful string to identify alerts.  
use `env=prod` if you have `env/prod.yaml`, if you don't, just omit this part.  
`args` are additional args to Helm, if you don't need it, skip it.

if you need to pass multiple Helm args or whitespace, escape them:
* `rake cluster=... args='--dry-run --debug'`

sometimes there's a problem with Prometheus CRDs, a workaround is to install them manually:
* `kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.32/example/prometheus-operator-crd/alertmanager.crd.yaml`
* `kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.32/example/prometheus-operator-crd/podmonitor.crd.yaml`
* `kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.32/example/prometheus-operator-crd/prometheus.crd.yaml`
* `kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.32/example/prometheus-operator-crd/prometheusrule.crd.yaml`
* `kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.32/example/prometheus-operator-crd/servicemonitor.crd.yaml`
* `rake cluster=... args='--set prometheusOperator.createCustomResource=false'`

## Access services

### [prometheus](http://localhost:9090/prometheus/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-prometheus 9090`

### [alertmanager](http://localhost:9093/alertmanager/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-alertmanager 9093`

### [grafana](http://localhost:3000/grafana/)
`kubectl -n monitoring port-forward svc/cprom-grafana 3000:80`

