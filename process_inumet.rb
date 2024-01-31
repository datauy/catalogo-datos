# process_inumet.rb
require 'date'
require 'csv'
require_relative "./inumet.rb"
require_relative "./catalogo.rb"

p "Inumet - Staring synchronization"
#catalogo = Catalogo.new(ENV["CATALOGO_KEY"])
inumet = Inumet.new(ENV["INUMET_USER"], ENV["INUMET_PASSWD"])
p "Inumet - Classes ready"
##### ESTACIONES ######
estaciones_json = inumet.get_estaciones()
begin
  estaciones_file = File.open('./data/inumet_estaciones.json', 'r')
  estaciones_in_file = estaciones_file.read()
  estaciones_file.close
rescue
  estaciones_in_file = ''
end
#update estaciones
if estaciones_json.force_encoding('UTF-8') != estaciones_in_file  && !estaciones_json.nil?
  p "Inumet - Updating ESTACIONES"
  ## TODO: Make backup?
  File.write('./data/inumet_estaciones.json', estaciones_json)
  File.write("./data/metadata-inumet_estaciones.csv", Time.now.strftime('%Y-%m-%d %H:%M'))
  ## TODO: RESOURCE_ID??
  #catalogo.resource_update('res_id', 'CSV', estaciones_file)
end
p "Inumet - Processed ESTACIONES"
##### VARIABLES ######
variables_json = inumet.get_variables()
begin
  variables_file = File.open('./data/inumet_variables.json', 'r')
  variables_in_file = variables_file.read()
  variables_file.close
rescue
  variables_in_file = ''
end
#update variables
if variables_json != variables_in_file && !variables_json.nil?
  p "Inumet - Updating VARIABLES"
  ## TODO: Make backup?
  File.write('./data/inumet_variables.json', variables_json)
  File.write("./data/metadata-inumet_variables.csv", Time.now.strftime('%Y-%m-%d %H:%M'))
  ## TODO: RESOURCE_ID??
  #catalogo.resource_update('res_id', 'CSV', variables_file)
end
p "Inumet - Processed VARIABLES"
variables = JSON.parse(variables_json)
estaciones = JSON.parse(estaciones_json)
###### DATOS ######
estaciones_ids = estaciones.map{|e| e['id']}
to_date = Date.today.prev_day
to = to_date.strftime('%Y%m%d 23:59')

variables.each do |v|
  vslug = v['nombre'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  if !File.exists?("./data/metadata-inumet_#{vslug}.csv")
    from_date = Date.today.prev_day
  else
    from_date = Date.parse(File.read("./data/metadata-inumet_#{vslug}.csv"))
  end
  from = from_date.strftime('%Y%m%d 00:00') #'20230101 00:00'#
  # Create files if do not exists
  if !File.exists?("data/inumet_#{vslug}.csv")
    CSV.open("data/inumet_#{vslug}.csv", "wb") do |csv|
      csv << ['fecha', 'estacion_id', v['idStr']]
    end
  end
  # Create files if it is a new year
  if from_date.month == 1 && from_date.mday == 1
    #move previous files
    File.rename("data/inumet_#{vslug}.csv", "data/inumet_#{vslug}-#{from_date.year}.csv")
    CSV.open("data/inumet_#{vslug}.csv", "wb") do |csv|
      csv << ['fecha', 'estacion_id', v['idStr']]
    end
  end
  CSV.open("data/inumet_#{vslug}.csv", "a") do |csv|
    p "Inumet - Processing variable: #{v['nombre']}"
    api_data = inumet.get_datos(estaciones_ids, v['id'], from, to)
    if ( api_data.nil? )
      p "Inumet - API data is empty"
      next
    else
      data = JSON.parse(api_data)
      res = data["fechas"].map{ |j|
        {
        fecha: j,
        datos: []
        }
      }
      res_estaciones = data["estaciones"].map{|est| est["id"]}
      ei = 0
      data["observaciones"].first["datos"].each do |d|
        i = 0
        d.each do |dato|
          res[i][:datos] << {
            estacion_id: res_estaciones[ei],
            dato: dato
          }
          #CSV
          #csv << [res[i][:fecha], res_estaciones[ei], dato]
          i += 1
        end
        ei += 1
      end
      res.each do |date_arr|
        date_arr[:datos].each do |date_data|
          csv << [date_arr[:fecha], date_data[:estacion_id], date_data[:dato]]
        end
      end
      #Process metadata validation
      File.write("./data/metadata-inumet_#{vslug}.csv", Time.now.strftime('%Y-%m-%d %H:%M'))
    end
    #p res.inspect
  end
end
