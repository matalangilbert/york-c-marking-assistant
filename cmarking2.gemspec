Gem::Specification.new do |s|
  s.name = "yorkcmarker"  # i.e. visualruby.  This name will show up in the gem list.
  s.version = "2.2.3"  # i.e. (major,non-backwards compatable).(backwards compatable).(bugfix)
	s.add_dependency "vrlib", ">= 0.0.1"
	s.add_dependency "gtk2", ">= 0.0.1"
	s.add_dependency "require_all", ">= 0.0.1"
	s.add_dependency "prawn"
	s.add_dependency "json"
	s.has_rdoc = false
  s.authors = ["Mat Alan Gilbert"]
  s.email = "matalangilbert@gmail.com" # optional
  s.summary = "A marking assistant for the University of York Introduction to C course." # optional
  s.homepage = "https://github.com/freefallertam/york-c-marking-assistant"  # optional
  s.description = "A marking assistant for the York University Introduction to C course. No official association with the University of York." # optional
	s.executables = ['yorkcmarker']  # i.e. 'vr' (optional, blank if library project)
	s.default_executable = ['yorkcmarker']  # i.e. 'vr' (optional, blank if library project)
	s.bindir = ['.']    # optional, default = bin
	s.require_paths = ['.']  # optional, default = lib
	s.files = `git ls-files`.split("\n")
	s.rubyforge_project = "nowarning" # supress warning message
end
