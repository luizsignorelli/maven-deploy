require "rexml/document"

class Pom
  def initialize(pom_file)
    @pom_file = File.new pom_file
    @pom = REXML::Document.new @pom_file
  end

  def modules 
    @pom.elements.to_a( "//module" ).collect { |m| m.text }
  end

  def project_name
    REXML::XPath.first( @pom, "//name" ).text 
  end
  
  def artifact_id
    REXML::XPath.first( @pom, "//project/artifactId" ).text 
  end

  def version
    REXML::XPath.first( @pom, "//version" ).text 
  end
  
  def release_version
    REXML::XPath.first( @pom, "//version" ).text.split('-')[0] 
  end

  def packaging
   package = REXML::XPath.first( @pom, "//packaging" )
   if package.nil?
     'jar'
   else
     package.text
   end
  end
  
  def final_name
   final_name = REXML::XPath.first( @pom, "//finalName" )
   return final_name.text unless final_name.nil?
   return "#{artifact_id}-#{version}"
  end
end
