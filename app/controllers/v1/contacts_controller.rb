class V1::ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver
      render status: 200
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
