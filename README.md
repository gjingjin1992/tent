# tent-rent

## TOOLS

### Rails ERD

We use [erd-gem](https://github.com/voormedia/rails-erd) to generate entity relationship diagrams. Run it with:
```
$ bundle exec erd --filetype=png --inheritance
```
Result (erd.png) is available in the project root dir.


## DEPENDENCIES

### Postgis

* on debian - `$ apt-get install postgis*`
* on mac it should be `$ brew install postgis`

After installing `activerecord-postgis-adapter` gem, don't forget run `$ rake db:gis:setup` in order to install postgis extension to the database.

### Graphviz

Install it only if you want to use `erd` tool.

* on debian - `$ sudo apt-get install graphviz`

### Imagemagick

[Paperclip] (https://github.com/thoughtbot/paperclip) dependency

* on debian - `$ sudo apt-get install imagemagick`


## Tasks

### Loading fake data

`$ rake db:load_fake_data`
