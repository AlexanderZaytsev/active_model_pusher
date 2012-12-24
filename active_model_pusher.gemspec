# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_model/pusher/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Zaytsev"]
  gem.email         = ["alexander@say26.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_model_pusher"
  gem.require_paths = ["lib"]
  gem.version       = ActiveModel::Pusher::VERSION

  gem.add_development_dependency "rspec"

  gem.add_dependency 'activemodel', '>= 3.0'
end
