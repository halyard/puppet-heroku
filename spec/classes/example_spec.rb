require 'spec_helper'

describe 'heroku' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "heroku class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('heroku::params') }
          it { is_expected.to contain_class('heroku::install').that_comes_before('heroku::config') }
          it { is_expected.to contain_class('heroku::config') }
          it { is_expected.to contain_class('heroku::service').that_subscribes_to('heroku::config') }

          it { is_expected.to contain_service('heroku') }
          it { is_expected.to contain_package('heroku').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'heroku class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('heroku') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
