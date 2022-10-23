# frozen_string_literal: true

daemons = %w[salt-master salt-api]

task :restart_daemon do
  on roles(:all) do
    daemons.each do |daemon|
      execute "sudo /bin/systemctl restart #{daemon}"
    end
  end
end
