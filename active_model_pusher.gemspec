# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_model/pusher/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Zaytsev"]
  gem.email         = ["alexander@say26.com"]
  gem.description   = %q{Making it easy to use Pusher with your models}
  gem.summary       = %q{Push with one line of code!}
  gem.homepage      = "https://github.com/AlexanderZaytsev/active_model_pusher"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_model_pusher"
  gem.require_paths = ["lib"]
  gem.version       = ActiveModel::Pusher::VERSION

  gem.add_dependency 'activemodel', '>= 3.0'
  gem.add_dependency 'pusher'
  gem.add_development_dependency "rspec"
end
