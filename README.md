# Importeur

A universal data import tool (a.k.a. ETL) 🙌

For now it's a single import job, made more composable and put into its own
place to be used in other projects. The vision is to add more things, so it can
handle more data sources and targets, eventually.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'importeur'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install importeur

## Usage

The center of it all is the `ETL` class. By inistantiating it with different
extractors, transformers and loaders, it can be whatever you want it to be:

```ruby
Importeur::ETL.new(
  extractor: my_extractor,
  transformer: my_transformer,
  loader: my_loader
)
```

All three only need to have a `call` method and, hence, can be simple Procs.
The extractor should return something enumerable, which is then iterated over
and each item passed into the transformer. The loader receives the enumerable
result of that. If the transformer returns `nil` or `false` that element is 
skipped and not received by the loader. The transformer can also return an 
array of elements, so a single element from extractor can be received as 
multiple elements by the loader.

So far a more or less generic `Extractor` exists.

```ruby
Importeur::Extractor.new(
  source,
  cursor,
  cursor_key
)
```

It takes as arguments a data source that needs to implement

* An `items` method, returning anything enumerable, as well as a
  `dataset_unique_id`, returning a unique ID for the current version of the
  dataset
* A cursor, that needs to implement `read(key)` and `write(key, value)` (e.g.
  `Rails.cache`) it makes the extractor return `nil` if there is no new data.
* A key (string), to be passed into the cursor.

An `ActiveRecordPostgresLoader` exists, that has a few very specific
dependencies. As the name suggests, it imports data into a Postgres database
using `ActiveRecord`. Additionally, the model used, needs to use
`acts_as_paranoid`.

Example use-cases can be found in the `spec/integration` directory.

## Development

In order to be able to run the tests, a Postgres database is needed. Having 
a PostgreSQL user with CREATEDB permission, create `.env.test` file with your 
DATABASE_URL configuration, for example:

`DATABASE_URL: 'postgres://user:password@localhost:5432/importeur_test'`

Then run `bundle exec rake create_test_db` to create the database and
`bundle exec rspec` to run tests.

We run `rake rubocop` to make sure, everything looks good.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/ad2games/importeur.
