require 'spec_helper'

describe 'metricbeat::service' do
  it do
    is_expected.to contain_service('metricbeat').with(
      ensure: 'running',
      enable: true,
      hasrestart: true,
    )
  end

  describe 'with ensure = absent' do
    let(:params) { { 'ensure' => 'absent' } }

    it do
      is_expected.to contain_service('metricbeat').with(
        ensure: 'stopped',
        enable: false,
        hasrestart: true,
      )
    end
  end

  describe 'with service_has_restart = false' do
    let(:params) { { 'service_has_restart' => false } }

    it do
      is_expected.to contain_service('metricbeat').with(
        ensure: 'running',
        enable: true,
        hasrestart: false,
      )
    end
  end

  describe 'with service_ensure = disabled' do
    let(:params) { { 'service_ensure' => 'disabled' } }

    it do
      is_expected.to contain_service('metricbeat').with(
        ensure: 'stopped',
        enable: false,
        hasrestart: true,
      )
    end
  end

  describe 'with service_ensure = running' do
    let(:params) { { 'service_ensure' => 'running' } }

    it do
      is_expected.to contain_service('metricbeat').with(
        ensure: 'running',
        enable: false,
        hasrestart: true,
      )
    end
  end

  describe 'with service_ensure = unmanaged' do
    let(:params) { { 'service_ensure' => 'unmanaged' } }

    it do
      is_expected.to contain_service('metricbeat').with(
        ensure: nil,
        enable: false,
        hasrestart: true,
      )
    end
  end
end
