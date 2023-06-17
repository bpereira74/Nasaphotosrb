require 'uri'
require 'net/http'
require 'json'

# Requerimiento 2: método llamado buid_web_page que reciba el hash de respuesta con todos los datos y construya una página web.
def build_web_page(_all_data)
  api_key = '32p097To448m8q2kOjg2LHNH74uFeCMHV2ik9uFg'
  url = URI("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=#{api_key}")
  # la variable https usa la libreria URI, que hace un nueva conexion
  https = Net::HTTP.new(url.host, url.port)
  # autenticacion
  https.use_ssl = true

  # Requerimiento 1:Crear el método request que reciba una url y retorne el hash con los resultados
  # se realiza un request y un nuevo llamado por medio de GET
  request = Net::HTTP::Get.new(url)
  # se obtiene la respuesta en una variable, a traves del metodo request y se guarda
  response = https.request(request)
  # puts response.read_body
  # Analizar la respuesta JSON obtenida del cuerpo de la respuesta
  @all_data = JSON.parse(response.body)
  puts @all_data.class

  photos = @all_data['photos'].map { |x| x['img_src'] }
  f = File.new('nasafotos.html', 'w+')
  f.write('<p>A continuación, verás 25 fotos del planeta  Marte,tomadas por distintas camaras<p>?n')
  f.write("<html>\n<head>\n</head>\n<body>\n<ul>\n")
  photos.each do |photo|
    f.write("\n\t<li><img src='#{photo}'><li>")
  end
  f.write("\n</ul>\n</body>\n</html>")
end
build_web_page(@all_data)
def photos_count(_all_data)
  @all_data['photos'].map { |x| x['camera']['name'] }.group_by { |x| x }.map { |k, v| [k, v.count] }
end
puts('A continuación, el numero de fotos de Marte, asociadas a cada camara')
print photos_count(@all_data).to_h
