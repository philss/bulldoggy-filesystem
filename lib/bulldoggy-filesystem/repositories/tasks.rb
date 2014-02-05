require 'bulldoggy'
require 'yaml/store'

module BulldoggyFilesystem
  module Repositories
    class Tasks
      def self.filename=(filename)
        @@filename = filename
      end

      def self.filename
        @@filename || './db/bulldoggy-tasks.yaml'
      end

      def initialize
        @store = YAML::Store.new(self.class.filename)
      end

      def all
        {}.tap do |tasks|
          @store.transaction do
            @store.fetch(:tasks, []).each do |task|
              tasks[task.id] = task
            end
          end
        end
      end

      def save(task)
        task.id = find_last_id + 1

        @store.transaction do
          @store[:tasks] ||= []
          @store[:tasks] << task
        end

        task
      end

      def find(task_id)
        @store.transaction do
          tasks = Array(@store[:tasks])
          detect_task_by_id(tasks, task_id)
        end
      end

      def delete(task_id)
        @store.transaction do
          deleted = @store.fetch(:tasks).reject! {|task| task.id == task_id }
          Array(deleted).first
        end
      end

      def check(task_id)
        raise NotImplementedError
      end

      def uncheck(task_id)
        raise NotImplementedError
      end

      private

      def find_last_id
        @store.transaction do
          tasks = Array(@store[:tasks])
          task_with_max_id = tasks.max_by(&:id)
          task_with_max_id ? task_with_max_id.id : 0
        end
      end

      def detect_task_by_id(tasks, task_id)
        tasks.detect{ |task| task.id == task_id }
      end
    end
  end
end
