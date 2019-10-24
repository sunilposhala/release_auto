require 'spec_helper'

describe 'metricbeat' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # context 'with defaults' do
      #  it { is_expected.to raise_error(Puppet::Error) }
      # end

      it { is_expected.to compile }

      describe 'metricbeat::config' do
        it do
          is_expected.to contain_file('metricbeat.yml').with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0644',
            path: '/etc/metricbeat/metricbeat.yml',
            validate_cmd: '/usr/share/metricbeat/bin/metricbeat -configtest -c %',
          )
        end

        describe 'with ensure = absent' do
          let(:params) { { 'ensure' => 'absent' } }

          it do
            is_expected.to contain_file('metricbeat.yml').with(
              ensure: 'absent',
              path: '/etc/metricbeat/metricbeat.yml',
              validate_cmd: '/usr/share/metricbeat/bin/metricbeat -configtest -c %',
            )
          end
        end

        describe 'with disable_configtest = true' do
          let(:params) { { 'disable_configtest' => true } }

          it do
            is_expected.to contain_file('metricbeat.yml').with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0644',
              path: '/etc/metricbeat/metricbeat.yml',
              validate_cmd: nil,
            )
          end
        end
      end

      describe 'metricbeat::install' do
        it { is_expected.to contain_package('metricbeat').with(ensure: 'present') }

        describe 'with ensure = absent' do
          let(:params) { { 'ensure' => 'absent' } }

          it { is_expected.to contain_package('metricbeat').with(ensure: 'absent') }
        end

        describe 'with package_ensure to a specific version' do
          let(:params) { { 'package_ensure' => '5.6.2-1' } }

          it { is_expected.to contain_package('metricbeat').with(ensure: '5.6.2-1') }
        end

        describe 'with package_ensure = latest' do
          let(:params) { { 'package_ensure' => 'latest' } }

          it { is_expected.to contain_package('metricbeat').with(ensure: 'latest') }
        end
      end

      context 'with elasticsearch output' do
        let(:params) do
          {
            'modules' => [{ 'module' => 'system', 'metricsets' => %w[cpu memory], 'period' => '10s' }],
            'outputs' => { 'elasticsearch' => { 'hosts' => ['http://localhost:9200'] } },
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_class('metricbeat::config').that_notifies('Class[metricbeat::service]') }
        it { is_expected.to contain_class('metricbeat::install').that_comes_before('Class[metricbeat::config]').that_notifies('Class[metricbeat::service]') }
        it { is_expected.to contain_class('metricbeat::service') }
      end

      context 'with manage_repo = false' do
        let(:params) do
          {
            'manage_repo' => false,
            'modules'     => [{ 'module' => 'system', 'metricsets' => %w[cpu memory], 'period' => '10s' }],
            'outputs'     => { 'elasticsearch' => { 'hosts' => ['http://localhost:9200'] } },
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_class('metricbeat::config').that_notifies('Class[metricbeat::service]') }
        it { is_expected.to contain_class('metricbeat::install').that_comes_before('Class[metricbeat::config]').that_notifies('Class[metricbeat::service]') }
        it { is_expected.to contain_class('metricbeat::service') }
      end

      context 'with ensure = absent' do
        let(:params) do
          {
            'ensure'  => 'absent',
            'modules' => [{ 'module' => 'system', 'metricsets' => %w[cpu memory], 'period' => '10s' }],
            'outputs' => { 'elasticsearch' => { 'hosts' => ['http://localhost:9200'] } },
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_class('metricbeat::config') }
        it { is_expected.to contain_class('metricbeat::install') }
        it { is_expected.to contain_class('metricbeat::service').that_comes_before('Class[metricbeat::install]') }
      end

      context 'with ensure = idontknow' do
        let(:params) { { 'ensure' => 'idontknow' } }

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'with service_ensure = thisisnew' do
        let(:params) { { 'ensure' => 'thisisnew' } }

        it { is_expected.to raise_error(Puppet::Error) }
      end
    end
  end
end
