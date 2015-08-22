Puppet::Functions.create_function(:user_input) do
  dispatch :user_input do
    param 'Struct[{title       => String[1],
                   desc        => Optional[String[1]],
                   default     => Optional[String[1]],
                   hidden      => Optional[Boolean]
                   failonempty => Optional[Boolean]}]', :params
  end

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
      "#{'with hidden answer' if params[:hidden]})",
    ]
  end

  def defaults
    { desc: '', default: '', hidden: false, failonempty: false }
  end
end
