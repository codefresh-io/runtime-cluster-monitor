# frozen_string_literal: true

CHARTS = [
  { chart: 'stable/prometheus-operator', version: '8.5.14', release: 'cprom',
    values: 'kube-prometheus.yaml', template: 'kube-prometheus.yaml.erb' },
].freeze

NAMESPACE = 'monitoring'
MANIFESTS = %w[dind-volume-cleanup dind-monitor event-exporter].freeze
