# README


# Requirements

```
Ruby 3.3
Rails 8.0.1
Sidekiq
Redis
MySql
```

Before starting, make sure that the MySql and Redis clients are installed and running on the machine.

# Installation

1. Copy config/database.sample.yml to config/database.yml and provide your MySql client username and password

    ```
    cp config/database.sample.yml config/database.yml
    ```

2. Setup database

    ```
    rails db:create
    rails db:migrate
    ```

3. Run rails server

    ```
    bundle exec rails s
    ```

4. Run sidekiq

    ```
    bundle exec sidekiq
    ```


# Usage

1. Run linter

    ```
    bundle exec rubocop
    ```

2. Run tests

    ```
    bundle exec rspec
    ```

3. Feel free to use Postman collection: companies-api.postman_collection.json

    When using csv controller remember to add file in Body -> set key named 'file' -> change type to File -> add csv
