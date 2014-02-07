# Bulldoggy filesystem repository

This gem implements a filesystem strategy for repositories.
For more info, please check the [Bulldoggy project](https://github.com/bezelga/bulldoggy)

## Usage

Inside your app, configure a specific repository:

```ruby
require 'bulldoggy-filesystem'

BulldoggyFilesystem::Repositories::Tasks.filename = 'path/to/the/storage/file.yml' # Optional. Default is `./db/bulldoggy-tasks.yaml`
tasks_repository = BulldoggyFilesystem::Repositories::Tasks.new

Bulldoggy::Repository.register :task, tasks_repository
```

Check the [Bulldoggy Thor](https://github.com/philss/bulldoggy-thor) implementation that uses
this gem.

## Badges

[![Code Climate](https://codeclimate.com/github/philss/bulldoggy-filesystem.png)](https://codeclimate.com/github/philss/bulldoggy-filesystem)
