require 'spec_helper'

describe 'senlin::db' do
  shared_examples 'senlin::db' do
    context 'with default parameters' do
      it { should contain_class('senlin::deps') }

      it { should contain_oslo__db('senlin_config').with(
        :connection              => 'sqlite:////var/lib/senlin/senlin.sqlite',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :db_max_retries          => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :mysql_enable_ndb        => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection              => 'mysql+pymysql://senlin:senlin@localhost/senlin',
          :database_connection_recycle_time => '3601',
          :database_db_max_retries          => '-1',
          :database_max_retries             => '11',
          :database_retry_interval          => '11',
          :database_max_pool_size           => '11',
          :database_max_overflow            => '21',
          :database_pool_timeout            => '21',
          :mysql_enable_ndb                 => true,
        }
      end

      it { should contain_class('senlin::deps') }

      it { should contain_oslo__db('senlin_config').with(
        :connection              => 'mysql+pymysql://senlin:senlin@localhost/senlin',
        :connection_recycle_time => '3601',
        :db_max_retries          => '-1',
        :max_pool_size           => '11',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '21',
        :pool_timeout            => '21',
        :mysql_enable_ndb        => true,
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'senlin::db'
    end
  end
end
