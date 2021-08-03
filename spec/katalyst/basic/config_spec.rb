# frozen_string_literal: true

RSpec.describe Katalyst::Basic::Auth::Config do # rubocop:disable Metrics/BlockLength
  subject { described_class.new }

  def with_environment(name, value)
    orig      = ENV[name]
    ENV[name] = value
    yield
    ENV[name] = orig
  end

  let(:all_env_settings) do
    %w[
      KATALYST_BASIC_AUTH_ENABLED
      KATALYST_BASIC_AUTH_USER
      KATALYST_BASIC_AUTH_PASS
    ]
  end

  it "sets username from environment" do
    with_environment("KATALYST_BASIC_AUTH_USER", "user") do
      expect(subject.username).to eq "user"
    end
  end

  it "sets password from environment" do
    with_environment("KATALYST_BASIC_AUTH_PASS", "pass") do
      expect(subject.password).to eq "pass"
    end
  end

  it "can be enabled from the environment" do
    with_environment("KATALYST_BASIC_AUTH_ENABLED", "true") do
      expect(subject.enabled?).to be_truthy
    end
  end

  it "can be disabled from the environment" do
    with_environment("KATALYST_BASIC_AUTH_ENABLED", "false") do
      expect(subject.enabled?).to be_falsey
    end
  end

  context "with a rails environment" do
    let(:rails_env) { "development" }

    around(:each) do |example|
      rails     = Object.const_set("Rails", DummyRails)
      env       = DummyRailsEnv.new
      env.value = rails_env
      rails.define_singleton_method(:env) { env }

      example.run

      Object.send(:remove_const, "Rails")
    end

    context "in staging" do
      let(:rails_env) { "staging" }

      it "is enabled" do
        expect(subject.enabled?).to be_truthy
      end
    end

    context "in production" do
      let(:rails_env) { "production" }

      it "is disabled" do
        expect(subject.enabled?).to be_falsey
      end
    end
  end

  context "with default settings" do
    around(:each) do |example|
      orig_env = ENV.to_h.dup
      all_env_settings.each { |i| ENV.delete(i) }
      example.run
      all_env_settings.each { |i| ENV[i] = orig_env[i] }
    end

    it "has a default user name" do
      expect(subject.username).to eq "katalyst"
    end

    it "has a default password" do
      expect(subject.password).to eq "68ccde95e7b6267c"
    end

    it "is not enabled" do
      expect(subject.enabled?).to be_falsey
    end
  end

  describe "#description" do
    it "describes basic auth configuration" do
      expect(described_class.description).to be_kind_of(String)
    end
  end

  describe "#for_path" do
    let!(:config1) { described_class.add(path: "/path1", username: "user1") }
    let!(:config2) { described_class.add(path: "/path2", username: "user2") }

    it "matches path 1" do
      expect(described_class.for_path("/path1/foo/bar.html")).to eq(config1)
    end

    it "matches path 2" do
      expect(described_class.for_path("/path2/foo/bar.html")).to eq(config2)
    end

    it "matches the global config" do
      expect(described_class.for_path("/path3/foo/bar.html")).to eq(described_class.global)
    end
  end
end
