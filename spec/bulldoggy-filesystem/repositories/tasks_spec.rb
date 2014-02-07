require './lib/bulldoggy-filesystem/repositories/tasks'

module BulldoggyFilesystem
  module Repositories
    describe Tasks do
      subject(:tasks) { described_class.new }
      let(:filename) { './tmp/test_tasks.yml' }
      let(:task) { Bulldoggy::Entities::Task.new('Prepare the coffee') }

      before do
        recreate_repository_file
        described_class.filename = filename
      end

      after { recreate_repository_file }

      describe '#save' do
        subject(:save) { tasks.save(task) }

        it 'saves the task' do
          expect {
            save
          }.to change {
            File.read(filename).size
          }
        end
      end

      describe '#all' do
        subject(:all) { tasks.all }

        context 'when there is tasks' do
          before do
            tasks.save(task)
          end

          it { expect(all).to be_kind_of(Array) }

          context 'the first task' do
            subject(:first_task) { all.first }

            it { should be_kind_of(Bulldoggy::Entities::Task) }

            its(:id) { should == task.id }
            its(:description) { should == task.description }
            its(:done) { should == task.done }
          end
        end

        context 'when there is no tasks' do
          it { expect(all).to eql([]) }
        end
      end

      describe '#find' do
        subject(:find) { tasks.find(task_id) }
        let(:task_id) { 1 }

        context 'when the task exist' do
          before do
            tasks.save(task)
          end

          it { expect(find.id).to eql(task.id) }
          it { expect(find.description).to eql(task.description) }
        end

         context 'when the tasks does not exist' do
           it { expect(find).to be_nil }
         end
      end

      describe '#delete' do
        subject(:delete) { tasks.delete(task_id_to_delete) }
        let(:task_id_to_delete) { second_task.id }
        let(:second_task) { Bulldoggy::Entities::Task.new('Take a ride') }

        before do
          tasks.save(task)
          tasks.save(second_task)
        end

        it 'deletes the task' do
          delete
          expect(tasks.all.map(&:id)).to_not include(task_id_to_delete)
        end

        it 'returns the deleted object' do
          expect(delete).to be_kind_of(Bulldoggy::Entities::Task)
        end

        it 'keeps the first task' do
          delete
          expect(tasks.all.map(&:id)).to include(task.id)
        end

        context 'when the task to delete does not exist' do
          let(:task_id_to_delete) { 53 }

          it { should be_nil }
        end
      end

      describe '#check' do
        subject(:check) { tasks.check(task_id) }
        let(:task_id) { task.id }

        before do
          tasks.save(task)
        end

        it 'marks a task as done' do
          check
          expect(tasks.find(task.id).done).to be_true
        end

        context 'when task does not exist' do
          let(:task_id) { 42 }
          it { should == :task_not_found }
        end
      end

      describe '#uncheck' do
        subject(:uncheck) { tasks.uncheck(task_id) }
        let(:task_id) { task.id }

        before do
          task.done = true
          tasks.save(task)
        end

        it 'marks a task as not done' do
          uncheck
          expect(tasks.find(task.id).done).to be_false
        end

        context 'when task does not exist' do
          let(:task_id) { 55 }
          it { should == :task_not_found }
        end
      end

      def recreate_repository_file
        Dir.mkdir('tmp/') unless File.exists?('tmp/')
        File.delete(filename) if File.exists?(filename)
        File.open(filename, 'w') {}
      end
    end
  end
end
