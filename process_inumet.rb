# process_inumet.rb
require_relative "./inumet.rb"
require_relative "./catalogo.rb"

p "Inumet - Staring synchronization"
catalogo = Catalogo.new(ENV["CATALOGO_KEY"])
inumet = Inumet.new(ENV["INUMET_USER"], ENV["INUMET_PASSWD"])
p "Inumet - Classes ready"
##### ESTACIONES ######
estaciones_json = inumet.get_estaciones()
estaciones_file = File.open('./data/inumet_estaciones.json', 'w')
estaciones_in_file = estaciones_file.read()
#update estaciones
if estaciones_json != estaciones_in_file
  p "Inumet - Updating ESTACIONES"
  ## TODO: Make backup?
  estaciones_file.write(estaciones)
  ## TODO: RESOURCE_ID??
  #catalogo.resource_update('res_id', 'CSV', estaciones_file)
  estaciones_file.close
end
##### VARIABLES ######
variables_json = inumet.get_variables()
variables_file = File.open('./data/inumet_variables.json', 'w')
variables_in_file = variables_file.read()
#update variables
if variables_json != variables_in_file
  p "Inumet - Updating VARIABLES"
  ## TODO: Make backup?
  variables_file.write(variables)
  ## TODO: RESOURCE_ID??
  #catalogo.resource_update('res_id', 'CSV', variables_file)
  variables_file.close
end

variables = JSON.parse(variables_json)
estaciones = JSON.parse(estaciones_json)

###### DATOS ######
estaciones_ids = estaciones.map{|e| e['id']}
from = Date.yesterday.strftime('%Y%m%d 00:00')
to = Date.strftime('%Y%m%d 00:00')
variables.each do |v|
  p "Inumet - Processing variable: #{v['nombre']}"
  data = JSON.parse(get_datos(estaciones_ids, v['id'], from, to))
  p data.inspect
end
