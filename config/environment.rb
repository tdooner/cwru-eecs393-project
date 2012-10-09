# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ZombieGameEngine::Application.initialize!

# Load the engine, and instantiate it so it loads the plugins
require File.expand_path('../../lib/engine/engine.rb', __FILE__)

ENGINE = ZombieGame::Engine.new
