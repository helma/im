require 'fileutils'
require 'json'
@imagedir = "/home/ch/images/art/images"
JSON.parse(`zsh -c "exiftool -j -fast2 -CreateDate -Keywords #{@imagedir}/**/"`).each do |t|
  file =t["SourceFile"]
  json = File.join(ENV['HOME'],".local","am",file).sub(File.extname(file),'.json')
  FileUtils.mkdir_p File.dirname(json)
  File.open(json,"w+"){|f| f.puts t["Keywords"].to_json}
end
