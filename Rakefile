# frozen_string_literal: true

require_relative 'lib/helm4rake'

contexts = [
  { name: 'dev' },
  { name: 'prod' },
]
charts = [
  { chart: 'stable/prometheus-operator', release: 'cprom',
    values: 'kube-prometheus.yaml', template: 'kube-prometheus.yaml.erb' },
]

namespace = 'monitoring'
manifests = %w[dind-monitor event-exporter]

Helm4Rake.new(charts, contexts, namespace)

desc 'kubectl apply'
task :apply do
  manifests.each do |i|
    sh "kubectl apply -n #{namespace} -f #{i}.yaml"
  end
end

desc 'kubectl delete'
task :remove do
  manifests.each do |i|
    sh "kubectl delete -n #{namespace} -f #{i}.yaml"
  end
end

desc 'deploy releases and resources'
task default: %i[install apply]

desc 'destroy releases and resources'
task destroy: %i[remove delete]
