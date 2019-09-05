lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_google_calendar/version'

Gem::Specification.new do |spec|
  spec.name          = 'my_google_calendar'
  spec.version       = MyGoogleCalendar::VERSION
  spec.authors       = ['tabio']
  spec.email         = ['tabio.github@gmail.com']

  spec.summary       = %q{Googleカレンダー登録用のgem}
  spec.description   = %q{GoogleカレンダーAPIを利用}
  spec.homepage      = 'https://github.com/tabio'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://github.com/tabio'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tabio'
  spec.metadata['changelog_uri'] = 'https://github.com/tabio'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'google-api-client', '~> 0.11'
  spec.add_dependency 'googleauth'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
