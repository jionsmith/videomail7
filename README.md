# VideoMail7

Videomail7 is basicly an email sending app, but the content of an email is an image of a recorded video. When u click on this image in the email, you get redirected in the browser to a page where u can view this video.

## Setup

This project uses Ruby 2.0.0, PostgreSQL, Redis and [Wowza](http://www.wowza.com/pricing/installer). Also the project use
[Panda Stream Service](http://www.pandastream.com/)


## Installation Guide

- Clone the repo
- Install the Install the components, if you're MacOSx would be something like this:

```bash
$ brew install postgres
$ brew install elasticsearch
$ brew install redis
```

- Setup required gems (if you're using RVM, I'd recommend to create a gemset):
    bundle install
- Configure your `config/database.yml`(Check `config/database.yml.example)
- Setup database with:

```ruby
  rake db:create #=> Creates the Database
  rake db:migrate # => Runs the migrations
```

- Launch a server:

``bundle exec rails s -p 3000``

- Launch the Queue System in another bash (The project is using [Sidekiq](http://sidekiq.org/)):

``bundle exec sidekiq``


### Note: About [Panda Stream](http://pandastream.com)

Panda Stream is a Third Party Service that encodes our videos, currently the project in dev mode need to be accessed in the internet  by Panda Stream in order to support its Notifications(see more [here](http://www.pandastream.com/docs/notifications)) internet, in order to securely expose a local web server to the internet and capture all Panda's traffic use [Ngrok](https://ngrok.com).

Open another bash a run:

`` ngrok -authtoken YOUR_TOKEN -subdomain=videomail7 3000``

## Deployment

This projects use [git-deploy](https://github.com/mislav/git-deploy) for
the deployments. In order to setup the deployments you should do
something like this

- Add The remote git repository `git remote remote-name staging ssh://server-host.com`
- Push your code to the new git remote `git push origin remote-name`

On every deploy, the default deploy/after_push script performs the following:

1. updates git submodules (if there are any);
1. runs`bundle install --deployment`
1. runs `rake db:migrate` if new migrations have been added;
1. clears cached CSS/JS assets in "public/stylesheets" and "public/javascripts"
1. restarts the web application
1. runs `whenever --update-crontab`

You can customize all this by editing generated scripts in the `deploy/` directory of your app.

Deployments are logged to `log/deploy.log` in your application's directory.

### Staging Server

**Git Remote**: "ssh://webservice@cube7.sevendevs.de:22202/var/www/videomail"

git remote add staging "ssh://webservice@cube7.sevendevs.de:22202/var/www/videomail"

**URL:** http://videomail.sevendevs.de


If you're setting up a first deployment please check the instruction for
setup the git hooks [here](https://github.com/mislav/git-deploy#initial-setup). The project also uses Environment variables please create a file with name `.env`,
you cand check the `env.example` file to see what variables are needed.


## Contributing

Make sure to add tests for it. This is important so It doesn't break it in a future version unintentionally.
Run the tests with:

```
bundle rake test
```

1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Merge Request


**Note:**

1. Check this guide for run you tests [The Guide to Testing Rails Applications](http://edgeguides.rubyonrails.org/testing.html)
1. Please keep this style in the code https://github.com/styleguide/ruby
