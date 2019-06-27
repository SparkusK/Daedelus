require 'rails_helper'

RSpec.describe Section, type: :model do
  describe "search" do
    context "with only keywords" do
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct section by section name" do
        incorrect_section = FactoryBot.create(:section, name: "A")
        correct_section = FactoryBot.create(:section, name: "B")
        sections = Section.search(keywords: "B")
        expect(sections.map(&:id)).to contain_exactly(correct_section.id)
      end
    end
  end
end
