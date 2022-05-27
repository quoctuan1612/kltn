module ApplicationHelper
  def active_class? path
    return "active" if request.path == path
  end

  def create_index params_page, index, per_page
    params_page = 1 if params_page.nil?
    (params_page.to_i - 1) * per_page.to_i + index.to_i + 1
  end

  def select_box_category
    Category.all.pluck(:name, :id)
  end

  def select_box_contributor
    User.contributor.pluck(:user_name, :id)
  end

  def select_box_level
    [["Dễ", Settings.question.easy], ["Trung bình", Settings.question.medium], ["Khó", Settings.question.hard]]
  end

  def select_box_exam
    Exam.all.map{|exam| [exam.title, exam.id, data: {category_id: exam.category_id}]}
  end

  def select_box_status
    [["Đã hoàn thành", Settings.attempt.status.finish], ["Chưa hoàn thành", Settings.attempt.status.pending]]
  end

  def select_box_result
    [["Đỗ", Settings.attempt.result.passed], ["Trượt", Settings.attempt.result.failed]]
  end

  def select_box_question_type
    [["Một câu trả lời", Settings.question.single_choice], ["Nhiều câu trả lời", Settings.question.multi_choice]]
  end

  def select_box_level
    [["Dễ", Settings.question.easy], ["Trung bình", Settings.question.medium], ["Khó", Settings.question.hard]]
  end

  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block_given?

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = { }
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = association.to_s.singularize + '_fields'
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = 'javascript:void(0)'
    html_options['class'] = "link-new-answers"

    content_tag(:a, name, html_options, &block)
  end

  def used_question? question
    question.attempt_questions.any?
  end

  def image_url user
    return user.avatar.url if user.avatar?
    AvatarUploader.new.default_url
  end

  def select_box_role
    [["Học viên", Settings.user.role.trainee], ["Giáo viên", Settings.user.role.trainer], ["Quản trị viên", Settings.user.role.admin]]
  end
end
