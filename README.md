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

There are 4 properties you need to know about: Channel, Event, Data and Socket id.

## Channels
`channel` for `Post` model will be one of these:
1. `posts` - when a record has just been created
2. `posts-1` - for any other event: `updated`, `destroyed`, etc

### Customizing channels
Sometimes you might want to have a general channel like `dashboard` to which you will be pushing several models.

There are several ways to do that.

1. Define a `channel` method in your model:
```ruby
class Post
  def channel
    "dashboard"
  end
end
```

2. Define a `channel` method in your pusher:

```ruby
class PostPusher < ActiveModel::Pusher
  def channel(event)
    "dashboard"
  end
end
```

## Events
A generated pusher will look like this:

```ruby
# app/pushers/post_pusher.rb
class PostPusher < ActiveModel::Pusher
  events :created, :updated, :destroyed
end
```

The `events` method is a whitelist of events. If you try to push with a non-whitelisted event, an exception will be raised:
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

If you have custom actions in your controller, like `publish`, then you should specify the event manually:
```ruby
def publish
  @post = Post.find(1).publish!

  PostPusher.new(@post).push! :published
end
```

This will produce the following:
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
```

When we push two different models into the general channel:
```ruby
@post = Post.create
@comment = Comment.create

PostPusher.new(@post).push!
CommentPusher.new(@comment).push!
```

They both will be pushed with the same event `created`. Depending on your client-side architecture it might be fine, but sometimes you might want to have events namespaces: `post-created`, `comment-created`, etc.

You can achieve this by overriding the `event(event)` method in your pusher:

```ruby
class PostPusher < ActiveModel::Pusher
  def event(event)
    "post-#{event}"
  end
end
```
This will give you events like `post-created` or `post-published`.

## Data
The `data` method simply serializes your record.

By default, it will try to serialize it with the`active_model_serializers` gem.

If `active_model_serializers` is not used in your application, it will fallback to the `as_json` method on your record.

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


## Installation

Add this line to your application's Gemfile:

    gem 'active_model_pusher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_pusher

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
