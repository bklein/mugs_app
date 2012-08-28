require 'daemons';

daemon = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'daemon.rb'))
Daemons.run(daemon)


