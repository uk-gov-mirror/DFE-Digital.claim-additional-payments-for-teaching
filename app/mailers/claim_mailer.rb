class ClaimMailer < Mail::Notify::Mailer
  helper :application

  def submitted(claim)
    view_mail_with_claim(claim)
  end

  def approved(claim)
    view_mail_with_claim(claim)
  end

  def rejected(claim)
    view_mail_with_claim(claim)
  end

  def payment_confirmation(claim, payment_date_timestamp)
    @reference = claim.reference
    @payment = claim.payment
    @payment_date = Time.at(payment_date_timestamp).to_date

    view_mail_with_claim(claim)
  end

  private

  def view_mail_with_claim(claim)
    @claim = claim
    @display_name = [claim.first_name, claim.surname].join(" ")

    view_mail(
      ENV["NOTIFY_TEMPLATE_ID"],
      to: @claim.email_address,
      subject: subject_line(claim),
      reply_to_id: claim.policy.notify_reply_to_id
    )
  end

  def subject_line(claim)
    policy_name = claim.policy.to_s.underscore
    translation_string = "#{policy_name}.emails.#{action_name}.subject"
    I18n.t(translation_string, reference: claim.reference)
  end
end
