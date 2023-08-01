# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "httprb_rspec/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Simon Toivo Telhaug"]
  gem.email         = ["bascule@gmail.com"]

  gem.description   = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    Include helpfull matchers for mathing statuscodes
  DESCRIPTION

  gem.summary       = "HTTP Rspec matchers"
  gem.homepage      = "https://github.com/httprb/httprb_rspec"
  gem.licenses      = ["MIT"]

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "httprb_rspec"
  gem.require_paths = ["lib"]
  gem.version       = HttprbRspec::VERSION

  gem.required_ruby_version = ">= 2.6"

  gem.add_runtime_dependency "http", ">= 4.0"

  gem.add_development_dependency "bundler", "~> 2.0"

  gem.metadata = {
    "source_code_uri"       => "https://github.com/httprb/httprb_rspec",
    "bug_tracker_uri"       => "https://github.com/httprb/httprb_rspec/issues",
    "changelog_uri"         => "https://github.com/httprb/httprb_rspec/blob/v#{HttprbRspec::VERSION}/CHANGES.md",
    "rubygems_mfa_required" => "true"
  }

  gem.license = "MIT"
end
