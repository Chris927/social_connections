class DigestMailer < ActionMailer::Base

  default :from => 'from@example.com'

  append_view_path(File.dirname(__FILE__) + '../../views')

  def digest(feed, email)

    @feed = feed
    @email = email
    mail(:to => @email, :subject => 'Digest') do |format|
      format.html
    end

  end

end
