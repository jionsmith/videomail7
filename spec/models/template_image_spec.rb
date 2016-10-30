require 'rails_helper'

RSpec.describe TemplateImage, type: :model do
  subject do
    create :template_image
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end
end
