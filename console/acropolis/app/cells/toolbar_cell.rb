class ToolbarCell < Cell::Rails

  def show(args)
    @toolbar = args[:data]
    render
  end

end
