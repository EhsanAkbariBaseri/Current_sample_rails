class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  layout 'mailer'
  # Chooses the layout from app/views/layouts/mailer.html.erb
end
