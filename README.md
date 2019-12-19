# prometheus for runtime clusters

## Required
* helm v2, tiller
* Ruby and `gem install rake erubis`

## Usage
* switch your context to needed
* `rake env=... args='--set cluster_name=...'` to install or update your installation  
  you may need `rake env=... args='--set prometheusOperator.createCustomResource=false'`
* `rake destroy env=...` to remove the deployment

`env` is `dev` or `prod` (`prod` sends alerts to VictorOps, `dev` does not)  
`cluster_name` is cluster's full DNS name

if you need to pass multiple args or whitespace, escape them:
* `rake args='--dry-run --debug'`

for modifying the secrets two helpers are avaliable:
* `rake decrypt env=dev` to decode `env/dev.yaml` to `env/dev_raw.yaml`
* `rake encrypt env=dev` to encode `env/dev_raw.yaml` to `env/dev.yaml`

substitute `dev` for `prod`. please note that new secrets will be used only after encoding.  
if you want encode a file, while leaving an unencrypted working copy, use `rake encrypt decrypt env=dev`

## Warning
do not run more than one task concurrently, this will break things

## Access services

### [prometheus](http://localhost:9090/prometheus/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-prometheus 9090`

### [alertmanager](http://localhost:9093/alertmanager/)
`kubectl -n monitoring port-forward svc/cprom-prometheus-operator-alertmanager 9093`

### [grafana](http://localhost:3000/grafana/)
`kubectl -n monitoring port-forward svc/cprom-grafana 3000:80`

Please also note all services are exported through Octant, use `https://cluster_name` to access it.
Use `/prometheus`, `/alertmanager` and `/grafana` on this domain.
