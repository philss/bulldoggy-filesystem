require 'bulldoggy'
require 'yaml/store'

module BulldoggyFilesystem
  module Repositories
    class Tasks
      def self.filename=(filename)
        @@filename = filename
      end

      def self.filename
        @@filename ||= './db/bulldoggy-tasks.yaml'
      end

      def initialize
        @store = YAML::Store.new(self.class.filename)
      end

      def all
        @store.transaction do
          tasks
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
          detect_task_by_id(task_id)
        end
      end

      def delete(task_id)
        @store.transaction do
          deleted = tasks.select {|task| task.id == task_id }
          @store[:tasks] = tasks - deleted
          Array(deleted).first
        end
      end

      def check(task_id)
        @store.transaction do
          set_task_status(task_id, true)
        end
      end

      def uncheck(task_id)
        @store.transaction do
          set_task_status(task_id, false)
        end
      end

      private

      def find_last_id
        @store.transaction do
          task_with_max_id = tasks.max_by(&:id)
          task_with_max_id ? task_with_max_id.id : 0
        end
      end

      def set_task_status(task_id, done)
        task = detect_task_by_id(task_id)
        if task
          task.done = done
          task
        else
          :task_not_found
        end
      end

      def detect_task_by_id(task_id)
        tasks.detect{ |task| task.id == task_id }
      end

      def tasks
        @store.fetch(:tasks, [])
      end
    end
  end
end
