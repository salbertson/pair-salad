require "yaml"

class PairSaladRunner
  def run(args)
    @pair_initials = args.sort

    check_for_git_directory
    check_for_config_file

    @authors = parse_authors_from_file

    if @authors.any?
      git_username = build_username
      system("git config user.name \"#{git_username}\"")

      git_email_address = build_email_address
      system("git config user.email \"#{git_email_address}\"")

      puts <<-message
user.name = #{git_username}
user.email = #{git_email_address}
      message
    else
      system("git config --unset user.name")
      system("git config --unset user.email")

      puts "Unset user.name and user.email"
    end
  end

  private

  def check_for_git_directory
    unless File.exists?(".git")
      puts "This doesn't look like a git repository."
      exit 1
    end
  end

  def check_for_config_file
    unless File.exists?(".pair")
      puts <<-message
You do not have an .pair file in the repository.
Repository needs a file named .pair in the following format:
  email: engineers@example.com
  authors:
    - ck Clark Kent
    - bw Bruce Wayne
    - pp Peter Parker
      message

      exit 1
    end
  end

  def parse_authors_from_file
    authors = {}
    configuration["authors"].each do |author_line|
      initials, name = author_line.match(/^(\w+)\s+(.*)$/).captures
      if @pair_initials.include? initials
        authors[initials] = name
      end
    end
    authors
  end

  def build_username
    author_name = ""
    @pair_initials.each_with_index do |initials, index|
      if index > 0
        author_name << " and #{@authors[initials]}"
      else
        author_name << @authors[initials]
      end
    end
    author_name
  end

  def build_email_address
    prefix, hostname = configuration["email"].split("@")
    "#{prefix}+#{@pair_initials.join("+")}@#{hostname}"
  end

  def configuration
    @configuration ||= YAML.load(File.read('.pair'))
  end
end
