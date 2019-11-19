class ClaimMailer < Mail::Notify::Mailer
  helper :application
  helper_method :opening_line

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
    translation_string = "#{policy_name(claim)}.emails.#{action_name}.subject"
    I18n.t(translation_string, reference: claim.reference)
  end

  def opening_line(claim, attrs = {})
    translation_string = "#{policy_name(claim)}.emails.#{action_name}.opening_line"
    I18n.t(translation_string, attrs)
  end

  def policy_name(claim)
    claim.policy.to_s.underscore
  end
end
