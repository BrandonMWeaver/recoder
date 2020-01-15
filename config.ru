require "./config/environment"

use Rack::MethodOverride
use UserController
use PostController
run ApplicationController
