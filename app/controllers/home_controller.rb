class HomeController < ApplicationController

  def index
    @testing = Prueba.all.map{|t| t.titulo}.join(', ')
  end
end