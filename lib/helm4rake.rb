# frozen_string_literal: true

require 'yaml'
require 'rake/tasklib'
require_relative 'template'

# Initialize Rake tasks to deploy Helm projects.
#
# They mostly depend on enviroment varible named `env`
#
# Helm jobs also use optional `args` env. variable.
class Helm4Rake < ::Rake::TaskLib
  # Define Rake tasks taken:
  #
  # * array of charts (items required to have `:chart`, `:release` and `:values`; `:template` is optional)
  # * array of contexts (items required to have `:name`, `:project`, `:cluster` and `:zone`)
  # * k8s namespace (string)
  def initialize(charts, contexts, namespace)
    @charts = charts
    @contexts = contexts
    @namespace = namespace
    @env_dir = 'env'

    context_task
    helm_tasks
    sops_tasks
    template_tasks
  end

  private

  def context_task
    task :context do
      success = false
      @contexts.each do |i|
        next unless ENV['env'] == i[:name]

        context_gks(i) if i[:project]
        success = true
        break
      end
      abort "Usage: rake install|delete env=#{@contexts.map { |i| i[:name] }.join('|')}" unless success
    end
  end

  def context_gks(context)
    sh "gcloud container clusters get-credentials #{context[:cluster]}"\
    " --zone #{context[:zone]} --project #{context[:project]}"
  end

  def helm_tasks
    helm_task_install
    helm_task_delete
  end

  def helm_task_install
    task default: :install
    desc 'helm upgrade -i'
    task install: %i[context template] do
      @charts.each do |i|
        sh "helm -f #{i[:values]} upgrade #{i[:release]} #{i[:chart]} --namespace #{@namespace} -i #{ENV['args']}"
      end
    end
  end

  def helm_task_delete
    task destroy: :delete
    desc 'helm delete'
    task delete: :context do
      @charts.each do |i|
        sh "helm delete --purge #{i[:release]} #{ENV['args']}"
      end
    end
  end

  def sops_tasks
    sops_task_encrypt
    sops_task_decrypt
  end

  def sops_task_encrypt
    desc 'sops -e'
    task :encrypt do
      if File.exist? "#{@env_dir}/#{ENV['env']}_raw.yaml"
        sh "sops -e #{@env_dir}/#{ENV['env']}_raw.yaml > #{@env_dir}/#{ENV['env']}.yaml"
        rm "#{@env_dir}/#{ENV['env']}_raw.yaml"
      end
    end
  end

  def sops_task_decrypt
    desc 'sops -d'
    task :decrypt do
      if File.exist? "#{@env_dir}/#{ENV['env']}.yaml"
        sh "sops -d #{@env_dir}/#{ENV['env']}.yaml > #{@env_dir}/#{ENV['env']}_raw.yaml"
      end
    end
  end

  def template_tasks
    template_task_render
    template_task_clean
  end

  def template_task_render
    task :template do
      values = YAML.safe_load(`sops -d #{@env_dir}/#{ENV['env']}.yaml`)
      @charts.each do |i|
        next unless i[:template]

        template = Template.new(File.read(i[:template])).result(values)
        File.open(i[:values], 'w') do |f|
          f.write template
        end
      end
    end
  end

  def template_task_clean
    task :clean do
      @charts.each do |i|
        File.delete i[:values] if i[:template]
      end
    end
    # auto-clean temp files
    Rake::Task[:install].enhance do
      Rake::Task[:clean].invoke
    end
  end
end
