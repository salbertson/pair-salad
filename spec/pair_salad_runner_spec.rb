require "pair_salad_runner"

describe PairSaladRunner do
  def stub_config_file
    config_file = StringIO.new(<<-config)
email: engineers@streamsend.com
authors:
  - sa Scott Albertson
  - ck Clark Kent
  - jb Joe Bob
  - co Chris O'Meara
    config
    File.stub(:read).with('.pair').and_return config_file
  end

  describe "#run" do
    context "with a .git directory" do
      before do
        File.stub(:exists?).with(".git").and_return true
      end

      context "with a .pair file" do
        before do
          File.stub(:exists?).with(".pair").and_return true
        end

        context "with selected authors" do
          it "sets selected git user names and email addresses" do
            runner = PairSaladRunner.new
            stub_config_file

            runner.should_receive(:system).ordered.with(%q[git config user.name "Clark Kent and Scott Albertson"])
            runner.should_receive(:system).ordered.with(%q[git config user.email "engineers+ck+sa@streamsend.com"])

            runner.run(["sa", "ck"])
          end

          it "sets selected git user names and email addresses even if one of them has a funny name" do
            runner = PairSaladRunner.new
            stub_config_file

            runner.should_receive(:system).ordered.with(%q[git config user.name "Chris O'Meara and Scott Albertson"])
            runner.should_receive(:system).ordered.with(%q[git config user.email "engineers+co+sa@streamsend.com"])

            runner.run(["sa", "co"])
          end

          it "displays pair username" do
            runner = PairSaladRunner.new
            stub_config_file

            runner.should_receive(:puts).with(<<-message)
user.name = Clark Kent and Scott Albertson
user.email = engineers+ck+sa@streamsend.com
            message

            runner.run(["sa", "ck"])
          end
        end

        context "with no selected authors" do
          it "unsets git user name and email" do
            runner = PairSaladRunner.new
            stub_config_file

            runner.should_receive(:system).ordered.with("git config --unset user.name")
            runner.should_receive(:system).ordered.with("git config --unset user.email")

            runner.run([])
          end

          it "displays unset message" do
            runner = PairSaladRunner.new
            stub_config_file

            runner.should_receive(:puts).with("Unset user.name and user.email")

            runner.run([])
          end
        end
      end

      context "without a .pair file" do
        before do
          File.stub(:exists?).with(".pair").and_return false
        end

        it "displays message and exits" do
          runner = PairSaladRunner.new
          File.stub(:exists?).with(".git").and_return true
          File.stub(:exists?).with(".pair").and_return false

          message = <<-message
You do not have an .pair file in the repository.
Repository needs a file named .pair in the following format:
  email: engineers@streamsend.com
  authors:
    - ck Clark Kent
    - bw Bruce Wayne
    - pp Peter Parker
          message

          runner.should_receive(:puts).with(message)

          expect { runner.run([]) }.to raise_error(SystemExit)
        end
      end
    end

    context "without a .git directory" do
      before do
        File.stub(:exists?).with(".git").and_return false
      end

      it "displays message and exits" do
        runner = PairSaladRunner.new
        File.stub(:exists?).with(".git").and_return false

        runner.should_receive(:puts).with("This doesn't look like a git repository.")

        expect { runner.run([]) }.to raise_error(SystemExit)
      end
    end
  end
end
