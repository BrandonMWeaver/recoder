require "./config/environment"

use Rack::MethodOverride
use SessionsController
use UserController
use PostController
run ApplicationController
