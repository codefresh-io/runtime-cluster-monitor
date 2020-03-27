# frozen_string_literal: true

CHARTS = [
  { chart: 'stable/prometheus-operator', version: '8.12.3', release: 'cprom',
    values: 'kube-prometheus.yaml', template: 'kube-prometheus.yaml.erb' },
].freeze

CONTEXTS = [
  { name: 'dev' },
  { name: 'prod' },
].freeze

NAMESPACE = 'monitoring'
MANIFESTS = %w[cluster-autoscaler-exporter dind-volume-cleanup dind-monitor event-exporter].freeze
