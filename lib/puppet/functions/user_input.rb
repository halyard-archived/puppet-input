Puppet::Functions.create_function(:user_input) do
  param 'Struct[{title                 => String[1],
                 Optional[desc]        => String[1],
                 Optional[default]     => String[1],
                 Optional[hidden]      => Boolean
                 Optional[failonempty] => Boolean}]', :params

  def user_input(params)
    params = defaults.dup.merge(params)
    command = prompt_command(params).join(' ')
    result = `/usr/bin/osascript -e '#{command}'`.chomp
    fail('No response provided') if result.empty? && params[:failonempty]
    result
  end

  def prompt_command(params)
    [
      'text returned of (display dialog',
      %W{"#{params[:desc]}"},
      %W{with title "#{params[:title]}"},
      'with icon caution',
      %W{default answer "#{params[:default]}"},
      'buttons {"Cancel", "OK"} default button 2',
      "#{'with hidden answer' if params[:is_hidden]})",
    ]
  end

  def defaults
    { desc: '', default: '', hidden: false, failonempty: false }
  end
end
