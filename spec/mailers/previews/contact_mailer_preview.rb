class ContactMailerPreview < ActionMailer::Preview

  def contact_mail
    ContactMailer.contact_mail
  end
end
