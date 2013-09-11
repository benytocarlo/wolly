# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "newrelic_rpm"
  s.version = "3.6.7.152"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Clark", "Sam Goldstein", "Michael Granger", "Jonan Scheffler", "Ben Weintraub"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDODCCAiCgAwIBAgIBADANBgkqhkiG9w0BAQUFADBCMREwDwYDVQQDDAhzZWN1\ncml0eTEYMBYGCgmSJomT8ixkARkWCG5ld3JlbGljMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTEzMDIxMjE5MDcwN1oXDTE0MDIxMjE5MDcwN1owQjERMA8GA1UEAwwI\nc2VjdXJpdHkxGDAWBgoJkiaJk/IsZAEZFghuZXdyZWxpYzETMBEGCgmSJomT8ixk\nARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJyYRvlk1XUo\n8JhWQcE/v6RmpK//JbeKvTKnmWVUKz5oTDSOg/LKEhzChpJJVSOMJHCxd4OoxkIN\npjQF5U2af1m5ONeN1j4p4MujbwNeqxsJmixGLK/BZ9xTnbpYAa6xCRN1UfEcu3O9\njjLHX3c63ghldwRBn/c2ZD6anMtDeq3C5MLiycFs9h7JXOa3cTTHLZknkYIoHMKN\nEFri5zlks50lbeaVvFRm4IMrYWRsEwzLZWaMOy68BVZe0UlBBKSMnzJfWkbdRRcm\nxqu7viu4hrrCGjUmdHKnl6tf7BY7wqQyKjj+O5DhayKmKRuQcEX8QVnsM+ayqiVU\nEtMiwNScUnsCAwEAAaM5MDcwCQYDVR0TBAIwADAdBgNVHQ4EFgQUOauaMsU0Elp6\nhiUisj4l63ZunSUwCwYDVR0PBAQDAgSwMA0GCSqGSIb3DQEBBQUAA4IBAQAuwrHh\njOjIfAQoEbGakiwHTeImqmC1EjBEWb1+U+rC2OcsSQ3+2Q0mGq2u3lAphAeLa6i5\nWXb5OdQqZY2aI7NgMxRG98/+TcIlAT8tDR0e6/+QBlBuDXP3YI5Nuhp5U4LEvghr\njEPaEo0AFPc1JpSO/zKmktU+e9VRAE+q55gLthP8fe0uZvtGUn0KgDbXJyOuGlHF\nJ93N937OcyA2rD8gR1qkr3/0/we1dwLZnL6kN4p8nGzPgXZgOHsmTdYZ2ryYowtb\nKc9+v+QxnbZYpu2IaPXOvm3T8G4O6qZvhnLh/Uien++Dj8eFBecTPoM8pVjK3ph5\nn/EwuZCcE6ghtCCM\n-----END CERTIFICATE-----\n"]
  s.date = "2013-09-05"
  s.description = "New Relic is a performance management system, developed by New Relic,\nInc (http://www.newrelic.com).  New Relic provides you with deep\ninformation about the performance of your web application as it runs\nin production. The New Relic Ruby Agent is dual-purposed as a either a\nGem or plugin, hosted on\nhttp://github.com/newrelic/rpm/\n"
  s.email = "support@newrelic.com"
  s.executables = ["mongrel_rpm", "newrelic_cmd", "newrelic", "nrdebug"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.files = ["bin/mongrel_rpm", "bin/newrelic_cmd", "bin/newrelic", "bin/nrdebug", "CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.homepage = "http://www.github.com/newrelic/rpm"
  s.post_install_message = "# New Relic Ruby Agent Release Notes #\n\n## v3.6.7 ##\n\n* Resque-pool support\n\n  Resque processes started via the resque-pool gem weren't recognized by the\n  Ruby agent. The agent now starts correctly in those worker processes.\n\n* Environment-based configuration\n\n  All settings in newrelic.yml can now be configured via environment variables.\n  See https://newrelic.com/docs/ruby/ruby-agent-configuration for full details.\n\n* Fix compatibility issues with excon and curb instrumentation\n\n  This release of the agent fixes a warning seen under certain circumstances\n  with the excon gem (most notably, when excon was used by fog), as well as\n  a bug with the curb instrumentation that conflicted with the  feedzirra gem.\n\n* Allow license key to be set by Capistrano variables\n\n  A license key can be passed via a Capistrano variable where previously it\n  could only be in newrelic.yml. Thanks Chris Marshall for the contribution!\n\n* Make HTTP client instrumentation aware of \"Host\" request header\n\n  If a \"Host\" header is set explicitly on an HTTP request, that hostname will\n  be used for external metrics. Thanks Mislav Marohni\u{107} for the contribution!\n\n* Fix ActiveSupport::Concern warnings with MethodTracer\n\n  Including NewRelic::Agent::MethodTracer in a class using Concerns could cause\n  deprecation warnings. Thanks Mike Po\u{142}tyn for the contribution!\n\n* Fix Authlogic constant name\n\n  Code checking for the Authlogic module was using in the wrong case. Thanks\n  Dharam Gollapudi for the contribution!\n\nSee https://github.com/newrelic/rpm/blob/master/CHANGELOG for a full list of\nchanges.\n"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "New Relic Ruby Agent"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "New Relic Ruby Agent"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["= 10.1.0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.7.5"])
      s.add_development_dependency(%q<mocha>, ["~> 0.13.0"])
      s.add_development_dependency(%q<sdoc-helpers>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_development_dependency(%q<rails>, ["~> 3.2.13"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<sequel>, ["~> 3.46.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-test>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    else
      s.add_dependency(%q<rake>, ["= 10.1.0"])
      s.add_dependency(%q<minitest>, ["~> 4.7.5"])
      s.add_dependency(%q<mocha>, ["~> 0.13.0"])
      s.add_dependency(%q<sdoc-helpers>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_dependency(%q<rails>, ["~> 3.2.13"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<sequel>, ["~> 3.46.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-test>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    end
  else
    s.add_dependency(%q<rake>, ["= 10.1.0"])
    s.add_dependency(%q<minitest>, ["~> 4.7.5"])
    s.add_dependency(%q<mocha>, ["~> 0.13.0"])
    s.add_dependency(%q<sdoc-helpers>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 2.4.2"])
    s.add_dependency(%q<rails>, ["~> 3.2.13"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<sequel>, ["~> 3.46.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-test>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
  end
end
