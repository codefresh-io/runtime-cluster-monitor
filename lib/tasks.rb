# frozen_string_literal: true

desc 'kubectl apply'
task :apply do
  MANIFESTS.each do |i|
    i = File.join(BASE_DIR, i) if defined? BASE_DIR
    sh "kubectl apply -n #{NAMESPACE} -f #{i}.yaml"
  end
end

desc 'kubectl delete'
task :remove do
  MANIFESTS.each do |i|
    i = File.join(BASE_DIR, i) if defined? BASE_DIR
    sh "kubectl delete -n #{NAMESPACE} -f #{i}.yaml"
  end
end

desc 'deploy releases and resources'
task default: %i[install apply]

desc 'destroy releases and resources'
task destroy: %i[remove delete]
