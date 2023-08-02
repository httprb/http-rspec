# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "http_rspec/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Simon Toivo Telhaug"]
  gem.email         = ["bascule@gmail.com"]

  gem.description   = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    Include helpfull matchers for mathing statuscodes
  DESCRIPTION

  gem.summary       = "HTTP Rspec matchers"
  gem.homepage      = "https://github.com/httprb/http-rspec"
  gem.licenses      = ["MIT"]

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "http-rspec"
  gem.require_paths = ["lib"]
  gem.version       = HttpRspec::VERSION

  gem.required_ruby_version = ">= 3.0"

  gem.add_runtime_dependency "http", ">= 4.0"

  gem.metadata = {
    "source_code_uri"       => "https://github.com/httprb/http-rspec",
    "bug_tracker_uri"       => "https://github.com/httprb/http-rspec/issues",
    "changelog_uri"         => "https://github.com/httprb/http-rspec/blob/v#{HttpRspec::VERSION}/CHANGES.md",
    "rubygems_mfa_required" => "true"
  }

  gem.license = "MIT"
end
