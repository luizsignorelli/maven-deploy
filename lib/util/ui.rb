module MavenDeploy
  module UI
    def UI.ask_for_module(modules)
      list_modules( modules )
      selected_module = -1
      while selected_module < 0 do 
        selected_module = select_module( modules )
      end
      return modules[ selected_module.to_i - 1 ]
    end
    
    def UI.ask_for_version(default_version)
      version = prompt_with_default default_version, "\nInforme a versão"
      return version
    end
   
    private

    def UI.prompt_with_default(default, label)
      var = Capistrano::CLI.ui.ask "#{label} [#{default}] : "
      if var.to_s.empty? 
        return default
      else 
        return var
      end
    end
    
    def UI.prompt(label)
        Capistrano::CLI.ui.ask "#{label}: "
    end

    def UI.select_module(modules)
      mod = prompt "\nInforme o modulo"
      return mod.to_i
    end
    
    def UI.list_modules(modules)
      modules.each_with_index do |m, i|
        puts "#{i+1} #{m}"
      end
    end
  end
end
