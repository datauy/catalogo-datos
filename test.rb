require_relative "./inumet.rb"
require_relative "./catalogo.rb"

p "Inumet - Staring synchronization"

# Estaciones
estaciones_file = File.open('./data/inumet_estaciones.json', 'r+')
estaciones_in_file = estaciones_file.read()
estaciones = JSON.parse(estaciones_in_file)
# Variables
variables_file = File.open('./data/inumet_variables.json', 'r+')
variables_in_file = variables_file.read()
variables = JSON.parse(variables_in_file)

estaciones_ids = estaciones.map{|e| e['id']}
from = Date.yesterday.strftime('%Y%m%d 00:00')
to = Date.strftime('%Y%m%d 00:00')
variables.each do |v|
  p "Inumet - Processing variable: #{v['nombre']}"
  data = JSON.parse(get_datos(estaciones_ids, v['id'], from, to))
  p data.inspect
end
