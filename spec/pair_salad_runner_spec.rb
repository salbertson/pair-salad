require "pair_salad_runner"

describe PairSaladRunner do
  def stub_authors_file
    authors_file = StringIO.new(<<-authors)
sa Scott Albertson
ck Clark Kent
jb Joe Bob
    authors
    File.stub(:open).with('.authors').and_return authors_file
  end

  describe "#run" do
    context "with a .git directory" do
      context "with a .authors file" do
        context "with selected authors" do
          it "sets selected git user's name and email" do
            runner = PairSaladRunner.new
            stub_authors_file

            runner.should_receive(:system).ordered.with("git config user.name 'Clark Kent and Scott Albertson'")
            runner.should_receive(:system).ordered.with("git config user.email 'engineers+ck+sa@streamsend.com'")

            runner.run(["sa", "ck"])
          end

          it "displays pair username" do
            runner = PairSaladRunner.new
            stub_authors_file

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
            stub_authors_file

            runner.should_receive(:system).ordered.with("git config --unset user.name")
            runner.should_receive(:system).ordered.with("git config --unset user.email")

            runner.run([])
          end

          it "displays unset message" do
            runner = PairSaladRunner.new
            stub_authors_file

            runner.should_receive(:puts).with("Unset user.name and user.email")

            runner.run([])
          end
        end
      end

      context "without a .authors file" do
        it "displays message and exits" do
          runner = PairSaladRunner.new
          File.stub(:exists?).with(".git").and_return true
          File.stub(:exists?).with(".authors").and_return false

          message = <<-message
You do not have an .authors file in the repository.
Repository needs a file named .authors in the following format:
  ck Clark Kent
  bw Bruce Wayne
  pp Peter Parker
          message

          runner.should_receive(:puts).with(message)

          expect { runner.run([]) }.to raise_error(SystemExit)
        end
      end
    end

    context "without a .git directory" do
      it "displays message and exits" do
        runner = PairSaladRunner.new
        File.stub(:exists?).with(".git").and_return false

        runner.should_receive(:puts).with("This doesn't look like a git repository.")

        expect { runner.run([]) }.to raise_error(SystemExit)
      end
    end
  end
end
