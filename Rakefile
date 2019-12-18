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
Helm4Rake.new(charts, contexts, 'monitoring')

manifests = %w[dind-monitor event-exporter]

desc 'kubectl apply'
task :apply do
  manifests.each do |i|
    sh "kubectl apply -f #{i}.yaml"
  end
end

desc 'kubectl delete'
task :remove do
  manifests.each do |i|
    sh "kubectl delete -f #{i}.yaml"
  end
end

desc 'deploy releases and resources'
task default: %i[install apply]

desc 'destroy releases and resources'
task destroy: %i[remove delete]
