module CurrentQuestionHelper
  def prefill_value_for_date(field_name)
    if params[:previous_response]
      Date.parse(params[:previous_response])
    else
      prefill_value_for(field_name) && prefill_value_for(field_name).to_i
    end
  end

  def prefill_value_is?(value)
    if params[:previous_response]
      params[:previous_response] == value
    elsif params[:response]
      params[:response] == value
    end
  end

  def default_for_date(value)
    value.blank? ? nil : value.to_i
  end

  def prefill_value_for(question, attribute = nil)
    response = if params[:previous_response]
      question.to_response(params[:previous_response])
    elsif params[:response]
      params[:response]
    end
    if !response.blank? && attribute
      begin
        response[attribute]
      rescue TypeError
        response
      end
    else
      response
    end
  end
end
