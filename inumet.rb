# inumet.rb
require 'net/http'
require 'json'

class Inumet
  def initialize(user, pass)
    @token = self.login(user, pass)
    rise "Usuario o password inválidos" if @token.nil?
  end

  #login
  def login
    uri = URI('https://api.inumet.gub.uy/sesiones/login')
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/json'
    req['accept'] = 'text/plain'

    req.body = {
      'userId' => user,
      'password' => pass
    }.to_json

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
    if res.is_a?(Net::HTTPSuccess)
      return res.body
    end
    return
  end

  #check session
  #ERROR DA ERROR
  def check_session
    uri = URI('https://api.inumet.gub.uy/sesiones/sesion_activa')
    req = Net::HTTP::Get.new(uri)
    req['accept'] = '*/*'
    req['x-access-token'] = @token

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  #Get estaciones
  def get_estaciones
    uri = URI('https://api.inumet.gub.uy/estaciones')
    req = Net::HTTP::Get.new(uri)
    req['accept'] = 'application/json'
    req['x-access-token'] = @token

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  #Get variables
  def get_variables
    uri = URI('https://api.inumet.gub.uy/variables')
    req = Net::HTTP::Get.new(uri)
    req['accept'] = 'application/json'
    req['x-access-token'] = @token

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  #{ "mensaje": "No tiene permisos para acceder a '/alertas_incendios/'"}
  def get_datos(estaciones, variables, from, to)
    uri = URI('https://api.inumet.gub.uy/datos')
    params = {
      :fechaDesde => from, #'2023-01-01 00:00',
      :fechaHasta => to,
      :idsEstaciones => estaciones,#['159', '39'],
      :idsVariables => variables,#['159', '39'],
    }
    uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(uri)
    req['accept'] = 'application/json'
    req['x-access-token'] = @token

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end
end
