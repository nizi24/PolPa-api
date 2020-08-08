require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  describe "contact_mail" do
    let(:contact) { create(:contact, name: 'foobar',
      email: 'test@example.com',
      message: 'Thanks.') }
    let(:mail) { ContactMailer.contact_mail(contact) }

    it "renders the headers" do
      expect(mail.subject).to eq("お問い合わせ通知")
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("foobar")
      expect(mail.body.encoded).to match("test@example.com")
      expect(mail.body.encoded).to match("Thanks.")
    end
  end

end
