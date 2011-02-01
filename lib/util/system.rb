def mkdir(path)
  full_dir = ""
  path.split("/").each do |dir|
    unless File.exists?(full_dir+dir)
      system ("mkdir #{full_dir}#{dir}")
    end
    full_dir = "#{full_dir}#{dir}/"
  end
end
