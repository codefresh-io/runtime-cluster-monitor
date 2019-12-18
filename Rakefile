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

desc 'kubectl apply'
task :apply do
  sh 'kubectl apply -f dind-monitor.yaml'
end

desc 'kubectl delete'
task :remove do
  sh 'kubectl delete -f dind-monitor.yaml'
end

desc 'deploy releases and resources'
task default: %i[install apply]

desc 'destroy releases and resources'
task destroy: %i[remove delete]
