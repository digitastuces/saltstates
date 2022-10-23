# frozen_string_literal: true

daemons = %w[salt-master.service salt-api.service]

task :restart_daemon do
  on roles(:all) do
    daemons.each do |daemon|
      execute "sudo systemctl restart #{daemon}"
    end
  end
end
