# Active Model Pusher

`ActiveModel::Pusher` makes using `Pusher` in your app much easier.
The purpose of this gem is to use the convention over configuration principle to reduce amount of code needed to interact with Pusher.

## Basic Usage
```ruby
@post = Post.create

PostPusher.new(@post).push!
```

This will push the following json to Pusher:

```json
channel: 'posts',
event: 'created',
data: { id: 1 }
```
Pusher operates with 4 things: channel, event, data and socket it. They will be discussed below.

## Channels
A `channel` value for a `Post` model will be one of the following:

1. `posts` - when a record has just been created
2. `posts-1` - for any other event: `updated`, `destroyed`, etc

### Customizing channels
Sometimes you might want to have a general channel name -  like `dashboard` - to which you will be pushing several models.

There are two ways to do that.

* Define a `channel` method in your model:
```ruby
class Post
  def channel
    "dashboard"
  end
end
```

* Define a `channel` method in your pusher:

```ruby
class PostPusher < ActiveModel::Pusher
  def channel(event)
    "dashboard"
  end
end
```

## Events
A newly generated pusher will look like this:

```ruby
# app/pushers/post_pusher.rb
class PostPusher < ActiveModel::Pusher
  events :created, :updated, :destroyed
end
```

The `events` method is a whitelist of events. If you try to push a non-whitelisted event, an exception will be raised:
```ruby
def publish
  @post = Post.find(1).publish!
  PostPusher.new(@post).push! :published
end
```
will result in InvalidEventError: 'Event :published is not allowed'.


The three default events can be guessed by the gem automatically, you don't actually have to specify them:

```ruby
def create
  @post = Post.create
  PostPusher.new(@post).push!
end
```
The gem will recognize that the record was just created and will set the event to `:created`

If you have custom actions in your controller - like `publish` - then you should specify the event manually:
```ruby
def publish
  @post = Post.find(1).publish!

  PostPusher.new(@post).push! :published
end
```

This will produce the following (given you whitelisted the `published` event in your pusher):
```json
channel: 'posts-1',
event: 'published',
data: { id: 1 }
```

### Customizing events

Customizing event names may be useful when you are using a general purpose channel.

Using the example from the `Customizing channels` section:

```ruby
class PostPusher < ActiveModel::Pusher
  def channel(event)
    "dashboard"
  end
end
class CommentPusher < ActiveModel::Pusher
  def channel(event)
    "dashboard"
  end
end
```

When we push two different models into the general channel:
```ruby
@post = Post.create
@comment = Comment.create

PostPusher.new(@post).push!
CommentPusher.new(@comment).push!
```

They both will be pushed with the same event `created`. Depending on your client-side architecture it might be fine, but sometimes you might want to have namespaced events: `post-created`, `comment-created`, etc.

You can achieve this by overriding the `event(event)` method in your pusher:

```ruby
class PostPusher < ActiveModel::Pusher
  def event(event)
    "post-#{event.underscore.dasherize}"
  end
end
```
This will format your events like `post-created` or `post-published`.

## Data
The `data` method simply serializes your record.

By default, it will try to serialize the record with the `active_model_serializers` gem.

If `active_model_serializers` is not used in your application, it will fallback to the `as_json` method on your record.

But seriously, just use `active_model_serializers`.

## Socket id
You can specify the socket id when calling the `push!` method:

```ruby
def create
  @post = Post.create
  PostPusher.new(@post).push! params[:socket_id]
end
```

If you need to specify an event as well, it should go first:
```ruby
def publish
  @post = Post.publish!
  PostPusher.new(@post).push! :published, params[:socket_id]
end
```
## Creating a new pusher
```
rails generate pusher Post created published
```

## Notice
This is sort of an alpha version, so things may break. If you have any ideas on improving the gem, you are very welcome to contribute.

## Installation

Add this line to your application's Gemfile:

    gem 'active_model_pusher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_pusher

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
