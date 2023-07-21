require "uri"
require "net/http"
require "json"

url = URI("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=AdgrHCRdwzAxVn9cTu99JyUPtajTgmb2HRiRzT0F
")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)

hash_respuesta = JSON.parse(response.read_body)

def buid_web_page(data)
  html =
  "<html>
    <head>
    </head>
    <body>
      <ul>"
  data["photos"].each do |photo|
  html= html+ "<li><img src='#{photo["img_src"]}' alt='' width='300' height='300'></li>\n"
  end
html+=
  "</ul>
  </body>
  </html>"
  File.write('nasa.html', html)
end

def photos_count(data)
  conteo_camaras = Hash.new(0)

  data['photos'].each do |photo|
    camara = photo["camera"]["name"]
    conteo_camaras[camara] += 1
  end

  conteo_camaras.each do |camara, cantidad|
    puts "Cámara '#{camara}' se utilizó #{cantidad} veces."
  end
end


buid_web_page(hash_respuesta)
photos_count(hash_respuesta)
