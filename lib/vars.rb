# frozen_string_literal: true

CHARTS = [
  { chart: 'stable/prometheus-operator', version: '8.16.1', release: 'cprom',
    values: 'kube-prometheus.yaml', template: 'kube-prometheus.yaml.erb' },
].freeze

CONTEXTS = [
  { name: 'dev' },
  { name: 'prod' },
  { name: 'prod8' },
  { name: 'prod32' },
].freeze

NAMESPACE = 'monitoring'
MANIFESTS = %w[cluster-autoscaler-exporter dind-volume-cleanup dind-monitor dind-exporter event-exporter].freeze
