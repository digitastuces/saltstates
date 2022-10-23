# frozen_string_literal: true

task :install_formulas do
  on roles(:all) as 'root' do
    execute "#{fetch(:root_saltstates_dir)}/bin/install_formulas.sh"
  end
end
