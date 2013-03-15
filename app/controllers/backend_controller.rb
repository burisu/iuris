class BackendController < ApplicationController
  before_filter :authenticate_user!
end
