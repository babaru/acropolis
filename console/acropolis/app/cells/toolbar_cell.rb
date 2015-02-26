class ToolbarCell < Cell::Rails

  def show(args)
    @css_class = ['btn-toolbar']
    @toolbar = args[:data]
    @css_class << 'pull-right' if @toolbar[:align] == :right
    @css_class = [@css_class, @toolbar[:css_class]].flatten
    render
  end

end
