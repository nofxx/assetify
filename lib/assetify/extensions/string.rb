#
# Adapted ptools - http://rdoc.info/gems/ptools/1.2.1/File.binary%3F
#
class String
  def binary?
    # s = (File.read(file, File.stat(file).blksize) || "").split(//)
    s = (self[0..4096].force_encoding('binary') || '') # .split(//)
    ratio = s.gsub(/\d|\w|\s|[-~\.]/, '').size / s.size.to_f
    # if Opt[:debug]
    #   print "Detecting #{s}"
    #   puts "Ratio #{ratio}"
    # end
    ratio > 0.3
  end
end
