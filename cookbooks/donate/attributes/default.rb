# Enable the "donate" role
default[:accounts][:users][:donate][:status] = :role

# Use prefork as PHP is to dumb for anything else
override[:apache][:mpm] = "prefork"
