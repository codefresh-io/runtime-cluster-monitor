# frozen_string_literal: true

require_relative 'lib/helm4rake'

charts = [
  { chart: 'stable/prometheus-operator', release: 'cprom',
    values: 'kube-prometheus.yaml', template: 'kube-prometheus.yaml.erb' },
]
contexts = [
  { name: 'dev' },
  { name: 'prod' },
]

Helm4Rake.new(charts, contexts, 'monitor')
