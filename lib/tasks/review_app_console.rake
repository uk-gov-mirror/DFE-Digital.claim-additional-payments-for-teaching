def dump_claim(policy)
  claim = FactoryBot.create(:claim, :submitted, policy: policy)

  eligibility_attributes = claim.eligibility.attributes.tap do |attributes|
    attributes.delete("id")
  end

  claim_attributes = claim.attributes.tap do |attributes|
    attributes.delete("id")
  end

  puts <<CONSOLE
  require 'yaml'

  claim = Claim.transaction do
    eligibility_attributes = YAML.load(#{YAML.dump(eligibility_attributes).dump})
    eligibility = #{claim.eligibility.class}.new(eligibility_attributes)
    claim_attributes = YAML.load(#{YAML.dump(claim_attributes).dump})
    claim = Claim.new(claim_attributes.merge(eligibility: eligibility))
    claim.save!

    claim
  end
CONSOLE
end

namespace(:review_app_console) do
  task create_claims: :environment do
    ENV["FIXTURES_PATH"] = "spec/fixtures"
    ENV["FIXTURES"] = "local_authorities,local_authority_districts,schools"
    Rake::Task["db:fixtures:load"].invoke

    5.times { dump_claim(StudentLoans) }
    5.times { dump_claim(MathsAndPhysics) }
  end

  task delete_everything: :environment do
    commands = []

    Policies.all.each do |policy|
      commands << "#{policy}::Eligibility.delete_all"
    end

    commands << "Amendment.delete_all"
    commands << "Claim.delete_all"
    commands << "Payment.delete_all"
    commands << "PayrollRun.delete_all"

    puts commands.join("; ")
  end
end
