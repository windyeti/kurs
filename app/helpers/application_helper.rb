module ApplicationHelper
  def flash_class(level)
    case level
    when 'info' then "alert alert-info"
    when 'notice','success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-warning"
    end
  end

  def step_setup(resource)
    if resource
      status = resource.status
      ready = resource.ready
      if ready && status
        "Установлена и Оплачена"
      else

      end
    else
      "Не установлена и не оплачена"
    end

  end
end
