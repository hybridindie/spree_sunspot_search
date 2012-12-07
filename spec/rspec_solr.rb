RSpec.configure do |c|
  c.before :suite do
    module Sunspot
      def self.stub_session
        @sub_session ||= Sunspot::Rails::StubSessionProxy.new self.session
      end
    end

  end

  c.before :each do
    Sunspot.session = Sunspot.stub_session
    Sunspot.session = Sunspot.session.original_session if example.metadata[:solr]

    Sunspot.remove_all!
  end
end
