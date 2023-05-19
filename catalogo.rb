# catalogo.rb
require 'net/http'
require 'openssl'
require 'json'

class Catalogo
  URL = 'https://test.catalogodatos.gub.uy'

  def initialize(api_key)
    @apiKey = api_key
  end

  # Crear conjunto de datos
  def package_create
    uri = URI("#{URL}/api/3/action/package_create")
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/x-www-form-urlencoded'
    req['Authorization'] = @apiKey

    r_parameters = {
      name: "pruebacreardatasetapicurl",
      title: "Prueba crear dataset API CURL",
      private: "true",
      author: "Catálogo Datos",
      author_email: "catalogodatos@agesic.gub.uy",
      maintainer: "Catálogo Datos",
      maintainer_email: "catalogodatos@agesic.gub.uy",
      type: "dataset",
      license_id: "odc-uy",
      notes: "Prueba crear dataset NOTAS CURL",
      version": "2.0",
      tag_string: "Ancap, Transparencia Activa",
      owner_org": "ancap",
      update_frequency": "-1",
      groups: [{ name: "transparencia"}]
    }
    req.body = r_parameters.to_json

    req_options = {
    use_ssl: uri.scheme == 'https',
    verify_mode: OpenSSL::SSL::VERIFY_NONE
  }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(req)
    end
  end

  # Actualizar conjunto de datos
  def package_update
    uri = URI("#{URL}/api/3/action/package_update")
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/x-www-form-urlencoded'
    req['Authorization'] = @apiKey

    req.body = "{\n        \"id\": \"pruebacreardatasetapicurl\",\n        \"title\": \"Prueba actualizar dataset API CURL\",\n        \"private\": \"false\",\n        \"author\": \"Catálogo Datos\",\n        \"author_email\": \"catalogodatos@agesic.gub.uy\",\n        \"maintainer\": \"Catálogo Datos\",\n        \"maintainer_email\": \"catalogodatos@agesic.gub.uy\",\n        \"notes\": \"Prueba crear dataset NOTAS CURL\",\n        \"version\": \"2.1\"\n    }\n"

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Eliminar recurso
  def package_delete
    uri = URI("#{URL}/api/3/action/package_delete")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = @apiKey

    req.set_form(
      [
        [
          'id',
          'pruebacreardatasetapicurl'
        ]
      ],
      'multipart/form-data'
    )

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Obtener conjunto de datos
  def package_show
    uri = URI("#{URL}/api/3/action/package_show")
    params = {
      :id => 'pruebacreardatasetapicurl',
    }
    uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = @apiKey

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Crear recurso con URL
  def resource_create
    uri = URI("#{URL}/api/3/action/resource_create")
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/x-www-form-urlencoded'
    req['Authorization'] = @apiKey

    req.body = "{\n        \"package_id\": \"pruebacreardatasetapicurl\",\n        \"name\": \"Recurso URL creado vía API CURL\",\n        \"url\": \"https://people.sc.fsu.edu/~jburkardt/data/csv/cities.csv\",\n        \"description\": \"Descripción de URL cities CURL\",\n        \"format\": \"CSV\"\n    }\n"

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Crear recurso adjuntando archivo
  def resource_create
    uri = URI("#{URL}/api/3/action/resource_create")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = @apiKey

    req.set_form(
      [
        [
          'package_id',
          'pruebacreardatasetapicurl'
        ],
        [
          'upload',
          File.open('airtravel.csv')
        ],
        [
          'format',
          'CSV'
        ],
        [
          'name',
          'Recurso file creado vía API CURL'
        ],
        [
          'description',
          'Descripción de recurso air travel'
        ]
      ],
      'multipart/form-data'
    )

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Actualizar recurso adjuntando archivo
  def resource_update
    uri = URI("#{URL}/api/3/action/resource_update")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = @apiKey

    req.set_form(
      [
        [
          'format',
          'CSV'
        ],
        [
          'name',
          'Recurso file actualizado vía API CURL'
        ],
        [
          'description',
          'Descripción de recurso country'
        ],
        [
          'id',
          File.open('ID_RESOURCE>')
        ],
        [
          'upload',
          File.open('countries.csv')
        ]
      ],
      'multipart/form-data'
    )

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end

  # Eliminar recurso
  def resource_delete
    uri = URI("#{URL}/api/3/action/resource_delete")
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = @apiKey

    req.set_form(
      [
        [
          'id',
          File.open('ID_RESOURCE>')
        ]
      ],
      'multipart/form-data'
    )

    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  end
end
